import UIKit

public struct Color : Hashable {
	public let value: UInt32
	
	public init(value: UInt32) {
		self.value = value
	}
}

// MARK: -

extension Color {
	public var string: String {
		return htmlString
	}
	
	public var hexadecimalString: String {
		return String(format: "0x%08X", value)
	}
	
	public var htmlString: String {
		return String(format: "#%08X", value)
	}
}

// MARK: -

fileprivate func colorValueFromString(_ string: String) -> UInt32? {
	return (
		colorValueFromHexadecimalString(string) ??
		colorValueFromHtmlString(string) ??
		colorValueFromName(string) ??
		nil
	)
}

fileprivate func colorValueFromHexadecimalString(_ string: String) -> UInt32? {
	let prefix = "0x"
	
	guard string.hasPrefix(prefix) else {
		return nil
	}
	
	let stringWithoutPrefix = String(string[prefix.endIndex...])
	let length = stringWithoutPrefix.unicodeScalars.count
	
	switch length {
		case 6: if true {
			var value: UInt32 = 0
			if Scanner(string: stringWithoutPrefix).scanHexInt32(&value) {
				return 0xFF000000 | value
			}
			else {
				return nil
			}
		}
		
		case 8: if true {
			var value: UInt32 = 0
			if Scanner(string: stringWithoutPrefix).scanHexInt32(&value) {
				return value
			}
			else {
				return nil
			}
		}
		
		default: if true {
			return nil
		}
	}
}

fileprivate func colorValueFromHtmlString(_ string: String) -> UInt32? {
	let prefix = "#"
	
	guard string.hasPrefix(prefix) else {
		return nil
	}
	
	let stringWithoutPrefix = String(string[prefix.endIndex...])
	let length = stringWithoutPrefix.unicodeScalars.count
	
	switch length {
		case 6: if true {
			var value: UInt32 = 0
			if Scanner(string: stringWithoutPrefix).scanHexInt32(&value) {
				return 0xFF000000 | value
			}
			else {
				return nil
			}
		}
		
		case 8: if true {
			var value: UInt32 = 0
			if Scanner(string: stringWithoutPrefix).scanHexInt32(&value) {
				return value
			}
			else {
				return nil
			}
		}
		
		default: if true {
			return nil
		}
	}
}

fileprivate func colorValueFromName(_ string: String) -> UInt32? {
	return nil
}

extension Color {
	public init?(string: String) {
		guard let value = colorValueFromString(string) else { return nil }
		
		self.init(value: value)
	}
	
	public init?(hexadecimalString: String) {
		guard let value = colorValueFromHexadecimalString(hexadecimalString) else { return nil }
		
		self.init(value: value)
	}
	
	public init?(htmlString: String) {
		guard let value = colorValueFromHtmlString(htmlString) else { return nil }
		
		self.init(value: value)
	}
	
	public init?(name: String) {
		guard let value = colorValueFromName(name) else { return nil }
		
		self.init(value: value)
	}
}

// MARK: -

extension Color {
	public var uiColor: UIColor {
		return UIColor(
			red: CGFloat((value >> 16) & 0xFF) / 0xFF,
			green: CGFloat((value >> 8) & 0xFF) / 0xFF,
			blue: CGFloat((value >> 0) & 0xFF) / 0xFF,
			alpha: CGFloat((value >> 24) & 0xFF) / 0xFF
		)
	}
}
