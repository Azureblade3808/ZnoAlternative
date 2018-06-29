//	MIT License
//
//	Copyright (c) 2018 傅立业（Chris Fu）
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.

import ReactiveCocoa
import ReactiveSwift
import UIKit

fileprivate var replicaKey: Int8 = 0

extension NSLayoutConstraint {
	/// A settable multiplier.
	///
	/// Setting it with a different value will in fact deactivate the receiver
	/// and adopt a replica constraint with the given multiplier value in place
	/// of the receiver.
	///
	/// - precondition:
	/// The receiver is active.
	///
	/// - postcondition:
	/// The receiver may be replaced with a replica constraint, so it may be
	/// inactive.
	///
	/// - note:
	/// `NSLayoutConstraint.multiplier` is readonly. Adjusting the multiplier
	/// value of a constraint needs to be accomplished by adopting a new
	/// constraint. This property is provided to simplify such a task.
	@objc dynamic
	public var mutableMultiplier: CGFloat {
		get {
			return replica?.mutableMultiplier ?? multiplier
		}
		
		set {
			if let oldReplica = replica {
				if newValue != oldReplica.multiplier {
					let tailReplica: NSLayoutConstraint = {
						var replica = oldReplica
						while let nextReplica = replica.replica {
							replica = nextReplica
						}
						return replica
					} ()
					tailReplica.isActive = false
					
					if newValue == multiplier {
						isActive = true
						replica = nil
					}
					else {
						let newReplica = createReplica(multiplier: newValue)
						newReplica.isActive = true
						replica = newReplica
					}
				}
			}
			else {
				if newValue != multiplier {
					isActive = false
					
					let newReplica = createReplica(multiplier: newValue)
					newReplica.isActive = true
					replica = newReplica
				}
			}
		}
	}
	
	private var replica: NSLayoutConstraint? {
		get {
			return objc_getAssociatedObject(self, &replicaKey) as! NSLayoutConstraint?
		}
		
		set {
			objc_setAssociatedObject(self, &replicaKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	private func createReplica(multiplier: CGFloat) -> NSLayoutConstraint {
		let replica = NSLayoutConstraint(
			item: firstItem as Any,
			attribute: firstAttribute,
			relatedBy: relation,
			toItem: secondItem,
			attribute: secondAttribute,
			multiplier: multiplier,
			constant: constant
		)
		replica.identifier = identifier
		replica.priority = priority
		
		// Setup two-way bindings for mutable properties.
		if true {
			reactive.makeBindingTarget {
				guard $0.constant != $1 else { return }
				
				$0.constant = $1
			} <~ (
				replica.reactive.signal(forKeyPath: #keyPath(constant)).map { $0 as! CGFloat }
			)
			replica.reactive.makeBindingTarget {
				guard $0.constant != $1 else { return }
				
				$0.constant = $1
			} <~ (
				reactive.signal(forKeyPath: #keyPath(constant)).map { $0 as! CGFloat }
			)
			
			reactive.makeBindingTarget {
				guard $0.identifier != $1 else { return }
				
				$0.identifier = $1
			} <~ (
				replica.reactive.signal(forKeyPath: #keyPath(identifier)).map { $0 as! String? }
			)
			replica.reactive.makeBindingTarget {
				guard $0.identifier != $1 else { return }
				
				$0.identifier = $1
			} <~ (
				reactive.signal(forKeyPath: #keyPath(identifier)).map { $0 as! String? }
			)
			
			reactive.makeBindingTarget {
				guard $0.priority != $1 else { return }
				
				$0.priority = $1
			} <~ (
				replica.reactive.signal(forKeyPath: #keyPath(priority)).map { $0 as! UILayoutPriority }
			)
			replica.reactive.makeBindingTarget {
				guard $0.priority != $1 else { return }
				
				$0.priority = $1
			} <~ (
				reactive.signal(forKeyPath: #keyPath(priority)).map { $0 as! UILayoutPriority }
			)
		}
		
		return replica
	}
}
