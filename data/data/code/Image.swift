import UIKit

public struct Image {
	public let bundle: Bundle
	
	public let name: String
	
	public let size: Offset
	
	public init(bundle: Bundle, name: String, size: Offset) {
		self.bundle = bundle
		self.name = name
		self.size = size
	}
}

// MARK: -

extension Image {
	public var uiImage: UIImage? {
		return UIImage(named: name, in: bundle, compatibleWith: nil)
	}
}
