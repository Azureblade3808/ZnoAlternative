//
//  UIViewExtensionSpec.swift
//  ui
//
//  Created by 傅立业 on 2018/6/23.
//  Copyright © 2018年 Zno Inc. All rights reserved.
//

import Nimble
import Quick

import ui

internal class UIViewExtensionSpec : QuickSpec {
	override
	internal func spec() {
		var view: UIView!
		
		beforeEach {
			view = UIView()
		}
		
		describe("`UIView`") {
			describe("`_BorderColor`") {
				it("should link with `layer.borderColor`") {
					let getBorderColor: () -> UIColor? = {
						return view.value(forKey: "_BorderColor") as! UIColor?
					}
					
					let setBorderColor: (UIColor?) -> Void = {
						view.setValue($0, forKey: "_BorderColor")
					}
					
					expect(getBorderColor()?.cgColor == view.layer.borderColor).to(beTrue())
					
					setBorderColor(UIColor.white)
					expect(view.layer.borderColor) == UIColor.white.cgColor
					
					setBorderColor(UIColor.clear)
					expect(view.layer.borderColor) == UIColor.clear.cgColor
					
					setBorderColor(nil)
					expect(view.layer.borderColor).to(beNil())
					
					view.layer.borderColor = UIColor.white.cgColor
					expect(getBorderColor()) == UIColor.white
					
					view.layer.borderColor = UIColor.clear.cgColor
					expect(getBorderColor()) == UIColor.clear
					
					view.layer.borderColor = nil
					expect(getBorderColor()).to(beNil())
				}
			}
			
			describe("_BorderWidth") {
				it("should link with `layer.borderWidth") {
					let getBorderWidth: () -> CGFloat = {
						return view.value(forKey: "_BorderWidth") as! CGFloat
					}
					
					let setBorderWidth: (CGFloat) -> Void = {
						view.setValue($0, forKey: "_BorderWidth")
					}
					
					expect(getBorderWidth() == view.layer.borderWidth).to(beTrue())
					
					setBorderWidth(1)
					expect(view.layer.borderWidth) == 1
					
					setBorderWidth(0)
					expect(view.layer.borderWidth) == 0
					
					view.layer.borderWidth = 1
					expect(getBorderWidth()) == 1
					
					view.layer.borderWidth = 0
					expect(getBorderWidth()) == 0
				}
			}
			
			describe("_CornerRadius") {
				it("should link with `layer.cornerRadius") {
					let getCornerRadius: () -> CGFloat = {
						return view.value(forKey: "_CornerRadius") as! CGFloat
					}
					
					let setCornerRadius: (CGFloat) -> Void = {
						view.setValue($0, forKey: "_CornerRadius")
					}
					
					expect(getCornerRadius() == view.layer.cornerRadius).to(beTrue())
					
					setCornerRadius(1)
					expect(view.layer.cornerRadius) == 1
					
					setCornerRadius(0)
					expect(view.layer.cornerRadius) == 0
					
					view.layer.cornerRadius = 1
					expect(getCornerRadius()) == 1
					
					view.layer.cornerRadius = 0
					expect(getCornerRadius()) == 0
				}
			}
			
			describe("`_ShadowColor`") {
				it("should link with `layer.shadowColor`") {
					let getShadowColor: () -> UIColor? = {
						return view.value(forKey: "_ShadowColor") as! UIColor?
					}
					
					let setShadowColor: (UIColor?) -> Void = {
						view.setValue($0, forKey: "_ShadowColor")
					}
					
					expect(getShadowColor()?.cgColor == view.layer.shadowColor).to(beTrue())
					
					setShadowColor(UIColor.white)
					expect(view.layer.shadowColor) == UIColor.white.cgColor
					
					setShadowColor(UIColor.clear)
					expect(view.layer.shadowColor) == UIColor.clear.cgColor
					
					setShadowColor(nil)
					expect(view.layer.shadowColor).to(beNil())
					
					view.layer.shadowColor = UIColor.white.cgColor
					expect(getShadowColor()) == UIColor.white
					
					view.layer.shadowColor = UIColor.clear.cgColor
					expect(getShadowColor()) == UIColor.clear
					
					view.layer.shadowColor = nil
					expect(getShadowColor()).to(beNil())
				}
			}
			
			describe("`_ShadowOffset`") {
				it("should link with `layer.shadowOffset`") {
					let getShadowOffset: () -> CGSize = {
						return view.value(forKey: "_ShadowOffset") as! CGSize
					}
					
					let setShadowOffset: (CGSize) -> Void = {
						view.setValue($0, forKey: "_ShadowOffset")
					}
					
					expect(getShadowOffset() == view.layer.shadowOffset).to(beTrue())
					
					setShadowOffset(CGSize(width: 1, height: 1))
					expect(view.layer.shadowOffset) == CGSize(width: 1, height: 1)
					
					setShadowOffset(.zero)
					expect(view.layer.shadowOffset) == .zero
					
					view.layer.shadowOffset = CGSize(width: 1, height: 1)
					expect(getShadowOffset()) == CGSize(width: 1, height: 1)
					
					view.layer.shadowOffset = .zero
					expect(getShadowOffset()) == .zero
				}
			}
			
			describe("`_ShadowOpacity`") {
				it("should link with `layer.shadowOpacity`") {
					let getShadowOpacity: () -> Float = {
						return view.value(forKey: "_ShadowOpacity") as! Float
					}
					
					let setShadowOpacity: (Float) -> Void = {
						view.setValue($0, forKey: "_ShadowOpacity")
					}
					
					expect(getShadowOpacity() == view.layer.shadowOpacity).to(beTrue())
					
					setShadowOpacity(1)
					expect(view.layer.shadowOpacity) == 1
					
					setShadowOpacity(0)
					expect(view.layer.shadowOpacity) == 0
					
					view.layer.shadowOpacity = 1
					expect(getShadowOpacity()) == 1
					
					view.layer.shadowOpacity = 0
					expect(getShadowOpacity()) == 0
				}
			}
			
			describe("_ShadowRadius") {
				it("should link with `layer.shadowRadius`") {
					let getShadowRadius: () -> CGFloat = {
						return view.value(forKey: "_ShadowRadius") as! CGFloat
					}
					
					let setShadowRadius: (Float) -> Void = {
						view.setValue($0, forKey: "_ShadowRadius")
					}
					
					expect(getShadowRadius() == view.layer.shadowRadius).to(beTrue())
					
					setShadowRadius(1)
					expect(view.layer.shadowRadius) == 1
					
					setShadowRadius(0)
					expect(view.layer.shadowRadius) == 0
					
					view.layer.shadowRadius = 1
					expect(view.layer.shadowRadius) == 1
					
					view.layer.shadowRadius = 0
					expect(view.layer.shadowRadius) == 0
				}
			}
		}
	}
}
