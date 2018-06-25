//
//  DummyViewExampleViewController.swift
//  ui example
//
//  Created by 傅立业 on 2018/6/25.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

import UIKit

import ui

internal class DummyViewExampleViewController : ViewController {
	// MARK: Interface Builder
	
	@IBOutlet
	private var dummyView: DummyView!
	
	@IBAction
	private func handleButton() {
		let alertController = UIAlertController(
			title: nil,
			message: """
			See?
			The button is responsive even when its covered!
			""",
			preferredStyle: .alert
		)
		
		alertController.addAction(
			UIAlertAction(title: "Close", style: .default, handler: nil)
		)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	// MARK: Override - UIViewController
	
	override
	internal func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		UIView.animateKeyframes(
			withDuration: 2,
			delay: 0,
			options: [.allowUserInteraction, .autoreverse, .repeat],
			animations: {
				self.dummyView.alpha = 1
				self.dummyView.alpha = 0
			},
			completion: nil
		)
	}
}
