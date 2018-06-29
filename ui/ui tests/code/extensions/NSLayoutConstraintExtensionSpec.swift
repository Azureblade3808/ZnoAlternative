//
//  NSLayoutConstraintExtensionSpec.swift
//  ui tests
//
//  Created by 傅立业 on 2018/6/29.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

import Nimble
import Quick

internal class NSLayoutConstraintExtensionSpec : QuickSpec {
	override
	internal func spec() {
		describe("`NSLayoutConstraint`") {
			var outerView: UIView!
			
			var innerView: UIView!
			
			var widthConstraint: NSLayoutConstraint!
			
			var heightConstraint: NSLayoutConstraint!
			
			var findWidthConstraint: (() -> NSLayoutConstraint)!
			
			var findHeightConstraint: (() -> NSLayoutConstraint)!
			
			beforeEach {
				outerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
				
				innerView = UIView()
				innerView.translatesAutoresizingMaskIntoConstraints = false
				outerView.addSubview(innerView)
				
				let constraints: [NSLayoutConstraint] = [
					NSLayoutConstraint(item: innerView, attribute: .centerX, relatedBy: .equal, toItem: outerView, attribute: .centerX, multiplier: 1, constant: 0),
					NSLayoutConstraint(item: innerView, attribute: .centerY, relatedBy: .equal, toItem: outerView, attribute: .centerY, multiplier: 1, constant: 0),
					NSLayoutConstraint(item: innerView, attribute: .width, relatedBy: .equal, toItem: outerView, attribute: .width, multiplier: 1, constant: 0),
					NSLayoutConstraint(item: innerView, attribute: .height, relatedBy: .equal, toItem: outerView, attribute: .height, multiplier: 1, constant: 0),
				]
				NSLayoutConstraint.activate(constraints)
				
				widthConstraint = constraints[2]
				widthConstraint.identifier = "width"
				
				findWidthConstraint = {
					return outerView.constraints.first { $0.identifier == "width" }!
				}
				
				heightConstraint = constraints[3]
				heightConstraint.identifier = "height"
				
				findHeightConstraint = {
					return outerView.constraints.first { $0.identifier == "height" }!
				}
			}
			
			describe("`mutableMultipier`") {
				it("is usable on both the original and the replica") {
					let original = widthConstraint!
					
					widthConstraint.mutableMultiplier = 2
					let replica0 = findWidthConstraint()
					expect(replica0) !== original
					expect(replica0.multiplier) ≈ 2
					expect(replica0.mutableMultiplier) ≈ 2
					
					outerView.setNeedsLayout()
					outerView.layoutIfNeeded()
					expect(innerView.frame.width) ≈ 200
					
					replica0.mutableMultiplier = 2
					expect(findWidthConstraint()) == replica0
					
					outerView.setNeedsLayout()
					outerView.layoutIfNeeded()
					expect(innerView.frame.width) ≈ 200
					
					replica0.mutableMultiplier = 3
					let replica1 = findWidthConstraint()
					expect(replica1) !== original
					expect(replica1) !== replica0
					expect(replica1.multiplier) ≈ 3
					expect(replica1.mutableMultiplier) ≈ 3
					
					outerView.setNeedsLayout()
					outerView.layoutIfNeeded()
					expect(innerView.frame.width) ≈ 300
					
					replica0.mutableMultiplier = 4
					let replica2 = findWidthConstraint()
					expect(replica2) !== original
					expect(replica2) !== replica0
					expect(replica2) !== replica1
					
					outerView.setNeedsLayout()
					outerView.layoutIfNeeded()
					expect(innerView.frame.width) ≈ 400
					
					original.mutableMultiplier = 1
					expect(findWidthConstraint()) === original
					
					outerView.setNeedsLayout()
					outerView.layoutIfNeeded()
					expect(innerView.frame.width) ≈ 100
				}
			}
			
			describe("`constant`") {
				it("should keep accordance on both the original and the replica") {
					let original = heightConstraint!
					original.mutableMultiplier = 2
					
					let replica = findHeightConstraint()
					expect(replica) !== original
					expect(original.constant) == 0
					expect(replica.constant) == 0
					
					original.constant = 50
					expect(replica.constant) == 50
					
					replica.constant = 100
					expect(original.constant) == 100
				}
			}
			
			describe("`identifier`") {
				it("should keep accordance on both the original and the replica") {
					let original = widthConstraint!
					original.mutableMultiplier = 2
					
					let replica = findWidthConstraint()
					expect(replica) !== original
					
					expect(original.identifier) == "width"
					expect(replica.identifier) == "width"
					
					original.identifier = "A"
					expect(replica.identifier) == "A"
					
					original.identifier = nil
					expect(replica.identifier).to(beNil())
					
					replica.identifier = "B"
					expect(original.identifier) == "B"
					
					replica.identifier = nil
					expect(original.identifier).to(beNil())
				}
			}
			
			describe("`priority`") {
				it("should keep accordance on both the original and the replica") {
					let original = heightConstraint!
					original.mutableMultiplier = 2
					
					let replica = findHeightConstraint()
					expect(replica) !== original
					
					expect(original.priority) == .required
					expect(replica.priority) == .required
					
					original.priority = .defaultHigh
					expect(replica.priority) == .defaultHigh
					
					replica.priority = .defaultLow
					expect(original.priority) == .defaultLow
				}
			}
		}
	}
}
