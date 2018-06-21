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
		describe("DummyView") {
			var dummyView: DummyView!
			
			beforeEach {
				dummyView = DummyView(frame: CGRect(x: 0, y: 0, width: 101, height: 101))
			}
			
			it("should not respond to touches") {
				expect(dummyView.hitTest(CGPoint(x: 0, y: 0), with: nil)).to(beNil())
				expect(dummyView.hitTest(CGPoint(x: 50, y: 0), with: nil)).to(beNil())
				expect(dummyView.hitTest(CGPoint(x: 100, y: 0), with: nil)).to(beNil())
				expect(dummyView.hitTest(CGPoint(x: 0, y: 50), with: nil)).to(beNil())
				expect(dummyView.hitTest(CGPoint(x: 50, y: 50), with: nil)).to(beNil())
				expect(dummyView.hitTest(CGPoint(x: 100, y: 50), with: nil)).to(beNil())
				expect(dummyView.hitTest(CGPoint(x: 0, y: 100), with: nil)).to(beNil())
				expect(dummyView.hitTest(CGPoint(x: 50, y: 100), with: nil)).to(beNil())
				expect(dummyView.hitTest(CGPoint(x: 100, y: 100), with: nil)).to(beNil())
			}
			
			it("should have its children respond to touches") {
				let childView = UIView(frame: CGRect(x: 0, y: 0, width: 101, height: 101))
				dummyView.addSubview(childView)
				
				expect(dummyView.hitTest(CGPoint(x: 0, y: 0), with: nil)) == childView
				expect(dummyView.hitTest(CGPoint(x: 50, y: 0), with: nil)) == childView
				expect(dummyView.hitTest(CGPoint(x: 100, y: 0), with: nil)) == childView
				expect(dummyView.hitTest(CGPoint(x: 0, y: 50), with: nil)) == childView
				expect(dummyView.hitTest(CGPoint(x: 50, y: 50), with: nil)) == childView
				expect(dummyView.hitTest(CGPoint(x: 100, y: 50), with: nil)) == childView
				expect(dummyView.hitTest(CGPoint(x: 0, y: 100), with: nil)) == childView
				expect(dummyView.hitTest(CGPoint(x: 50, y: 100), with: nil)) == childView
				expect(dummyView.hitTest(CGPoint(x: 100, y: 100), with: nil)) == childView
			}
		}
	}
}
