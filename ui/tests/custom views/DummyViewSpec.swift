//
//  DummyViewSpec.swift
//  ui
//
//  Created by 傅立业 on 2018/6/21.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

import Nimble
import Quick

import ui

internal class DummyViewSpec : QuickSpec {
	override
	internal func spec() {
		describe("`DummyView`") {
			var dummyView: DummyView!
			
			beforeEach {
				dummyView = DummyView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
			}
			
			it("should not respond to touches itself") {
				expect(dummyView.hitTest(CGPoint(x: 50, y: 50), with: nil)).to(beNil())
			}
			
			it("should alllow its subviews to respond to touches") {
				let childView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
				dummyView.addSubview(childView)
				
				expect(dummyView.hitTest(CGPoint(x: 50, y: 50), with: nil)) == childView
			}
		}
	}
}
