//
//  NavigationControllerSpec.swift
//  ui
//
//  Created by 傅立业 on 2018/6/21.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

import Nimble
import Quick

import ui

internal class NavigationControllerSpec : QuickSpec {
	override
	internal func spec() {
		describe("NavigationController") {
			var navigationController: NavigationController!
			
			beforeEach {
				navigationController = NavigationController()
			}
			
			it("should push initial view controller immediately") {
				let viewController = UIViewController()
				navigationController.pushViewController(viewController)
				
				expect(navigationController.childViewControllers) == [viewController]
			}
			
			it("should push non-initial view controller in next run loop") {
				let firstViewController = UIViewController()
				navigationController.pushViewController(firstViewController)
				
				let secondViewController = UIViewController()
				navigationController.pushViewController(secondViewController)
				
				expect(navigationController.childViewControllers) == [firstViewController]
				
				waitUntil { done in
					RunLoop.current.perform(inModes: [.commonModes], block: {
						expect(navigationController.childViewControllers) == [firstViewController, secondViewController]
						
						done()
					})
				}
			}
			
			it("should reflect all transition requests in its viewControllers immediately") {
				let firstViewController = UIViewController()
				navigationController.pushViewController(firstViewController)
				expect(navigationController.viewControllers) == [firstViewController]
				
				let secondViewController = UIViewController()
				navigationController.pushViewController(secondViewController)
				expect(navigationController.viewControllers) == [firstViewController, secondViewController]
				
				navigationController.popViewController()
				expect(navigationController.viewControllers) == [firstViewController]
				
				navigationController.pushViewController(secondViewController, animated: true)
				expect(navigationController.viewControllers) == [firstViewController, secondViewController]
				
				let thirdViewController = UIViewController()
				navigationController.pushViewController(thirdViewController)
				expect(navigationController.viewControllers) == [firstViewController, secondViewController, thirdViewController]
				
				navigationController.popToRootViewController(animated: true)
				expect(navigationController.viewControllers) == [firstViewController]
				
				navigationController.viewControllers = [secondViewController, thirdViewController]
				expect(navigationController.viewControllers) == [secondViewController, thirdViewController]
				
				navigationController.setViewControllers([thirdViewController, secondViewController, firstViewController], animated: true)
				expect(navigationController.viewControllers) == [thirdViewController, secondViewController, firstViewController]
			}
		}
	}
}
