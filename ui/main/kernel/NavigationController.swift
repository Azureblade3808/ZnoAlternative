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
	open var childViewControllerForStatusBarStyle: UIViewController? {
		return topViewController
	}
	
	// MARK: Override - UIViewController
	
	override
	open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return topViewController?.supportedInterfaceOrientations ?? .all
	}
	
	// MARK: Fix for Push/Pop Sequence
	
	// When a UINavigationController received multiple Push/Pop requests in a row,
	// its behavior(mostly animation) could be wrong and vary between different
	// versions of iOS.
	
	// In order to split the responsibility of transitioning between workflows,
	// we are making following fixes, rules of which are --
	// 1. A transition request launched in one run loop WILL NOT be executed in
	//    the same run loop, unless it is causing the initialization(setting
	//    the root view controller). Transition requests in the same run loop
	//    will be gathered and executed at once in the next run loop.
	// 2. Pending transition requests DO affect property "viewControllers".
	// 3. If at least ONE transition requests in a sequence adopts animation,
	//    the final execution adopts animation.
	
	private var targetState: (viewControllers: [UIViewController], animated: Bool)? = nil
	
	private func scheduleUpdatingState() {
		RunLoop.current.perform(inModes: [.commonModes, .UITrackingRunLoopMode]) {
			self.updateState()
		}
	}
	
	private func updateState() {
		if let (viewControllers, animated) = targetState {
			super.setViewControllers(viewControllers, animated: animated)
		}
		
		targetState = nil
	}
	
	override
	open var viewControllers: [UIViewController] {
		get {
			return targetState?.viewControllers ?? super.viewControllers
		}
		
		set {
			setViewControllers(newValue, animated: false)
		}
	}
	
	override
	open func pushViewController(_ viewController: UIViewController, animated: Bool = false) {
		if super.viewControllers.isEmpty {
			assert(targetState == nil)
			
			super.setViewControllers([viewController], animated: false)
			
			return
		}
		
		if let formerTargetState = targetState {
			var viewControllers = formerTargetState.viewControllers
			viewControllers.append(viewController)
			
			let animated = animated || formerTargetState.animated
			
			targetState = (viewControllers, animated)
		}
		else {
			var viewControllers = super.viewControllers
			viewControllers.append(viewController)
			
			targetState = (viewControllers, animated)
			
			scheduleUpdatingState()
		}
	}
	
	@discardableResult
	override
	open func popViewController(animated: Bool = false) -> UIViewController? {
		if let formerTargetState = targetState {
			var viewControllers = formerTargetState.viewControllers
			guard viewControllers.count > 1 else { return nil }
			
			let poppedViewController = viewControllers.removeLast()
			
			let animated = animated || formerTargetState.animated
			
			targetState = (viewControllers, animated)
			
			return poppedViewController
		}
		else {
			var viewControllers = super.viewControllers
			guard viewControllers.count > 1 else { return nil }
			
			let poppedViewController = viewControllers.removeLast()
			
			targetState = (viewControllers, animated)
			
			scheduleUpdatingState()
			
			return poppedViewController
		}
	}
	
	@discardableResult
	override
	open func popToRootViewController(animated: Bool = false) -> [UIViewController]? {
		if let formerTargetState = targetState {
			var viewControllers = formerTargetState.viewControllers
			guard viewControllers.count > 1 else { return [] }
			
			let poppedViewControllers = Array(viewControllers[1...])
			viewControllers = [viewControllers[0]]
			
			let animated = animated || formerTargetState.animated
			
			targetState = (viewControllers, animated)
			
			return poppedViewControllers
		}
		else {
			var viewControllers = super.viewControllers
			guard viewControllers.count > 1 else { return [] }
			
			let poppedViewControllers = Array(viewControllers[1...])
			viewControllers = [viewControllers[0]]
			
			targetState = (viewControllers, animated)
			
			scheduleUpdatingState()
			
			return poppedViewControllers
		}
	}
	
	override
	open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool = false) {
		if super.viewControllers.isEmpty {
			assert(targetState == nil)
			
			super.setViewControllers(viewControllers, animated: false)
			
			return
		}
		
		if let formerTargetState = targetState {
			let animated = animated || formerTargetState.animated
			
			targetState = (viewControllers, animated)
		}
		else {
			targetState = (viewControllers, animated)
			
			scheduleUpdatingState()
		}
	}
}
