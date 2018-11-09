import KMSXmlProcessor

import data

/// 参数表。
public class ParameterMap<Value> : CustomStringConvertible, Equatable {
	/// ID。
	public internal(set) var id: String = ""
	
	/// 内部表。
	public internal(set) var innerMap: OptionSetMap = OptionSetMap<Value>()
	
	// MARK: Conform - CustomStringConvertible
	
	public var description: String {
		return id
	}
}

// MARK: -

public func ==<Value>(a: ParameterMap<Value>, b: ParameterMap<Value>) -> Bool {
	return a === b
}

// MARK: -

extension ParameterMap {
	/// 查找对应指定选项组合的参数值。
	///
	/// - parameters:
	/// 	- optionSet: 选项组合。
	///
	/// - returns: 对应的参数值，或`nil`。
	public func value(for optionSet: [Option]) -> Value? {
		return innerMap.value(for: optionSet)
	}
	
	public subscript(optionSet: [Option]) -> Value? {
		return value(for: optionSet)
	}
}

// MARK: -

public final class BooleanMap : ParameterMap<Bool> {}

// MARK: -

extension BooleanMap {
	/// 从XML中加载内容进行初始化。
	///
	/// - note:
	/// XML片段形如：
	/// ```xml
	/// <parameter-boolean id="...">
	/// 	<entry key="..." value="..." />
	/// 	<entry key="..." value="..." />
	/// </parameter-boolean>
	/// ```
	///
	/// - parameters:
	/// 	- xml: 对应的XML元素。
	internal convenience init(xml: XmlElement) {
		self.init()
		
		id = xml.attributeOrChildText(name: "id")!
		
		innerMap.entries = {
			var entries: [(OptionSetRule, Bool?)] = []
			
			for entryXml in xml.children(name: "entry") {
				let key = OptionSetRule(string: entryXml.attributeOrChildText(name: "key") ?? "")
				let value = entryXml.attributeOrChildText(name: "value")?.boolValue
				entries.append((key, value))
			}
			
			return entries
		} ()
	}
}

// MARK: -

public final class IntegerMap : ParameterMap<Int> {}

// MARK: -

extension IntegerMap {
	/// 从XML中加载内容进行初始化。
	///
	/// - note:
	/// XML片段形如：
	/// ```xml
	/// <parameter-boolean id="...">
	/// 	<entry key="..." value="..." />
	/// 	<entry key="..." value="..." />
	/// </parameter-boolean>
	/// ```
	///
	/// - parameters:
	/// 	- xml: 对应的XML元素。
	internal convenience init(xml: XmlElement) {
		self.init()
		
		id = xml.attributeOrChildText(name: "id")!
		
		innerMap.entries = {
			var entries: [(OptionSetRule, Int?)] = []
			
			for entryXml in xml.children(name: "entry") {
				let key = OptionSetRule(string: entryXml.attributeOrChildText(name: "key") ?? "")
				let value = entryXml.attributeOrChildText(name: "value")?.intValue
				entries.append((key, value))
			}
			
			return entries
		} ()
	}
}

// MARK: -

public final class FloatMap : ParameterMap<Double> {}

// MARK: -

extension FloatMap {
	/// 从XML中加载内容进行初始化。
	///
	/// - note:
	/// XML片段形如：
	/// ```xml
	/// <parameter-boolean id="...">
	/// 	<entry key="..." value="..." />
	/// 	<entry key="..." value="..." />
	/// </parameter-boolean>
	/// ```
	///
	/// - parameters:
	/// 	- xml: 对应的XML元素。
	internal convenience init(xml: XmlElement) {
		self.init()
		
		id = xml.attributeOrChildText(name: "id")!
		
		innerMap.entries = {
			var entries: [(OptionSetRule, Double?)] = []
			
			for entryXml in xml.children(name: "entry") {
				let key = OptionSetRule(string: entryXml.attributeOrChildText(name: "key") ?? "")
				let value = entryXml.attributeOrChildText(name: "value")?.doubleValue
				entries.append((key, value))
			}
			
			return entries
		} ()
	}
}

// MARK: -

public final class StringMap : ParameterMap<String> {}

// MARK: -

extension StringMap {
	/// 从XML中加载内容进行初始化。
	///
	/// - note:
	/// XML片段形如：
	/// ```xml
	/// <parameter-boolean id="...">
	/// 	<entry key="..." value="..." />
	/// 	<entry key="..." value="..." />
	/// </parameter-boolean>
	/// ```
	///
	/// - parameters:
	/// 	- xml: 对应的XML元素。
	internal convenience init(xml: XmlElement) {
		self.init()
		
		id = xml.attributeOrChildText(name: "id")!
		
		innerMap.entries = {
			var entries: [(OptionSetRule, String?)] = []
			
			for entryXml in xml.children(name: "entry") {
				let key = OptionSetRule(string: entryXml.attributeOrChildText(name: "key") ?? "")
				let value = entryXml.attributeOrChildText(name: "value")
				entries.append((key, value))
			}
			
			return entries
		} ()
	}
}

// MARK: -

public final class SizeMap : ParameterMap<Offset> {}

// MARK: -

extension SizeMap {
	/// 从XML中加载内容进行初始化。
	///
	/// - note:
	/// XML片段形如：
	/// ```xml
	/// <parameter-boolean id="...">
	/// 	<entry key="..." width="..." height="..." />
	/// 	<entry key="..." width="..." height="..." />
	/// </parameter-boolean>
	/// ```
	///
	/// - parameters:
	/// 	- xml: 对应的XML元素。
	internal convenience init(xml: XmlElement) {
		self.init()
		
		id = xml.attributeOrChildText(name: "id")!
		
		innerMap.entries = {
			var entries: [(OptionSetRule, Offset?)] = []
			
			for entryXml in xml.children(name: "entry") {
				let key = OptionSetRule(string: entryXml.attributeOrChildText(name: "key") ?? "")
				let value: Offset? = {
					guard let width = entryXml.attributeOrChildText(name: "width")?.doubleValue else { return nil }
					guard let height = entryXml.attributeOrChildText(name: "height")?.doubleValue else { return nil }
					
					return Offset(x: width, y: height)
				} ()
				entries.append((key, value))
			}
			
			return entries
		} ()
	}
}

// MARK: -

public final class PaddingMap : ParameterMap<Padding> {}

// MARK: -

extension PaddingMap {
	/// 从XML中加载内容进行初始化。
	///
	/// - note:
	/// XML片段形如：
	/// ```xml
	/// <parameter-boolean id="...">
	/// 	<entry key="..." left="..." top="..." right="..." bottom="..." />
	/// 	<entry key="..." left="..." top="..." right="..." bottom="..." />
	/// </parameter-boolean>
	/// ```
	///
	/// - parameters:
	/// 	- xml: 对应的XML元素。
	internal convenience init(xml: XmlElement) {
		self.init()
		
		id = xml.attributeOrChildText(name: "id")!
		
		innerMap.entries = {
			var entries: [(OptionSetRule, Padding?)] = []
			
			for entryXml in xml.children(name: "entry") {
				let key = OptionSetRule(string: entryXml.attributeOrChildText(name: "key") ?? "")
				let value: Padding? = {
					guard let left = entryXml.attributeOrChildText(name: "left")?.doubleValue else { return nil }
					guard let top = entryXml.attributeOrChildText(name: "top")?.doubleValue else { return nil }
					guard let right = entryXml.attributeOrChildText(name: "right")?.doubleValue else { return nil }
					guard let bottom = entryXml.attributeOrChildText(name: "bottom")?.doubleValue else { return nil }
					
					return Padding(left: left, top: top, right: right, bottom: bottom)
				} ()
				entries.append((key, value))
			}
			
			return entries
		} ()
	}
}

// MARK: -

public final class ColorMap : ParameterMap<Color> {}

// MARK: -

extension ColorMap {
	/// 从XML中加载内容进行初始化。
	///
	/// - note:
	/// XML片段形如：
	/// ```xml
	/// <parameter-boolean id="...">
	/// 	<entry key="..." value="..." />
	/// 	<entry key="..." value="..." />
	/// </parameter-boolean>
	/// ```
	///
	/// - parameters:
	/// 	- xml: 对应的XML元素。
	internal convenience init(xml: XmlElement) {
		self.init()
		
		id = xml.attributeOrChildText(name: "id")!
		
		innerMap.entries = {
			var entries: [(OptionSetRule, Color?)] = []
			
			for entryXml in xml.children(name: "entry") {
				let key = OptionSetRule(string: entryXml.attributeOrChildText(name: "key") ?? "")
				let value: Color? = {
					guard let string = entryXml.attributeOrChildText(name: "value") else { return nil }
					
					return Color(string: string)
				} ()
				entries.append((key, value))
			}
			
			return entries
		} ()
	}
}

// MARK: -

public final class ImageMap : ParameterMap<Image> {}

// MARK: -

extension ImageMap {
	/// 从XML中加载内容进行初始化。
	///
	/// - note:
	/// XML片段形如：
	/// ```xml
	/// <parameter-boolean id="...">
	/// 	<entry key="..." name="..." width="..." height="..." />
	/// 	<entry key="..." name="..." width="..." height="..." />
	/// </parameter-boolean>
	/// ```
	///
	/// - parameters:
	/// 	- xml: 对应的XML元素。
	/// 	- bundle: 数据包。
	internal convenience init(xml: XmlElement, bundle: Bundle) {
		self.init()
		
		id = xml.attributeOrChildText(name: "id")!
		
		innerMap.entries = {
			var entries: [(OptionSetRule, Image?)] = []
			
			for entryXml in xml.children(name: "entry") {
				let key = OptionSetRule(string: entryXml.attributeOrChildText(name: "key") ?? "")
				let value: Image? = {
					guard let name = entryXml.attributeOrChildText(name: "name") else { return nil }
					
					let size = Offset(
						x: entryXml.attributeOrChildText(name: "width")?.doubleValue ?? 0,
						y: entryXml.attributeOrChildText(name: "height")?.doubleValue ?? 0
					)
					
					return Image(bundle: bundle, name: name, size: size)
				} ()
				entries.append((key, value))
			}
			
			return entries
		} ()
	}
}
