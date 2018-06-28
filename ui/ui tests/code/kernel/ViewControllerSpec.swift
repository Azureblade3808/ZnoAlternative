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
			
			describe("`_Title`") {
				it("should link with `title`") {
					let getTitle: () -> String? = {
						return viewController.value(forKey: "_Title") as! String?
					}
					
					let setTitle: (String?) -> Void = {
						viewController.setValue($0, forKey: "_Title")
					}
					
					expect(getTitle() == viewController.title).to(beTrue())
					
					viewController.title = "A"
					expect(getTitle()) == "A"
					
					viewController.title = "B"
					expect(getTitle()) == "B"
					
					viewController.title = nil
					expect(getTitle()).to(beNil())
					
					setTitle("A")
					expect(viewController.title) == "A"
					
					setTitle("B")
					expect(viewController.title) == "B"
					
					setTitle(nil)
					expect(viewController.title).to(beNil())
				}
			}
			
			describe("_Presents") {
				it("should link with `settings.openingStyle`") {
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
			
			describe("`_StatusBar`") {
				it("should link with `settings.prefersStatusBarHidden`") {
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
			
			describe("`_WhiteStatus`") {
				it("should link with `settings.preferredStatusBarStyle`") {
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
			
			describe("`_NaviagationBar`") {
				it("should link with `settings.prefersNavigationBarHidden`") {
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
			
			describe("`_Portrait`") {
				it("should link with `settings.supportedInterfaceOrientations`") {
					let getPortrait: () -> Bool = {
						return viewController.value(forKey: "_Portrait") as! Bool
					}
					
					let setPortrait: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_Portrait")
					}
					
					expect(getPortrait() == viewController.settings.supportedInterfaceOrientations.contains(.portrait)).to(beTrue())
					
					viewController.settings.supportedInterfaceOrientations.insert(.portrait)
					expect(getPortrait()).to(beTrue())
					
					viewController.settings.supportedInterfaceOrientations.remove(.portrait)
					expect(getPortrait()).to(beFalse())
					
					setPortrait(true)
					expect(getPortrait()).to(beTrue())
					
					setPortrait(false)
					expect(getPortrait()).to(beFalse())
				}
			}
			
			describe("`_Left`") {
				it("should link with `settings.supportedInterfaceOrientations`") {
					let getLeft: () -> Bool = {
						return viewController.value(forKey: "_Left") as! Bool
					}
					
					let setLeft: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_Left")
					}
					
					expect(getLeft() == viewController.settings.supportedInterfaceOrientations.contains(.landscapeLeft)).to(beTrue())
					
					viewController.settings.supportedInterfaceOrientations.insert(.landscapeLeft)
					expect(getLeft()).to(beTrue())
					
					viewController.settings.supportedInterfaceOrientations.remove(.landscapeLeft)
					expect(getLeft()).to(beFalse())
					
					setLeft(true)
					expect(getLeft()).to(beTrue())
					
					setLeft(false)
					expect(getLeft()).to(beFalse())
				}
			}
			
			describe("`_Right`") {
				it("should link with `settings.supportedInterfaceOrientations`") {
					let getRight: () -> Bool = {
						return viewController.value(forKey: "_Right") as! Bool
					}
					
					let setRight: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_Right")
					}
					
					expect(getRight() == viewController.settings.supportedInterfaceOrientations.contains(.landscapeRight)).to(beTrue())
					
					viewController.settings.supportedInterfaceOrientations.insert(.landscapeRight)
					expect(getRight()).to(beTrue())
					
					viewController.settings.supportedInterfaceOrientations.remove(.landscapeRight)
					expect(getRight()).to(beFalse())
					
					setRight(true)
					expect(getRight()).to(beTrue())
					
					setRight(false)
					expect(getRight()).to(beFalse())
				}
			}
			
			describe("`_UpsideDown`") {
				it("should link with `settings.supportedInterfaceOrientations`") {
					let getUpsideDown: () -> Bool = {
						return viewController.value(forKey: "_UpsideDown") as! Bool
					}
					
					let setUpsideDown: (Bool) -> Void = {
						viewController.setValue($0, forKey: "_UpsideDown")
					}
					
					expect(getUpsideDown() == viewController.settings.supportedInterfaceOrientations.contains(.portraitUpsideDown)).to(beTrue())
					
					viewController.settings.supportedInterfaceOrientations.insert(.portraitUpsideDown)
					expect(getUpsideDown()).to(beTrue())
					
					viewController.settings.supportedInterfaceOrientations.remove(.portraitUpsideDown)
					expect(getUpsideDown()).to(beFalse())
					
					setUpsideDown(true)
					expect(getUpsideDown()).to(beTrue())
					
					setUpsideDown(false)
					expect(getUpsideDown()).to(beFalse())
				}
			}

			describe("`settings.openingStyle`") {
				it("is `.push` by default") {
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
			}
		}
	}
}
