//
//  ApplicationDelegate.swift
//  ui example
//
//  Created by 傅立业 on 2018/6/25.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

import UIKit

import ui

internal class ApplicationDelegate : NSObject, UIApplicationDelegate {
	internal func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil
	) -> Bool {
		let application = application as! Application
		
		let window = application.window
		window.makeKeyAndVisible()
		
		let navigationController = application.navigationController
		window.rootViewController = navigationController
		
		let homeViewController = HomeViewController()
		navigationController.viewControllers = [homeViewController]
		
		return true
	}
}
