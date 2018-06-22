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
		describe("`NavigationController`") {
			var navigationController: NavigationController!
			
			beforeEach {
				navigationController = NavigationController()
			}
			
			describe("`childViewControllerForStatusBarStyle`") {
				it("should be the top view controller") {
					expect(navigationController.childViewControllerForStatusBarStyle).to(beNil())
					
					let firstViewController = UIViewController()
					navigationController.pushViewController(firstViewController)
					expect(navigationController.childViewControllerForStatusBarStyle) == firstViewController
					
					let secondViewController = UIViewController()
					navigationController.pushViewController(secondViewController)
					expect(navigationController.childViewControllerForStatusBarStyle) == secondViewController
				}
			}
			
			describe("`supportedInterfaceOrientations`") {
				it("should be `.all` if there is no child view controller") {
					expect(navigationController.supportedInterfaceOrientations) == .all
				}
				
				it("should be provided by the top view controller if existing") {
					let firstViewController = ViewController()
					firstViewController.settings.supportedInterfaceOrientations = .allButUpsideDown
					navigationController.pushViewController(firstViewController)
					expect(navigationController.supportedInterfaceOrientations) == .allButUpsideDown
					
					let secondViewController = ViewController()
					secondViewController.settings.supportedInterfaceOrientations = .landscape
					navigationController.pushViewController(secondViewController)
					expect(navigationController.supportedInterfaceOrientations) == .landscape
					
					let thirdViewController = ViewController()
					thirdViewController.settings.supportedInterfaceOrientations = .all
					navigationController.pushViewController(thirdViewController)
					expect(navigationController.supportedInterfaceOrientations) == .all
				}
			}
			
			describe("`pushViewController(_:, animated:)`") {
				it("should execute immediately if there is currently no child view controllers") {
					let viewController = UIViewController()
					navigationController.pushViewController(viewController)
					
					expect(navigationController.childViewControllers) == [viewController]
				}
				
				it("should execute after a moment if there is at least one child view controller") {
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
			}
			
			describe("`popViewController(animated:)`") {
				it("should do nothing and return `nil` if there is no more than one child view controller") {
					expect(navigationController.popViewController()).to(beNil())
					expect(navigationController.viewControllers) == []
					
					let viewController = UIViewController()
					navigationController.pushViewController(viewController)
					expect(navigationController.popViewController()).to(beNil())
					expect(navigationController.viewControllers) == [viewController]
				}
				
				it("should return the top view controller and execute after a moment if there is at least two child view controllers") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					navigationController.viewControllers = [firstViewController, secondViewController]
					expect(navigationController.popViewController()) == secondViewController
					expect(navigationController.childViewControllers) == [firstViewController, secondViewController]
					
					waitUntil { done in
						RunLoop.current.perform(inModes: [.commonModes], block: {
							expect(navigationController.childViewControllers) == [firstViewController]
							done()
						})
					}
				}
			}
			
			describe("`popToRootViewController(animated:)`") {
				it("should do nothing and return an empty array if there is no more than one child view controller") {
					expect(navigationController.popToRootViewController()) == []
					expect(navigationController.viewControllers) == []
					
					let viewController = UIViewController()
					navigationController.pushViewController(viewController)
					expect(navigationController.popToRootViewController()).to(beEmpty())
					expect(navigationController.viewControllers) == [viewController]
				}
				
				it("should return an array of popped view controllers and execute after a moment if there is at least two child view controllers") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					let thirdViewController = UIViewController()
					navigationController.viewControllers = [firstViewController, secondViewController, thirdViewController]
					expect(navigationController.popToRootViewController()) == [secondViewController, thirdViewController]
					expect(navigationController.childViewControllers) == [firstViewController, secondViewController, thirdViewController]
					
					waitUntil { done in
						RunLoop.current.perform(inModes: [.commonModes], block: {
							expect(navigationController.childViewControllers) == [firstViewController]
							done()
						})
					}
				}
			}
			
			describe("`viewControllers") {
				it("should reflect all transition requests immediately") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					let thirdViewController = UIViewController()
					
					navigationController.viewControllers = [thirdViewController]
					expect(navigationController.viewControllers) == [thirdViewController]
					
					navigationController.viewControllers = [firstViewController, secondViewController]
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]

					navigationController.popViewController()
					expect(navigationController.viewControllers) == [firstViewController]
					
					navigationController.pushViewController(secondViewController)
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					
					navigationController.popViewController(animated: true)
					expect(navigationController.viewControllers) == [firstViewController]
					
					navigationController.pushViewController(secondViewController)
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					
					navigationController.popViewController()
					expect(navigationController.viewControllers) == [firstViewController]
					
					navigationController.pushViewController(secondViewController, animated: true)
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]

					navigationController.pushViewController(thirdViewController)
					expect(navigationController.viewControllers) == [firstViewController, secondViewController, thirdViewController]
					
					navigationController.popToRootViewController(animated: true)
					expect(navigationController.viewControllers) == [firstViewController]
					
					navigationController.viewControllers = [secondViewController, thirdViewController]
					expect(navigationController.viewControllers) == [secondViewController, thirdViewController]
					
					navigationController.setViewControllers([thirdViewController, secondViewController, firstViewController], animated: true)
					expect(navigationController.viewControllers) == [thirdViewController, secondViewController, firstViewController]
					
					navigationController.popToRootViewController()
					expect(navigationController.viewControllers) == [thirdViewController]
				}
			}
		}
	}
}
