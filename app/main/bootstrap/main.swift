//
//  main.swift
//  app
//
//  Created by 傅立业 on 2018/6/21.
//  Copyright © 2018 Zno Inc. All rights reserved.
//

import UIKit

UIApplicationMain(
	CommandLine.argc,
	UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc)),
	nil,
	nil
)
