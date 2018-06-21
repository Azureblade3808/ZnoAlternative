//
//  ApplicationSpec.swift
//  ui
//
//  Created by 傅立业 on 2018/6/21.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

import Nimble
import Quick

import ui

internal class ApplicationSpec : QuickSpec {
	override
	internal func spec() {
		describe("Application") {
			// Uh oh, it seems that subclasses of UIApplication is not testable
			// yet since there can only be one instance of UIApplication.
		}
	}
}
