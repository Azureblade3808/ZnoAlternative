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

/// A customized application.
open class Application : UIApplication {
	// MARK: Output
	
	/// The main window.
	public private(set) lazy var window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
	
	/// The main navigation controller.
	public private(set) lazy var navigationController: NavigationController = NavigationController()
	
	// MARK: Manipulation
	
	/// The front-most view controller.
	public var frontViewController: UIViewController {
		var viewController: UIViewController = navigationController
		while true {
			if let presentedViewController = viewController.presentedViewController {
				viewController = presentedViewController
				continue
			}
			
			if let navigationController = viewController as? UINavigationController {
				if let topViewController = navigationController.topViewController {
					viewController = topViewController
					continue
				}
			}
			
			break
		}
		
		return viewController
	}
	
	// MARK: Override - UIApplication
	
	override
	open class var shared: Application {
		return super.shared as! Application
	}
}
