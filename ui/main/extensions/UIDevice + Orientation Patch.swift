//
//  UIDevice + Orientation Patch.swift
//  ui
//
//  Created by 傅立业 on 2018/6/25.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

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
