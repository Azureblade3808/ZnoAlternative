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

@IBDesignable
public class AnnotionView : UIView {
	// MARK: Input
	
	public var arrowLength: CGFloat = 0 {
		didSet {
			if arrowLength != oldValue {
				setNeedsLayout()
			}
		}
	}
	
	public var upArrowIsVisible: Bool = false {
		didSet {
			upTriangleView.isHidden = !upArrowIsVisible
		}
	}
	
	public var leftArrowIsVisible: Bool = false {
		didSet {
			leftTriangleView.isHidden = !leftArrowIsVisible
		}
	}
	
	public var rightArrowIsVisible: Bool = false {
		didSet {
			rightTriangleView.isHidden = !rightArrowIsVisible
		}
	}
	
	public var downArrowIsVisible: Bool = false {
		didSet {
			downTriangleView.isHidden = !downArrowIsVisible
		}
	}
	
	// MARK: Interface Builder
	
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `arrowLength` instead.")
	private var _ArrowLength: CGFloat {
		get {
			return arrowLength
		}
		
		set {
			arrowLength = newValue
		}
	}
	
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `upArrowIsVisible` instead.")
	private var _UpArrow: Bool {
		get {
			return upArrowIsVisible
		}
		
		set {
			upArrowIsVisible = newValue
		}
	}
	
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `leftArrowIsVisible` instead.")
	private var _LeftArrow: Bool {
		get {
			return leftArrowIsVisible
		}
		
		set {
			leftArrowIsVisible = newValue
		}
	}
	
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `rightArrowIsVisible` instead.")
	private var _RightArrow: Bool {
		get {
			return rightArrowIsVisible
		}
		
		set {
			rightArrowIsVisible = newValue
		}
	}
	
	@IBInspectable
	@available(*, unavailable, message: "Restricted for Interface Builder. Use `downArrowIsVisible` instead.")
	private var _DownArrow: Bool {
		get {
			return downArrowIsVisible
		}
		
		set {
			downArrowIsVisible = newValue
		}
	}

	// MARK: Private
	
	private let upTriangleView = UpTriangleView()
	
	private let leftTriangleView = LeftTriangleView()
	
	private let rightTriangleView = RightTriangleView()
	
	private let downTriangleView = DownTriangleView()
	
	private func setup() {
		buildViewHierarchy()
	}
	
	private func buildViewHierarchy() {
		for triangleView in [upTriangleView, leftTriangleView, rightTriangleView, downTriangleView] {
			triangleView.color = backgroundColor
			triangleView.isHidden = true
			triangleView.isOpaque = false
			super.addSubview(triangleView)
		}
	}
	
	// MARK: Override - UIView
	
	override
	public init(frame: CGRect) {
		super.init(frame: frame)
		
		setup()
	}
	
	required
	public init?(coder: NSCoder) {
		super.init(coder: coder)
		
		setup()
	}
	
	override
	public var backgroundColor: UIColor? {
		didSet {
			for triangleView in [upTriangleView, leftTriangleView, rightTriangleView, downTriangleView] {
				triangleView.color = backgroundColor
			}
		}
	}
	
	override
	public func layoutSubviews() {
		super.layoutSubviews()
		
		let size = bounds.size
		let arrowLength = self.arrowLength
		
		upTriangleView.frame = CGRect(x: size.width / 2 - arrowLength, y: -arrowLength, width: arrowLength * 2, height: arrowLength)
		leftTriangleView.frame = CGRect(x: -arrowLength, y: size.height / 2 - arrowLength, width: arrowLength, height: arrowLength * 2)
		rightTriangleView.frame = CGRect(x: size.width, y: size.height / 2 - arrowLength, width: arrowLength, height: arrowLength * 2)
		downTriangleView.frame = CGRect(x: size.width / 2 - arrowLength, y: size.height, width: arrowLength * 2, height: arrowLength)
	}
}

// MARK: -

fileprivate class TriangleView : UIView {
	fileprivate var color: UIColor? = nil {
		didSet {
			if color != oldValue {
				setNeedsDisplay()
			}
		}
	}
}

fileprivate final class UpTriangleView : TriangleView {
	override
	fileprivate func draw(_ rect: CGRect) {
		guard let color = color?.cgColor else { return }
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		context.clear(rect)
		
		let size = bounds.size
		
		let point0 = CGPoint(x: size.width / 2, y: 0)
		let point1 = CGPoint(x: 0, y: size.height)
		let point2 = CGPoint(x: size.width, y: size.height)
		let points = [point0, point1, point2]
		context.addLines(between: points)
		
		context.setFillColor(color)
		context.fillPath()
	}
}

fileprivate final class LeftTriangleView : TriangleView {
	override
	fileprivate func draw(_ rect: CGRect) {
		guard let color = color?.cgColor else { return }
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		context.clear(rect)
		
		let size = bounds.size
		
		let point0 = CGPoint(x: 0, y: size.height / 2)
		let point1 = CGPoint(x: size.width, y: 0)
		let point2 = CGPoint(x: size.width, y: size.height)
		let points = [point0, point1, point2]
		context.addLines(between: points)
		
		context.setFillColor(color)
		context.fillPath()
	}
}

fileprivate final class RightTriangleView : TriangleView {
	override
	fileprivate func draw(_ rect: CGRect) {
		guard let color = color?.cgColor else { return }
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		context.clear(rect)
		
		let size = bounds.size
		
		let point0 = CGPoint(x: size.width, y: size.height / 2)
		let point1 = CGPoint(x: 0, y: 0)
		let point2 = CGPoint(x: 0, y: size.height)
		let points = [point0, point1, point2]
		context.addLines(between: points)
		
		context.setFillColor(color)
		context.fillPath()
	}
}

fileprivate final class DownTriangleView : TriangleView {
	override
	fileprivate func draw(_ rect: CGRect) {
		guard let color = color?.cgColor else { return }
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		context.clear(rect)
		
		let size = bounds.size
		
		let point0 = CGPoint(x: size.width / 2, y: size.height)
		let point1 = CGPoint(x: 0, y: 0)
		let point2 = CGPoint(x: size.width, y: 0)
		let points = [point0, point1, point2]
		context.addLines(between: points)
		
		context.setFillColor(color)
		context.fillPath()
	}
}
