import Foundation

public struct Offset : Hashable {
	public var x: Double
	
	public var y: Double
	
	public init(x: Double, y: Double) {
		self.x = x
		self.y = y
	}
	
	public var area: Double {
		return x * y
	}
	
	public var distance: Double {
		return sqrt(x * x + y * y)
	}
	
	public var aspectRatio: Double {
		return x / y
	}
	
	public var inversedAspectRatio: Double {
		return y / x
	}
}

// MARK: -

extension Offset {
	public static let zero = Offset(x: 0, y: 0)
}

// MARK: -

public struct Padding : Hashable {
	public var left: Double
	
	public var top: Double
	
	public var right: Double
	
	public var bottom: Double
	
	public init(left: Double, top: Double, right: Double, bottom: Double) {
		self.left = left
		self.top = top
		self.right = right
		self.bottom = bottom
	}
}

// MARK: -

extension Padding {
	public static let zero = Padding(left: 0, top: 0, right: 0, bottom: 0)
}

// MARK: -

public struct Rectangle : Hashable {
	public var center: Offset
	
	public var size: Offset
	
	public init(center: Offset, size: Offset) {
		self.center = center
		self.size = size
	}
	
	public init(centerX: Double, centerY: Double, width: Double, height: Double) {
		self.center = Offset(x: centerX, y: centerY)
		self.size = Offset(x: width, y: height)
	}
	
	public init(leftX: Double, topY: Double, width: Double, height: Double) {
		self.center = Offset(x: leftX + width / 2, y: topY + height / 2)
		self.size = Offset(x: width, y: height)
	}
	
	public init(leftX: Double, topY: Double, rightX: Double, bottomY: Double) {
		self.center = Offset(x: (leftX + rightX) / 2, y: (topY + bottomY) / 2)
		self.size = Offset(x: rightX - leftX, y: bottomY - topY)
	}
	
	public var leftX: Double {
		return center.x - size.x / 2
	}
	
	public var topX: Double {
		return center.y - size.y / 2
	}
	
	public var rightX: Double {
		return center.x + size.x / 2
	}
	
	public var bottomX: Double {
		return center.y + size.y / 2
	}
}

// MARK: -

extension Rectangle {
	public static let zero = Rectangle(center: .zero, size: .zero)
}

// MARK: -

public prefix func -(a: Offset) -> Offset {
	return Offset(x: -a.x, y: -a.y)
}

public func +(a: Offset, b: Offset) -> Offset {
	return Offset(x: a.x + b.x, y: a.y + b.y)
}

public func -(a: Offset, b: Offset) -> Offset {
	return Offset(x: a.x - b.x, y: a.y - b.y)
}

public func *(a: Offset, b: Double) -> Offset {
	return Offset(x: a.x * b, y: a.y * b)
}

public func /(a: Offset, b: Double) -> Offset {
	return Offset(x: a.x / b, y: a.y / b)
}

public prefix func -(a: Padding) -> Padding {
	return Padding(left: -a.left, top: -a.top, right: -a.right, bottom: -a.bottom)
}

public func +(a: Padding, b: Padding) -> Padding {
	return Padding(left: a.left + b.left, top: a.top + b.top, right: a.right + b.right, bottom: a.bottom + b.bottom)
}

public func -(a: Padding, b: Padding) -> Padding {
	return Padding(left: a.left - b.left, top: a.top - b.top, right: a.right - b.right, bottom: a.bottom - b.bottom)
}

public func *(a: Padding, b: Double) -> Padding {
	return Padding(left: a.left * b, top: a.top * b, right: a.right * b, bottom: a.bottom * b)
}

public func /(a: Padding, b: Double) -> Padding {
	return Padding(left: a.left / b, top: a.top / b, right: a.right / b, bottom: a.bottom / b)
}

public func +(a: Rectangle, b: Padding) -> Rectangle {
	return Rectangle(
		center: Offset(
			x: a.center.x + (b.right - b.left) / 2,
			y: a.center.y + (b.bottom - b.top) / 2
		),
		size: Offset(
			x: a.size.x + (b.left + b.right),
			y: a.size.y + (b.top + b.bottom)
		)
	)
}

public func -(a: Rectangle, b: Padding) -> Rectangle {
	return Rectangle(
		center: Offset(
			x: a.center.x - (b.right - b.left) / 2,
			y: a.center.y - (b.bottom - b.top) / 2
		),
		size: Offset(
			x: a.size.x - (b.left + b.right),
			y: a.size.y - (b.top + b.bottom)
		)
	)
}
