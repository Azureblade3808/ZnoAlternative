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
				
				it("should link with `_Presents`") {
					let getPresents: () -> Bool = {
						return viewController.value(forKey: "_Presents") as! Bool
					}
					
					let setPresents: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_Presents")
					}
					
					expect(getPresents() == (viewController.settings.openingStyle == .present)).to(beTrue())
					
					viewController.settings.openingStyle = .present
					expect(getPresents()).to(beTrue())
					
					viewController.settings.openingStyle = .push
					expect(getPresents()).to(beFalse())
					
					setPresents(true)
					expect(viewController.settings.openingStyle) == .present
					
					setPresents(false)
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
				}
				
				it("should link with `_StatusBar`") {
					let getStatusBar: () -> Bool = {
						return viewController.value(forKey: "_StatusBar") as! Bool
					}
					
					let setStatusBar: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_StatusBar")
					}
					
					expect(getStatusBar() == !viewController.settings.prefersStatusBarHidden).to(beTrue())
					
					viewController.settings.prefersStatusBarHidden = true
					expect(getStatusBar()).to(beFalse())
					
					viewController.settings.prefersStatusBarHidden = false
					expect(getStatusBar()).to(beTrue())
					
					setStatusBar(true)
					expect(viewController.settings.prefersStatusBarHidden).to(beFalse())
					
					setStatusBar(false)
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
				}
				
				it("should link with `_WhiteStatus`") {
					let getWhiteStatus: () -> Bool = {
						return viewController.value(forKey: "_WhiteStatus") as! Bool
					}
					
					let setWhiteStatus: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_WhiteStatus")
					}
					
					expect(getWhiteStatus() == (viewController.settings.preferredStatusBarStyle == .lightContent)).to(beTrue())
					
					viewController.settings.preferredStatusBarStyle = .lightContent
					expect(getWhiteStatus()).to(beTrue())
					
					viewController.settings.preferredStatusBarStyle = .default
					expect(getWhiteStatus()).to(beFalse())
					
					setWhiteStatus(true)
					expect(viewController.settings.preferredStatusBarStyle) == .lightContent
					
					setWhiteStatus(false)
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
					let getNavigationBar: () -> Bool = {
						return viewController.value(forKey: "_NavigationBar") as! Bool
					}
					
					let setNavigationBar: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_NavigationBar")
					}
					
					expect(getNavigationBar() == !viewController.settings.prefersNavigationBarHidden).to(beTrue())
					
					viewController.settings.prefersNavigationBarHidden = true
					expect(getNavigationBar()).to(beFalse())
					
					viewController.settings.prefersNavigationBarHidden = false
					expect(getNavigationBar()).to(beTrue())
					
					setNavigationBar(true)
					expect(viewController.settings.prefersNavigationBarHidden).to(beFalse())
					
					setNavigationBar(false)
					expect(viewController.settings.prefersNavigationBarHidden).to(beTrue())
				}
			}
			
			describe("`settings.supportedInterfaceOrientations`") {
				it("is `.all` by default") {
					expect(viewController.settings.supportedInterfaceOrientations) == .all
				}
				
				it("should affect `supportedInterfaceOrientation`") {
					expect(viewController.supportedInterfaceOrientations == viewController.settings.supportedInterfaceOrientations).to(beTrue())
					
					viewController.settings.supportedInterfaceOrientations = .portrait
					expect(viewController.supportedInterfaceOrientations) == .portrait
					
					viewController.settings.supportedInterfaceOrientations = .allButUpsideDown
					expect(viewController.supportedInterfaceOrientations) == .allButUpsideDown
					
					viewController.settings.supportedInterfaceOrientations = .landscape
					expect(viewController.supportedInterfaceOrientations) == .landscape
					
					viewController.settings.supportedInterfaceOrientations = .all
					expect(viewController.supportedInterfaceOrientations) == .all
				}
				
				it("should link with `_Portrait`, `_Left`, `_Right`, `_UpsideDown`") {
					let getPortrait: () -> Bool = {
						return viewController.value(forKey: "_Portrait") as! Bool
					}
					
					let setPortrait: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_Portrait")
					}
					
					let getLeft: () -> Bool = {
						return viewController.value(forKey: "_Left") as! Bool
					}
					
					let setLeft: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_Left")
					}
					
					let getRight: () -> Bool = {
						return viewController.value(forKey: "_Right") as! Bool
					}
					
					let setRight: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_Right")
					}
					
					let getUpsideDown: () -> Bool = {
						return viewController.value(forKey: "_UpsideDown") as! Bool
					}
					
					let setUpsideDown: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_UpsideDown")
					}
					
					expect(getPortrait() == viewController.settings.supportedInterfaceOrientations.contains(.portrait)).to(beTrue())
					expect(getLeft() == viewController.settings.supportedInterfaceOrientations.contains(.landscapeLeft)).to(beTrue())
					expect(getRight() == viewController.settings.supportedInterfaceOrientations.contains(.landscapeRight)).to(beTrue())
					expect(getUpsideDown() == viewController.settings.supportedInterfaceOrientations.contains(.portraitUpsideDown)).to(beTrue())
					
					viewController.settings.supportedInterfaceOrientations = .portrait
					expect(getPortrait()).to(beTrue())
					expect(getLeft()).to(beFalse())
					expect(getRight()).to(beFalse())
					expect(getUpsideDown()).to(beFalse())
					
					viewController.settings.supportedInterfaceOrientations = .allButUpsideDown
					expect(getPortrait()).to(beTrue())
					expect(getLeft()).to(beTrue())
					expect(getRight()).to(beTrue())
					expect(getUpsideDown()).to(beFalse())
					
					viewController.settings.supportedInterfaceOrientations = .landscape
					expect(getPortrait()).to(beFalse())
					expect(getLeft()).to(beTrue())
					expect(getRight()).to(beTrue())
					expect(getUpsideDown()).to(beFalse())
					
					viewController.settings.supportedInterfaceOrientations = .all
					expect(getPortrait()).to(beTrue())
					expect(getLeft()).to(beTrue())
					expect(getRight()).to(beTrue())
					expect(getUpsideDown()).to(beTrue())
					
					setPortrait(true)
					setLeft(false)
					setRight(false)
					setUpsideDown(false)
					expect(viewController.settings.supportedInterfaceOrientations) == .portrait
					
					setPortrait(true)
					setLeft(true)
					setRight(true)
					setUpsideDown(false)
					expect(viewController.settings.supportedInterfaceOrientations) == .allButUpsideDown
					
					setPortrait(false)
					setLeft(true)
					setRight(true)
					setUpsideDown(false)
					expect(viewController.settings.supportedInterfaceOrientations) == .landscape
					
					setPortrait(true)
					setLeft(true)
					setRight(true)
					setUpsideDown(true)
					expect(viewController.settings.supportedInterfaceOrientations) == .all
				}
			}
		}
	}
}
