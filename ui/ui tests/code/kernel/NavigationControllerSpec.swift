//
//  NavigationControllerSpec.swift
//  ui
//
//  Created by 傅立业 on 2018/6/21.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

import Nimble
import Quick

@testable
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
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllerForStatusBarStyle).to(beNil())
					
					navigationController.pushViewController(firstViewController, animated: false)
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.childViewControllerForStatusBarStyle) == firstViewController
					
					navigationController.pushViewController(secondViewController, animated: false)
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					expect(navigationController.childViewControllerForStatusBarStyle) == secondViewController
					
					navigationController.popViewController(animated: false)
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.childViewControllerForStatusBarStyle) == firstViewController
				}
			}
			
			describe("`supportedInterfaceOrientations`") {
				it("should be `.all` if there is no child view controller") {
					expect(navigationController.viewControllers) == []
					expect(navigationController.supportedInterfaceOrientations) == .all
				}
				
				it("should be provided by the top view controller if existing") {
					let firstViewController = ViewController()
					firstViewController.settings.supportedInterfaceOrientations = .allButUpsideDown
					
					let secondViewController = ViewController()
					secondViewController.settings.supportedInterfaceOrientations = .landscape
					
					let thirdViewController = ViewController()
					thirdViewController.settings.supportedInterfaceOrientations = .all
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []
					
					navigationController.pushViewController(firstViewController, animated: false)
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.supportedInterfaceOrientations) == .allButUpsideDown
					
					navigationController.pushViewController(secondViewController, animated: false)
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					expect(navigationController.supportedInterfaceOrientations) == .landscape
					
					navigationController.pushViewController(thirdViewController, animated: false)
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController, secondViewController, thirdViewController]
					expect(navigationController.supportedInterfaceOrientations) == .all
					
					navigationController.popViewController(animated: false)
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					expect(navigationController.supportedInterfaceOrientations) == .landscape
					
					navigationController.popViewController(animated: false)
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.supportedInterfaceOrientations) == .allButUpsideDown
				}
			}
			
			describe("`viewControllers.setter`") {
				it("should execute immediately if there is no pending transition") {
					let viewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []
					
					navigationController.viewControllers = [viewController]
					expect(navigationController.viewControllers) == [viewController]
					expect(navigationController.childViewControllers) == [viewController]
				}
				
				it("should execute after a moment if there is a pending transition") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []
					
					navigationController.pushViewController(firstViewController, animated: false)
					expect(navigationController.viewControllers) == [firstViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == [firstViewController]
					
					navigationController.pushViewController(secondViewController, animated: false)
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					expect(navigationController.childViewControllers) == [firstViewController]
					
					navigationController.viewControllers = []
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == [firstViewController]
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.childViewControllers) == []
							done()
						}
					}
				}
			}
			
			describe("`pushViewController(_:animated:)`") {
				it("should execute after a moment") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []
					
					navigationController.pushViewController(firstViewController, animated: false)
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.childViewControllers) == []
					
					navigationController.pushViewController(secondViewController, animated: false)
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					expect(navigationController.childViewControllers) == []
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.childViewControllers) == [firstViewController, secondViewController]
							done()
						}
					}
				}
			}
			
			describe("`popViewController(animated:)`") {
				it("should do nothing and return `nil` if there is no more than one child view controller") {
					let viewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []
					
					expect(navigationController.popViewController(animated: false)).to(beNil())
					expect(navigationController.viewControllers) == []
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == []
					
					navigationController.viewControllers = [viewController]
					expect(navigationController.viewControllers) == [viewController]
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == [viewController]
					
					expect(navigationController.popViewController(animated: false)).to(beNil())
					expect(navigationController.viewControllers) == [viewController]
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == [viewController]
				}
				
				it("should return the top view controller and execute after a moment if there are at least two child view controllers") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []
					
					navigationController.viewControllers = [firstViewController, secondViewController]
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == [firstViewController, secondViewController]
					
					expect(navigationController.popViewController(animated: false)) == secondViewController
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.childViewControllers) == [firstViewController, secondViewController]
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.childViewControllers) == [firstViewController]
							done()
						}
					}
				}
			}
			
			describe("`popToViewController(_:animated:)`") {
				it("should do nothing and return `nil` if the given view controller is not found") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []
					
					expect(navigationController.popToViewController(firstViewController, animated: false)).to(beNil())
					expect(navigationController.viewControllers) == []
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == []
					
					navigationController.viewControllers = [firstViewController]
					expect(navigationController.viewControllers) == [firstViewController]
					
					expect(navigationController.popToViewController(secondViewController, animated: false)).to(beNil())
					expect(navigationController.viewControllers) == [firstViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == [firstViewController]
				}
				
				it("should do nothing return an empty array if the given view controller is at the top") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []

					navigationController.viewControllers = [firstViewController]
					expect(navigationController.viewControllers) == [firstViewController]
					
					expect(navigationController.popToViewController(firstViewController, animated: false)) == []
					expect(navigationController.viewControllers) == [firstViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == [firstViewController]
					
					navigationController.viewControllers = [firstViewController, secondViewController]
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					
					expect(navigationController.popToViewController(secondViewController, animated: false)) == []
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
				}
				
				it("should return an array of popped view controllers and execute after a moment if the given view controller is in the middle or at the bottom") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					let thirdViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []
					
					navigationController.viewControllers = [firstViewController, secondViewController, thirdViewController]
					expect(navigationController.viewControllers) == [firstViewController, secondViewController, thirdViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController, secondViewController, thirdViewController]
					
					expect(navigationController.popToViewController(firstViewController, animated: false)) == [secondViewController, thirdViewController]
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.childViewControllers) == [firstViewController, secondViewController, thirdViewController]
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.childViewControllers) == [firstViewController]
							done()
						}
					}
				}
			}
			
			describe("`popToRootViewController(animated:)`") {
				it("should do nothing and return `nil` if there is no child view controller") {
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []
					
					expect(navigationController.popToRootViewController(animated: false)).to(beNil())
					expect(navigationController.viewControllers) == []
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == []
				}
				
				it("should do nothing and return an empty array if there is only one child view controller") {
					let viewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []
					
					navigationController.viewControllers = [viewController]
					expect(navigationController.viewControllers) == [viewController]
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == [viewController]
					
					expect(navigationController.popToRootViewController(animated: false)) == []
					expect(navigationController.viewControllers) == [viewController]
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == [viewController]
				}
				
				it("should return an array of popped view controllers and execute after a moment if there is at least two child view controllers") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					let thirdViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []
					
					navigationController.viewControllers = [firstViewController, secondViewController, thirdViewController]
					expect(navigationController.viewControllers) == [firstViewController, secondViewController, thirdViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.childViewControllers) == [firstViewController, secondViewController, thirdViewController]
					
					expect(navigationController.popToRootViewController(animated: false)) == [secondViewController, thirdViewController]
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.childViewControllers) == [firstViewController, secondViewController, thirdViewController]
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.childViewControllers) == [firstViewController]
							done()
						}
					}
				}
			}
			
			describe("`setViewControllers(_:animated:)") {
				it("should executed after a moment") {
					let viewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.childViewControllers) == []

					navigationController.setViewControllers([viewController], animated: false)
					expect(navigationController.viewControllers) == [viewController]
					expect(navigationController.childViewControllers) == []
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.childViewControllers) == [viewController]
							done()
						}
					}
				}
			}
		}
	}
}
