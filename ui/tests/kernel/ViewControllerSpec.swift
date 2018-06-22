//
//  ViewControllerSpec.swift
//  ui
//
//  Created by 傅立业 on 2018/6/22.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

import Nimble
import Quick

import ui

internal class ViewControllerSpec : QuickSpec {
	override
	internal func spec() {
		describe("`ViewController`") {
			var viewController: ViewController!
			
			beforeEach {
				viewController = ViewController()
			}
			
			describe("`settings.openingStyle`") {
				it("is `.push` by default") {
					expect(viewController.settings.openingStyle) == .push
				}
				
				it("should affect `_Presents`") {
					let getValue = {
						return viewController.value(forKey: "_Presents") as! Bool
					}
					
					expect(getValue()) == (viewController.settings.openingStyle == .present)
					
					viewController.settings.openingStyle = .present
					expect(getValue()).to(beTrue())
					
					viewController.settings.openingStyle = .push
					expect(getValue()).to(beFalse())
					
					viewController.settings.openingStyle = .present
					expect(getValue()).to(beTrue())
					
					viewController.settings.openingStyle = .push
					expect(getValue()).to(beFalse())
				}
				
				it("should be affected by `_Presents`") {
					let setValue = {
						viewController.setValue($0, forKey: "_Presents")
					}
					
					setValue(true)
					expect(viewController.settings.openingStyle) == .present
					
					setValue(false)
					expect(viewController.settings.openingStyle) == .push
					
					setValue(true)
					expect(viewController.settings.openingStyle) == .present
					
					setValue(false)
					expect(viewController.settings.openingStyle) == .push
				}
			}
			
			describe("`settings.prefersStatusBarHidden`") {
				it("is `false` by default") {
					expect(viewController.settings.prefersStatusBarHidden).to(beFalse())
				}
				
				it("should affect `prefersStatusBarHidden`") {
					expect(viewController.prefersStatusBarHidden) == viewController.settings.prefersStatusBarHidden
					
					viewController.settings.prefersStatusBarHidden = true
					expect(viewController.prefersStatusBarHidden).to(beTrue())
					
					viewController.settings.prefersStatusBarHidden = false
					expect(viewController.prefersStatusBarHidden).to(beFalse())
					
					viewController.settings.prefersStatusBarHidden = true
					expect(viewController.prefersStatusBarHidden).to(beTrue())
					
					viewController.settings.prefersStatusBarHidden = false
					expect(viewController.prefersStatusBarHidden).to(beFalse())
				}
				
				it("should affect `_StatusBar`") {
					let getValue = {
						return viewController.value(forKey: "_StatusBar") as! Bool
					}
					
					expect(getValue()) == !viewController.settings.prefersStatusBarHidden
					
					viewController.settings.prefersStatusBarHidden = true
					expect(getValue()).to(beFalse())
					
					viewController.settings.prefersStatusBarHidden = false
					expect(getValue()).to(beTrue())
					
					viewController.settings.prefersStatusBarHidden = true
					expect(getValue()).to(beFalse())
					
					viewController.settings.prefersStatusBarHidden = false
					expect(getValue()).to(beTrue())
				}
				
				it("should be affected by `_StatusBar`") {
					let setValue = {
						viewController.setValue($0, forKey: "_StatusBar")
					}
					
					setValue(true)
					expect(viewController.settings.prefersStatusBarHidden).to(beFalse())
					
					setValue(false)
					expect(viewController.settings.prefersStatusBarHidden).to(beTrue())
					
					setValue(true)
					expect(viewController.settings.prefersStatusBarHidden).to(beFalse())
					
					setValue(false)
					expect(viewController.settings.prefersStatusBarHidden).to(beTrue())
				}
			}
			
			describe("`settings.preferredStatusBarStyle`") {
				it("is `.default` by default") {
					expect(viewController.settings.preferredStatusBarStyle) == .default
				}
				
				it("should affect `preferredStatusBarStyle") {
					expect(viewController.preferredStatusBarStyle) == viewController.settings.preferredStatusBarStyle
					
					viewController.settings.preferredStatusBarStyle = .lightContent
					expect(viewController.preferredStatusBarStyle) == .lightContent
					
					viewController.settings.preferredStatusBarStyle = .default
					expect(viewController.preferredStatusBarStyle) == .default
					
					viewController.settings.preferredStatusBarStyle = .lightContent
					expect(viewController.preferredStatusBarStyle) == .lightContent
					
					viewController.settings.preferredStatusBarStyle = .default
					expect(viewController.preferredStatusBarStyle) == .default
				}
				
				it("should affect `_WhiteStatus`") {
					let getValue = {
						return viewController.value(forKey: "_WhiteStatus") as! Bool
					}
					
					expect(getValue()) == (viewController.settings.preferredStatusBarStyle == .lightContent)
					
					viewController.settings.preferredStatusBarStyle = .lightContent
					expect(getValue()).to(beTrue())
					
					viewController.settings.preferredStatusBarStyle = .default
					expect(getValue()).to(beFalse())
					
					viewController.settings.preferredStatusBarStyle = .lightContent
					expect(getValue()).to(beTrue())
					
					viewController.settings.preferredStatusBarStyle = .default
					expect(getValue()).to(beFalse())
				}
				
				it("should be affect by `_WhiteStatus`") {
					let setValue = {
						viewController.setValue($0, forKey: "_WhiteStatus")
					}
					
					setValue(true)
					expect(viewController.settings.preferredStatusBarStyle) == .lightContent
					
					setValue(false)
					expect(viewController.settings.preferredStatusBarStyle) == .default
					
					setValue(true)
					expect(viewController.settings.preferredStatusBarStyle) == .lightContent
					
					setValue(false)
					expect(viewController.settings.preferredStatusBarStyle) == .default
				}
			}
			
			describe("`settings.prefersNavigationBarHidden`") {
				it("is `false` by default") {
					expect(viewController.settings.prefersNavigationBarHidden).to(beFalse())
				}
				
				it("should affect navigation bar's visibility in embedding navigation controller") {
					let navigationController = UINavigationController()
					navigationController.viewControllers = [viewController]
					
					viewController.viewWillAppear(false)
					expect(navigationController.navigationBar.isHidden) == viewController.settings.prefersNavigationBarHidden
					
					viewController.settings.prefersNavigationBarHidden = true
					viewController.viewWillAppear(false)
					viewController.viewDidAppear(false)
					expect(navigationController.navigationBar.isHidden).to(beTrue())
					
					viewController.settings.prefersNavigationBarHidden = false
					viewController.viewWillAppear(false)
					viewController.viewDidAppear(false)
					expect(navigationController.navigationBar.isHidden).to(beFalse())
					
					viewController.settings.prefersNavigationBarHidden = true
					viewController.viewWillAppear(true)
					viewController.viewDidAppear(true)
					expect(navigationController.navigationBar.isHidden).toEventually(beTrue())
					
					viewController.settings.prefersNavigationBarHidden = false
					viewController.viewWillAppear(true)
					viewController.viewDidAppear(true)
					expect(navigationController.navigationBar.isHidden).toEventually(beFalse())
				}
				
				it("should affect `_NavigationBar`") {
					let getValue = {
						return viewController.value(forKey: "_NavigationBar") as! Bool
					}
					
					expect(getValue()) == !viewController.settings.prefersNavigationBarHidden
					
					viewController.settings.prefersNavigationBarHidden = true
					expect(getValue()).to(beFalse())
					
					viewController.settings.prefersNavigationBarHidden = false
					expect(getValue()).to(beTrue())
					
					viewController.settings.prefersNavigationBarHidden = true
					expect(getValue()).to(beFalse())
					
					viewController.settings.prefersNavigationBarHidden = false
					expect(getValue()).to(beTrue())
				}
				
				it("should be affected by `_NavigationBar`") {
					let setValue = {
						viewController.setValue($0, forKey: "_NavigationBar")
					}
					
					setValue(true)
					expect(viewController.settings.prefersNavigationBarHidden).to(beFalse())
					
					setValue(false)
					expect(viewController.settings.prefersNavigationBarHidden).to(beTrue())
					
					setValue(true)
					expect(viewController.settings.prefersNavigationBarHidden).to(beFalse())
					
					setValue(false)
					expect(viewController.settings.prefersNavigationBarHidden).to(beTrue())
				}
			}
			
			describe("`settings.supportedInterfaceOrientations`") {
				it("is `.all` by default") {
					expect(viewController.settings.supportedInterfaceOrientations) == .all
				}
				
				it("should affect `supportedInterfaceOrientation`") {
					expect(viewController.supportedInterfaceOrientations) == viewController.settings.supportedInterfaceOrientations
					
					viewController.settings.supportedInterfaceOrientations = .portrait
					expect(viewController.supportedInterfaceOrientations) == .portrait
					
					viewController.settings.supportedInterfaceOrientations = .allButUpsideDown
					expect(viewController.supportedInterfaceOrientations) == .allButUpsideDown
					
					viewController.settings.supportedInterfaceOrientations = .landscape
					expect(viewController.supportedInterfaceOrientations) == .landscape
					
					viewController.settings.supportedInterfaceOrientations = .all
					expect(viewController.supportedInterfaceOrientations) == .all
				}
				
				it("should affect `_Portrait`, `_Left`, `_Right`, `_UpsideDown`") {
					let getPortraitValue = {
						return viewController.value(forKey: "_Portrait") as! Bool
					}
					
					let getLeftValue = {
						return viewController.value(forKey: "_Left") as! Bool
					}
					
					let getRightValue = {
						return viewController.value(forKey: "_Right") as! Bool
					}
					
					let getUpsideDownValue = {
						return viewController.value(forKey: "_UpsideDown") as! Bool
					}
					
					expect(getPortraitValue()) == viewController.settings.supportedInterfaceOrientations.contains(.portrait)
					expect(getLeftValue()) == viewController.settings.supportedInterfaceOrientations.contains(.landscapeLeft)
					expect(getRightValue()) == viewController.settings.supportedInterfaceOrientations.contains(.landscapeRight)
					expect(getUpsideDownValue()) == viewController.settings.supportedInterfaceOrientations.contains(.portraitUpsideDown)
					
					viewController.settings.supportedInterfaceOrientations = .portrait
					expect(getPortraitValue()).to(beTrue())
					expect(getLeftValue()).to(beFalse())
					expect(getRightValue()).to(beFalse())
					expect(getUpsideDownValue()).to(beFalse())
					
					viewController.settings.supportedInterfaceOrientations = .allButUpsideDown
					expect(getPortraitValue()).to(beTrue())
					expect(getLeftValue()).to(beTrue())
					expect(getRightValue()).to(beTrue())
					expect(getUpsideDownValue()).to(beFalse())
					
					viewController.settings.supportedInterfaceOrientations = .landscape
					expect(getPortraitValue()).to(beFalse())
					expect(getLeftValue()).to(beTrue())
					expect(getRightValue()).to(beTrue())
					expect(getUpsideDownValue()).to(beFalse())
					
					viewController.settings.supportedInterfaceOrientations = .all
					expect(getPortraitValue()).to(beTrue())
					expect(getLeftValue()).to(beTrue())
					expect(getRightValue()).to(beTrue())
					expect(getUpsideDownValue()).to(beTrue())
				}
				
				it("should be affected by `_Portrait`, `_Left`, `_Right`, `_UpsideDown`") {
					let setPortraitValue = {
						viewController.setValue($0, forKey: "_Portrait")
					}
					
					let setLeftValue = {
						viewController.setValue($0, forKey: "_Left")
					}
					
					let setRightValue = {
						viewController.setValue($0, forKey: "_Right")
					}
					
					let setUpsideDownValue = {
						viewController.setValue($0, forKey: "_UpsideDown")
					}
					
					setPortraitValue(true)
					setLeftValue(false)
					setRightValue(false)
					setUpsideDownValue(false)
					expect(viewController.settings.supportedInterfaceOrientations) == .portrait
					
					setPortraitValue(true)
					setLeftValue(true)
					setRightValue(true)
					setUpsideDownValue(false)
					expect(viewController.settings.supportedInterfaceOrientations) == .allButUpsideDown
					
					setPortraitValue(false)
					setLeftValue(true)
					setRightValue(true)
					setUpsideDownValue(false)
					expect(viewController.settings.supportedInterfaceOrientations) == .landscape
					
					setPortraitValue(true)
					setLeftValue(true)
					setRightValue(true)
					setUpsideDownValue(true)
					expect(viewController.settings.supportedInterfaceOrientations) == .all
				}
			}
		}
	}
}
