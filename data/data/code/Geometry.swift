import Foundation

/// 二维偏移。
///
/// 可以用来表示一段距离，也可以用来表示一个具体的点（由原点出发的偏移量）。
public struct Offset : Hashable {
	/// X轴分量。
	public var x: Double
	
	/// Y轴分量。
	public var y: Double
	
	public init(x: Double, y: Double) {
		self.x = x
		self.y = y
	}
	
	/// 该偏移划过的面积。
	public var area: Double {
		return x * y
	}
	
	/// 该偏移的直线距离。
	public var distance: Double {
		return sqrt(x * x + y * y)
	}
	
	/// 横纵比（X/Y）。
	public var aspectRatio: Double {
		return x / y
	}
	
	/// 纵横比（Y/X）。
	public var inversedAspectRatio: Double {
		return y / x
	}
}

// MARK: -

extension Offset {
	public static let zero = Offset(x: 0, y: 0)
}

// MARK: -

/// 包边。
public struct Padding : Hashable {
	/// 左端长度。
	public var left: Double
	
	/// 上端长度。
	public var top: Double
	
	/// 右端长度。
	public var right: Double
	
	/// 下端长度。
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

/// 矩形范围。
public struct Rectangle : Hashable {
	/// 中心点。
	public var center: Offset
	
	/// 尺寸。
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
	
	/// 左端的X坐标。
	public var leftX: Double {
		return center.x - size.x / 2
	}
	
	/// 上端的Y坐标。
	public var topY: Double {
		return center.y - size.y / 2
	}
	
	/// 右端的X坐标。
	public var rightX: Double {
		return center.x + size.x / 2
	}
	
	/// 下端的Y坐标。
	public var bottomY: Double {
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
