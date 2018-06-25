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

import KMSOrientationPatch
import UIKit

/// A customizable view controller.
open class ViewController : UIViewController {
	// MARK: Settings
	
	public var settings: Settings = Settings()
	
	// MARK: Interface Builder
	
	/// Title.
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `title` instead.")
	private var _Title: String? {
		get {
			return title
		}
		
		set {
			title = newValue
		}
	}
	
	/// Whether this view controller should be presented when it is opened.
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `settings` instead.")
	private var _Presents: Bool {
		get {
			return settings.openingStyle == .present
		}
		
		set {
			settings.openingStyle = newValue ? .present : .push
		}
	}
	
	/// Whether this view controller should display with a status bar.
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `settings` instead.")
	private var _StatusBar: Bool {
		get {
			return !settings.prefersStatusBarHidden
		}
		
		set {
			settings.prefersStatusBarHidden = !newValue
		}
	}
	
	/// Whether the style of status bar for this view controller should be
	/// `UIStatusBar.lightContent`.
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `settings` instead.")
	private var _WhiteStatus: Bool {
		get {
			return settings.preferredStatusBarStyle == .lightContent
		}
		
		set {
			settings.preferredStatusBarStyle = newValue ? .lightContent : .default
		}
	}
	
	/// Whether this view controller should keep the navigation bar in its
	/// navigation controller.
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `settings` instead.")
	private var _NavigationBar: Bool {
		get {
			return !settings.prefersNavigationBarHidden
		}
		
		set {
			settings.prefersNavigationBarHidden = !newValue
		}
	}
	
	/// Whether this view controller supports `.portrait` interface orientation.
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `settings` instead.")
	private var _Portrait: Bool {
		get { return settings.supportedInterfaceOrientations.contains(.portrait) }
		
		set {
			if newValue {
				settings.supportedInterfaceOrientations.insert(.portrait)
			}
			else {
				settings.supportedInterfaceOrientations.remove(.portrait)
			}
		}
	}
	
	/// Whether this view controller supports `.landscapeLeft` interface orientation.
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `settings` instead.")
	private var _Left: Bool {
		get { return settings.supportedInterfaceOrientations.contains(.landscapeLeft) }
		
		set {
			if newValue {
				settings.supportedInterfaceOrientations.insert(.landscapeLeft)
			}
			else {
				settings.supportedInterfaceOrientations.remove(.landscapeLeft)
			}
		}
	}
	
	/// Whether this view controller supports `.landscapeRight` interface orientation.
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `settings` instead.")
	private var _Right: Bool {
		get { return settings.supportedInterfaceOrientations.contains(.landscapeRight) }
		
		set {
			if newValue {
				settings.supportedInterfaceOrientations.insert(.landscapeRight)
			}
			else {
				settings.supportedInterfaceOrientations.remove(.landscapeRight)
			}
		}
	}
	
	/// Whether this view controller supports `.portraitUpsideDown` interface orientation.
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `settings` instead.")
	private var _UpsideDown: Bool {
		get { return settings.supportedInterfaceOrientations.contains(.portraitUpsideDown) }
		
		set {
			if newValue {
				settings.supportedInterfaceOrientations.insert(.portraitUpsideDown)
			}
			else {
				settings.supportedInterfaceOrientations.remove(.portraitUpsideDown)
			}
		}
	}

	// MARK: Manipulation
	
	public func open(animated: Bool = false) {
		precondition(parent == nil)
		precondition(presentingViewController == nil)
		
		let application = Application.shared
		
		switch settings.openingStyle {
			case .push: if true {
				let navigationController = application.navigationController
				navigationController.pushViewController(self, animated: animated)
			}
			
			case .present: if true {
				let frontViewController = application.frontViewController
				frontViewController.present(self, animated: animated)
			}
		}
	}
	
	public func close(animated: Bool = false) {
		if presentingViewController != nil {
			self.dismiss(animated: animated)
			return
		}
		
		if let navigationController = navigationController {
			var viewControllers = navigationController.viewControllers
			if let index = viewControllers.index(of: self) {
				viewControllers.remove(at: index)
				navigationController.setViewControllers(viewControllers, animated: animated)
			}
			return
		}
	}
	
	// MARK: Private
	
	private func setup() {
		// Force loading view from NIB.
		_ = view
	}
	
	// MARK: Override - UIViewController
	
	override
	public init(nibName: String?, bundle: Bundle?) {
		super.init(nibName: nibName, bundle: bundle)
		
		setup()
	}
	
	required
	public init?(coder: NSCoder) {
		super.init(coder: coder)
		
		setup()
	}
	
	override
	open var prefersStatusBarHidden: Bool {
		return settings.prefersStatusBarHidden
	}
	
	override
	open var preferredStatusBarStyle: UIStatusBarStyle {
		return settings.preferredStatusBarStyle
	}
	
	override
	open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return settings.supportedInterfaceOrientations
	}
	
	override
	open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let navigationController = navigationController {
			if parent == navigationController {
				navigationController.setNavigationBarHidden(settings.prefersNavigationBarHidden, animated: animated)
			}
		}
		
		UIDevice.attemptRotationToSupportedOrientations()
	}
	
	// MARK: Embedded
	
	public enum OpeningStyle {
		case push
		
		case present
	}
	
	public struct Settings {
		public var openingStyle: OpeningStyle = .push
		
		public var prefersStatusBarHidden: Bool = false
		
		public var preferredStatusBarStyle: UIStatusBarStyle = .default
		
		public var prefersNavigationBarHidden: Bool = false
		
		public var supportedInterfaceOrientations: UIInterfaceOrientationMask = .all
	}
}
