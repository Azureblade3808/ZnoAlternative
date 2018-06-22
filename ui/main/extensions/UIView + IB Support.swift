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

import UIKit

extension UIView {
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `layer.borderColor` instead.")
	public var _BorderColor: UIColor? {
		get {
			if let cgColor = layer.borderColor {
				return UIColor(cgColor: cgColor)
			}
			else {
				return nil
			}
		}
		
		set {
			layer.borderColor = newValue?.cgColor
		}
	}
	
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `layer.borderWidth` instead.")
	public var _BorderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		
		set {
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `layer.cornerRadius` instead.")
	public var _CornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		
		set {
			layer.cornerRadius = newValue
		}
	}
	
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `layer.shadowColor` instead.")
	public var _ShadowColor: UIColor? {
		get {
			if let cgColor = layer.shadowColor {
				return UIColor(cgColor: cgColor)
			}
			else {
				return nil
			}
		}
		
		set {
			layer.shadowColor = newValue?.cgColor
		}
	}
	
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `layer.shadowOffset` instead.")
	public var _ShadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		
		set {
			layer.shadowOffset = newValue
		}
	}
	
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `layer.shadowOpacity` instead.")
	public var _ShadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		
		set {
			layer.shadowOpacity = newValue
		}
	}
	
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `layer.shadowRadius` instead.")
	public var _ShadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		
		set {
			layer.shadowRadius = newValue
		}
	}
}
