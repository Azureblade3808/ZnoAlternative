//
//  main.swift
//  ui example
//
//  Created by 傅立业 on 2018/6/25.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

import UIKit

import ui

UIApplicationMain(
	CommandLine.argc,
	UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc)),
	NSStringFromClass(Application.self),
	NSStringFromClass(ApplicationDelegate.self)
)
