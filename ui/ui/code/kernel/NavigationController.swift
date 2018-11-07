//	MIT License
//
//	Copyright (c) 2018 傅立业（Chris Fu）
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.

import UIKit

/// A customized navigation controller.
open class NavigationController : UINavigationController {
	// MARK: Override - UINavigationController
	
	override
	open var childForStatusBarStyle: UIViewController? {
		return topViewController
	}
	
	// MARK: Override - UIViewController
	
	override
	open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return topViewController?.supportedInterfaceOrientations ?? .all
	}
	
	// MARK: Fix for Transition Sequence
	
	// When a UINavigationController received multiple transition requests in a row,
	// its behavior(mostly animation) could be wrong and vary between different
	// versions of iOS.
	
	// In order to split the responsibility of transitioning between workflows,
	// we are making fixes, which follow rules --
	// 1. A transition request launched in one run loop will NOT be executed
	//    immediately. Transition requests in the same run loop will be gathered
	//    and executed at once in the next run loop.
	// 2. If AT LEAST ONE transition request in a sequence adopts animation, the
	//    final execution adopts animation.
	// 3. `pushViewController(animated:)`, `popViewController(animated:)`,
	//    `popToViewController(_:animated:)`, `popToRootViewController(animated:)`,
	//    `setViewControllers(_:animated:)` requests are gathered.
	// 4. A `viewControllers.setter` request should be executed immediately if
	//    there is no pending transition at that point or should be gathered
	//    otherwise.
	// 5. `viewControllers.getter` should reflect status of the pending transition
	//    if it exists.

	internal private(set) var pendingTransition: (viewControllers: [UIViewController], animated: Bool)? = nil
	
	private var pendingTransitionTimer: Timer? = nil
	
	internal func scheduleTransition(_ viewControllers: [UIViewController], _ animated: Bool) {
		if pendingTransitionTimer == nil {
			let timer = Timer(timeInterval: 0, repeats: false) { _ in
				self.applyPendingTransition()
			}
			for mode: RunLoop.Mode in [RunLoop.Mode.common, RunLoop.Mode.tracking] {
				RunLoop.current.add(timer, forMode: mode)
			}
			pendingTransitionTimer = timer
		}
		
		pendingTransition = (viewControllers, animated)
	}
	
	internal func applyPendingTransition() {
		if let pendingTransition = pendingTransition {
			super.setViewControllers(pendingTransition.viewControllers, animated: pendingTransition.animated)
			self.pendingTransition = nil
		}
		
		if let pendingTransitionTimer = pendingTransitionTimer {
			pendingTransitionTimer.invalidate()
			self.pendingTransitionTimer = nil
		}
	}
	
	override
	open var viewControllers: [UIViewController] {
		get {
			return pendingTransition?.viewControllers ?? super.viewControllers
		}
		
		set {
			if pendingTransition != nil {
				scheduleTransition(newValue, false)
			}
			else {
				super.setViewControllers(newValue, animated: false)
			}
		}
	}
	
	override
	open func pushViewController(_ viewController: UIViewController, animated: Bool) {
		var viewControllers = pendingTransition?.viewControllers ?? super.viewControllers
		viewControllers.append(viewController)
		let animated = animated || pendingTransition?.animated ?? false
		scheduleTransition(viewControllers, animated)
	}
	
	@discardableResult
	override
	open func popViewController(animated: Bool) -> UIViewController? {
		let poppedViewController: UIViewController?
		
		var viewControllers = pendingTransition?.viewControllers ?? super.viewControllers
		if viewControllers.count > 1 {
			poppedViewController = viewControllers.removeLast()
			let animated = animated || pendingTransition?.animated ?? false
			scheduleTransition(viewControllers, animated)
		}
		else {
			poppedViewController = nil
		}
		
		return poppedViewController
	}
	
	@discardableResult
	override
	open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
		let poppedViewControllers: [UIViewController]?
		
		var viewControllers = pendingTransition?.viewControllers ?? super.viewControllers
		if let index = viewControllers.index(of: viewController) {
			poppedViewControllers = Array(viewControllers[(index + 1)...])
			viewControllers = Array(viewControllers[...index])
			let animated = animated || pendingTransition?.animated ?? false
			scheduleTransition(viewControllers, animated)
		}
		else {
			poppedViewControllers = nil
		}
		
		return poppedViewControllers
	}
	
	@discardableResult
	override
	open func popToRootViewController(animated: Bool) -> [UIViewController]? {
		let poppedViewControllers: [UIViewController]?
		
		var viewControllers = pendingTransition?.viewControllers ?? super.viewControllers
		if !viewControllers.isEmpty {
			poppedViewControllers = Array(viewControllers[1...])
			viewControllers = [viewControllers[0]]
			let animated = animated || pendingTransition?.animated ?? false
			scheduleTransition(viewControllers, animated)
		}
		else {
			poppedViewControllers = nil
		}
		
		return poppedViewControllers
	}
	
	override
	open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
		let animated = animated || pendingTransition?.animated ?? false
		scheduleTransition(viewControllers, animated)
	}
}
