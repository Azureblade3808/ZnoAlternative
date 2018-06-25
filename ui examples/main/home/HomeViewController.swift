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
	private func handleAnnotionViewExampleButton() {
		AnnotionViewExampleViewController().open(animated: true)
	}
	
	@IBAction
	private func handleDummyViewExampleButton() {
		DummyViewExampleViewController().open(animated: true)
	}

	@IBAction
	private func handleNavigationControllerExampleButton() {
		NavigationControllerExampleViewController().open(animated: true)
	}
}
