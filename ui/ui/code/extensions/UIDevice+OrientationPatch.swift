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

public extension UIDevice {
	/// Performs a fake device rotation, if the active view controller is not currently
	/// in its supported interface orientation, to let it have a chance to rotate
	/// to one of its supported interface orientations.
	@objc
	public static func attemptRotationToSupportedOrientations() {
		let application = UIApplication.shared
		let device = UIDevice.current
		
		guard let keyWindow = application.keyWindow else {
			return
		}
		
		guard let rootViewController = keyWindow.rootViewController else {
			return
		}
		
		let activeViewController: UIViewController = {
			var viewController: UIViewController = rootViewController
			
			while let presentedViewController = viewController.presentedViewController {
				if presentedViewController.isBeingDismissed {
					break
				}
				
				viewController = presentedViewController
			}
			
			return viewController
		} ()
		
		let supportedInterfaceOrientations = activeViewController.supportedInterfaceOrientations
		
		let interfaceOrientation = application.statusBarOrientation
		if supportedInterfaceOrientations.contains(interfaceOrientation) {
			return
		}
		
		let deviceOrientation = device.orientation
		
		guard let preferredInterfaceOrientation: UIInterfaceOrientation = {
			let originalOrientation = UIInterfaceOrientation(deviceOrientation: deviceOrientation) ?? interfaceOrientation
			let leftOrientation = originalOrientation.leftOrientation
			let rightOrientation = originalOrientation.rightOrientation
			let oppositeOrientation = originalOrientation.oppositeOrientation
			
			for orientation in [ originalOrientation, leftOrientation, rightOrientation, oppositeOrientation ] {
				if supportedInterfaceOrientations.contains(orientation) {
					return orientation
				}
			}
			
			return nil
		} () else {
			return
		}
		
		guard let preferredDeviceOrientation = UIDeviceOrientation(interfaceOrientation: preferredInterfaceOrientation) else {
			return
		}
		
		let tempDeviceOrientation = (preferredDeviceOrientation == deviceOrientation ? .unknown : preferredDeviceOrientation)
		device.setOrientation(tempDeviceOrientation)
		
		device.setOrientation(deviceOrientation)
	}
	
	private func setOrientation(_ orientation: UIDeviceOrientation) {
		setValue(orientation.rawValue, forKey: "orientation")
	}
}

extension UIInterfaceOrientationMask {
	fileprivate func contains(_ orientation: UIInterfaceOrientation) -> Bool {
		return (Int(rawValue) & (1 << orientation.rawValue)) != 0
	}
}

extension UIDeviceOrientation {
	fileprivate init?(interfaceOrientation: UIInterfaceOrientation) {
		switch interfaceOrientation {
			case .portrait:
			self = .portrait
			
			case .portraitUpsideDown:
			self = .portraitUpsideDown
			
			case .landscapeLeft:
			self = .landscapeLeft
			
			case .landscapeRight:
			self = .landscapeRight
			
			default:
			return nil
		}
	}
}

extension UIInterfaceOrientation {
	fileprivate init?(deviceOrientation: UIDeviceOrientation) {
		switch deviceOrientation {
			case .portrait:
			self = .portrait
			
			case .portraitUpsideDown:
			self = .portraitUpsideDown
			
			case .landscapeLeft:
			self = .landscapeLeft
			
			case .landscapeRight:
			self = .landscapeRight
			
			default:
			return nil
		}
	}
	
	fileprivate var leftOrientation: UIInterfaceOrientation {
		switch self {
			case .portrait:
			return .landscapeLeft
			
			case .portraitUpsideDown:
			return .landscapeRight
			
			case .landscapeLeft:
			return .portraitUpsideDown
			
			case .landscapeRight:
			return .portrait
			
			default:
			fatalError()
		}
	}
	
	fileprivate var rightOrientation: UIInterfaceOrientation {
		switch self {
			case .portrait:
			return .landscapeRight
			
			case .portraitUpsideDown:
			return .landscapeLeft
			
			case .landscapeLeft:
			return .portrait
			
			case .landscapeRight:
			return .portraitUpsideDown
			
			default:
			fatalError()
		}
	}
	
	fileprivate var oppositeOrientation: UIInterfaceOrientation {
		switch self {
			case .portrait:
			return .portraitUpsideDown
			
			case .portraitUpsideDown:
			return .portrait
			
			case .landscapeLeft:
			return .landscapeRight
			
			case .landscapeRight:
			return .landscapeLeft
			
			default:
			fatalError()
		}
	}
}
