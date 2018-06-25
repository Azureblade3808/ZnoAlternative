//
//  HomeViewController.swift
//  ui example
//
//  Created by 傅立业 on 2018/6/25.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

import UIKit

import ui

internal class HomeViewController : ViewController {
	// MARK: Interface Builder
	
	@IBAction
	private func handleNavigationControllerExampleButton() {
		let viewController = NavigationControllerExampleViewController()
		viewController.open(animated: true)
	}
	
	@IBAction
	private func handleDummyViewExampleButton() {
		let viewController = DummyViewExampleViewController()
		viewController.open(animated: true)
	}
}
