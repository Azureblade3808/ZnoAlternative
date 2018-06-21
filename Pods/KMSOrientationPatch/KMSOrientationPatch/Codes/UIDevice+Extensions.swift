//
//  UIDevice+Extensions.swift
//  KMSOrientationPatch
//
//  Created by 傅立业 on 11/08/2017.
//  Copyright 2017 傅立业
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

public extension UIDevice {
	/// Tests whether a rotation is required to present the specified view controller.
	/// - parameters:
	/// 	- viewController: The view controller to present.
	/// - returns: Whether a rotation is required.
	@objc
	public static func isRotationRequiredToPresent(_ viewController: UIViewController) -> Bool {
		let application = UIApplication.shared
		let orientation = application.statusBarOrientation
		
		let suppportedOrientations = viewController.supportedInterfaceOrientations
		let isRotationRequired = !suppportedOrientations.contains(orientation)
		
		return isRotationRequired
	}

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
