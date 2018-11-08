//	MIT License
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
					expect(navigationController.childForStatusBarStyle).to(beNil())
					
					navigationController.pushViewController(firstViewController, animated: false)
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.childForStatusBarStyle) == firstViewController
					
					navigationController.pushViewController(secondViewController, animated: false)
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					expect(navigationController.childForStatusBarStyle) == secondViewController
					
					navigationController.popViewController(animated: false)
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.childForStatusBarStyle) == firstViewController
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
					expect(navigationController.children) == []
					
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
					expect(navigationController.children) == []
					
					navigationController.viewControllers = [viewController]
					expect(navigationController.viewControllers) == [viewController]
					expect(navigationController.children) == [viewController]
				}
				
				it("should execute after a moment if there is a pending transition") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.children) == []
					
					navigationController.pushViewController(firstViewController, animated: false)
					expect(navigationController.viewControllers) == [firstViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.children) == [firstViewController]
					
					navigationController.pushViewController(secondViewController, animated: false)
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					expect(navigationController.children) == [firstViewController]
					
					navigationController.viewControllers = []
					expect(navigationController.viewControllers) == []
					expect(navigationController.children) == [firstViewController]
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.children) == []
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
					expect(navigationController.children) == []
					
					navigationController.pushViewController(firstViewController, animated: false)
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.children) == []
					
					navigationController.pushViewController(secondViewController, animated: false)
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					expect(navigationController.children) == []
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.children) == [firstViewController, secondViewController]
							done()
						}
					}
				}
			}
			
			describe("`popViewController(animated:)`") {
				it("should do nothing and return `nil` if there is no more than one child view controller") {
					let viewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.children) == []
					
					expect(navigationController.popViewController(animated: false)).to(beNil())
					expect(navigationController.viewControllers) == []
					navigationController.applyPendingTransition()
					expect(navigationController.children) == []
					
					navigationController.viewControllers = [viewController]
					expect(navigationController.viewControllers) == [viewController]
					navigationController.applyPendingTransition()
					expect(navigationController.children) == [viewController]
					
					expect(navigationController.popViewController(animated: false)).to(beNil())
					expect(navigationController.viewControllers) == [viewController]
					navigationController.applyPendingTransition()
					expect(navigationController.children) == [viewController]
				}
				
				it("should return the top view controller and execute after a moment if there are at least two child view controllers") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.children) == []
					
					navigationController.viewControllers = [firstViewController, secondViewController]
					expect(navigationController.viewControllers) == [firstViewController, secondViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.children) == [firstViewController, secondViewController]
					
					expect(navigationController.popViewController(animated: false)) == secondViewController
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.children) == [firstViewController, secondViewController]
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.children) == [firstViewController]
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
					expect(navigationController.children) == []
					
					expect(navigationController.popToViewController(firstViewController, animated: false)).to(beNil())
					expect(navigationController.viewControllers) == []
					navigationController.applyPendingTransition()
					expect(navigationController.children) == []
					
					navigationController.viewControllers = [firstViewController]
					expect(navigationController.viewControllers) == [firstViewController]
					
					expect(navigationController.popToViewController(secondViewController, animated: false)).to(beNil())
					expect(navigationController.viewControllers) == [firstViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.children) == [firstViewController]
				}
				
				it("should do nothing return an empty array if the given view controller is at the top") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.children) == []

					navigationController.viewControllers = [firstViewController]
					expect(navigationController.viewControllers) == [firstViewController]
					
					expect(navigationController.popToViewController(firstViewController, animated: false)) == []
					expect(navigationController.viewControllers) == [firstViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.children) == [firstViewController]
					
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
					expect(navigationController.children) == []
					
					navigationController.viewControllers = [firstViewController, secondViewController, thirdViewController]
					expect(navigationController.viewControllers) == [firstViewController, secondViewController, thirdViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.viewControllers) == [firstViewController, secondViewController, thirdViewController]
					
					expect(navigationController.popToViewController(firstViewController, animated: false)) == [secondViewController, thirdViewController]
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.children) == [firstViewController, secondViewController, thirdViewController]
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.children) == [firstViewController]
							done()
						}
					}
				}
			}
			
			describe("`popToRootViewController(animated:)`") {
				it("should do nothing and return `nil` if there is no child view controller") {
					expect(navigationController.viewControllers) == []
					expect(navigationController.children) == []
					
					expect(navigationController.popToRootViewController(animated: false)).to(beNil())
					expect(navigationController.viewControllers) == []
					navigationController.applyPendingTransition()
					expect(navigationController.children) == []
				}
				
				it("should do nothing and return an empty array if there is only one child view controller") {
					let viewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.children) == []
					
					navigationController.viewControllers = [viewController]
					expect(navigationController.viewControllers) == [viewController]
					navigationController.applyPendingTransition()
					expect(navigationController.children) == [viewController]
					
					expect(navigationController.popToRootViewController(animated: false)) == []
					expect(navigationController.viewControllers) == [viewController]
					navigationController.applyPendingTransition()
					expect(navigationController.children) == [viewController]
				}
				
				it("should return an array of popped view controllers and execute after a moment if there is at least two child view controllers") {
					let firstViewController = UIViewController()
					let secondViewController = UIViewController()
					let thirdViewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.children) == []
					
					navigationController.viewControllers = [firstViewController, secondViewController, thirdViewController]
					expect(navigationController.viewControllers) == [firstViewController, secondViewController, thirdViewController]
					navigationController.applyPendingTransition()
					expect(navigationController.children) == [firstViewController, secondViewController, thirdViewController]
					
					expect(navigationController.popToRootViewController(animated: false)) == [secondViewController, thirdViewController]
					expect(navigationController.viewControllers) == [firstViewController]
					expect(navigationController.children) == [firstViewController, secondViewController, thirdViewController]
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.children) == [firstViewController]
							done()
						}
					}
				}
			}
			
			describe("`setViewControllers(_:animated:)") {
				it("should executed after a moment") {
					let viewController = UIViewController()
					
					expect(navigationController.viewControllers) == []
					expect(navigationController.children) == []

					navigationController.setViewControllers([viewController], animated: false)
					expect(navigationController.viewControllers) == [viewController]
					expect(navigationController.children) == []
					
					waitUntil { done in
						RunLoop.current.perform {
							expect(navigationController.children) == [viewController]
							done()
						}
					}
				}
			}
		}
	}
}
