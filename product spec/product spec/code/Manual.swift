import Foundation
import KMSXmlProcessor

import data

/// 产品规格手册。
open class Manual: Equatable {
	// MARK: Metadata
	
	/// 版本号。
	public internal(set) var version: String = ""
	
	// MARK: Option Groups
	
	/// 选项组的数组。
	public internal(set) var optionGroups: [OptionGroup] = []
	
	/// 由所有选项组的ID组成的数组。
	public var optionGroupIds: [String] {
		return optionGroups.map { $0.id }
	}
	
	/// 查找指定ID对应的选项组。
	///
	/// - parameters:
	/// 	- id: 选项组ID。
	///
	/// - returns: 对应的选项组，或nil。
	public func optionGroup(for id: String) -> OptionGroup? {
		return optionGroups.first { $0.id == id }
	}
	
	// MARK: Boolean Maps
	
	/// 布尔值参数表的数组。
	public internal(set) var booleanMaps: [BooleanMap] = []
	
	public var booleanMapIds: [String] {
		return booleanMaps.map { $0.id }
	}
	
	public func booleanMap(for id: String) -> BooleanMap? {
		return booleanMaps.first { $0.id == id }
	}
	
	public func booleanValue(for tuple: (id: String, optionSet: [Option])) -> Bool? {
		return booleanMap(for: tuple.id)?.value(for: tuple.optionSet)
	}
	
	// MARK: Integer Maps
	
	/// 整数参数表的数组。
	public internal(set) var integerMaps: [IntegerMap] = []
	
	public var integerMapIds: [String] {
		return integerMaps.map { $0.id }
	}
	
	public func integerMap(for id: String) -> IntegerMap? {
		return integerMaps.first { $0.id == id }
	}
	
	public func integerValue(for tuple: (id: String, optionSet: [Option])) -> Int? {
		return integerMap(for: tuple.id)?.value(for: tuple.optionSet)
	}
	
	// MARK: Float Maps
	
	/// 浮点数参数表的数组。
	public internal(set) var floatMaps: [FloatMap] = []
	
	public var floatMapIds: [String] {
		return floatMaps.map { $0.id }
	}
	
	public func floatMap(for id: String) -> FloatMap? {
		return floatMaps.first { $0.id == id }
	}
	
	public func floatValue(for tuple: (id: String, optionSet: [Option])) -> Double? {
		return floatMap(for: tuple.id)?.value(for: tuple.optionSet)
	}
	
	// MARK: String Maps
	
	/// 字符串参数表的数组。
	public internal(set) var stringMaps: [StringMap] = []
	
	public var stringMapIds: [String] {
		return stringMaps.map { $0.id }
	}
	
	public func stringMap(for id: String) -> StringMap? {
		return stringMaps.first { $0.id == id }
	}
	
	public func stringValue(for tuple: (id: String, optionSet: [Option])) -> String? {
		return stringMap(for: tuple.id)?.value(for: tuple.optionSet)
	}
	
	// MARK: Size Maps
	
	/// 尺寸参数表的数组。
	public internal(set) var sizeMaps: [SizeMap] = []
	
	public var sizeMapIds: [String] {
		return sizeMaps.map { $0.id }
	}
	
	public func sizeMap(for id: String) -> SizeMap? {
		return sizeMaps.first { $0.id == id }
	}
	
	public func sizeValue(for tuple: (id: String, optionSet: [Option])) -> Offset? {
		return sizeMap(for: tuple.id)?.value(for: tuple.optionSet)
	}
	
	// MARK: Padding Maps
	
	/// 边距参数表的数组。
	public internal(set) var paddingMaps: [PaddingMap] = []
	
	public var paddingMapIds: [String] {
		return paddingMaps.map { $0.id }
	}
	
	public func paddingMap(for id: String) -> PaddingMap? {
		return paddingMaps.first { $0.id == id }
	}
	
	public func paddingValue(for tuple: (id: String, optionSet: [Option])) -> Padding? {
		return paddingMap(for: tuple.id)?.value(for: tuple.optionSet)
	}
	
	// MARK: Color Maps
	
	/// 颜色参数表的数组。
	public internal(set) var colorMaps: [ColorMap] = []
	
	public var colorMapIds: [String] {
		return colorMaps.map { $0.id }
	}
	
	public func colorMap(for id: String) -> ColorMap? {
		return colorMaps.first { $0.id == id }
	}
	
	public func colorValue(for tuple: (id: String, optionSet: [Option])) -> Color? {
		return colorMap(for: tuple.id)?.value(for: tuple.optionSet)
	}
	
	// MARK: Image Maps
	
	/// 图片参数表的数组。
	public internal(set) var imageMaps: [ImageMap] = []
	
	public var imageMapIds: [String] {
		return imageMaps.map { $0.id }
	}
	
	public func imageMap(for id: String) -> ImageMap? {
		return imageMaps.first { $0.id == id }
	}
	
	public func imageValue(for tuple: (id: String, optionSet: [Option])) -> Image? {
		return imageMap(for: tuple.id)?.value(for: tuple.optionSet)
	}
	
	// MARK: Conform - Equatable
	
	public static func ==(a: Manual, b: Manual) -> Bool {
		return a === b
	}
}

// MARK: -

extension Manual {
	public convenience init(named name: String, in bundle: Bundle? = nil) {
		self.init()
		
		let bundle = bundle ?? .main
		let xml = try! XmlElement(data: try! Data(contentsOf: bundle.url(forResource: name, withExtension: "xml")!))
		
		version = xml.attributeOrChildText(name: "version")!
		
		optionGroups = xml.children(name: "option-group").map { OptionGroup(xml: $0) }
		
		booleanMaps = xml.children(name: "parameter-boolean").map { BooleanMap(xml: $0) }
		
		integerMaps = xml.children(name: "parameter-integer").map { IntegerMap(xml: $0) }
		
		floatMaps = xml.children(name: "parameter-float").map { FloatMap(xml: $0) }
		
		stringMaps = xml.children(name: "parameter-string").map { StringMap(xml: $0) }
		
		sizeMaps = xml.children(name: "parameter-size").map { SizeMap(xml: $0) }
		
		paddingMaps = xml.children(name: "parameter-padding").map { PaddingMap(xml: $0) }
		
		colorMaps = xml.children(name: "parameter-color").map { ColorMap(xml: $0) }
		
		imageMaps = xml.children(name: "parameter-image").map { ImageMap(xml: $0, bundle: bundle) }
	}
}
