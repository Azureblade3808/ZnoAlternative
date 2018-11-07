import KMSXmlProcessor

/// 选项组，用于存放一系列可选的产品状态。
public final class OptionGroup {
	/// ID。
	public internal(set) var id: String = ""
	
	/// 本组内选项的数组。
	public internal(set) var options: [Option] = []
	
	/// 白名单表。
	///
	/// 键为特定的选项组合，值为在这种选项组合下本组内可用的选项ID的数组。
	public internal(set) var whiteListMap: OptionSetMap<[String]>?
	
	/// 黑名单表。
	///
	/// 键为特定的选项组合，值为在这种选项组合下本组内不可用的选项ID的数组。
	public internal(set) var blackListMap: OptionSetMap<[String]>?
	
	/// 默认选项ID表。
	///
	/// 键为特定的选项组合，值为在这种选项组合下本组内默认选项ID。
	public internal(set) var defaultOptionIdMap: OptionSetMap<String>?
}

// MARK: -

extension OptionGroup {
	/// 在本组内查找指定ID对应的选项。
	///
	/// - parameters:
	/// 	- id: ID。
	///
	/// - returns: 对应的选项，或`nil`。
	public func option(for id: String) -> Option? {
		let option = options.first { $0.id == id }
		
		return option
	}
	
	/// 获取指定选项组合下，本组内可用选项的数组。
	///
	/// - parameters:
	/// 	- optionSet: 选项组合。缺省为空数组。
	///
	/// - returns: 可用选项的数组。
	public func availableOptions(for optionSet: [Option] = []) -> [Option] {
		var availableOptions = options
		
		// 如果存在对应的白名单，需要进行白名单过滤。
		if let whiteList = whiteListMap?.value(for: optionSet) {
			availableOptions = availableOptions.filter { whiteList.contains($0.id) }
		}
		
		// 如果存在对应的黑名单，需要进行黑名单过滤。
		if let blackList = blackListMap?.value(for: optionSet) {
			availableOptions = availableOptions.filter { !blackList.contains($0.id) }
		}
		
		return availableOptions
	}
	
	/// 获取指定选项组合下，本组内默认选项。
	///
	/// - parameters:
	/// 	- optionSet: 选项组合。缺省为空数组。
	///
	/// - returns: 默认选项，或`nil`。
	public func defaultOption(for optionSet: [Option]) -> Option? {
		// 如果存在指定的默认选项，优先使用之。
		if let defaultOptionId = defaultOptionIdMap?.value(for: optionSet), let defaultOption = option(for: defaultOptionId) {
			return defaultOption
		}
		// 否则使用可用选项中的第一个（如果有）。
		else {
			let availableOptions = self.availableOptions(for: optionSet)
			let defaultOption = availableOptions.first
			
			return defaultOption
		}
	}
}

// MARK: -

/// 正则表达式，用于匹配标识符。
fileprivate let regex0 = try! NSRegularExpression(pattern: "\\w+")

extension OptionGroup {
	/// 从XML中加载内容进行初始化。
	///
	/// - note:
	/// XML片段形如：
	/// ```xml
	/// <option-group id="...">
	/// 	<option ... />
	/// 	<option ... />
	///
	/// 	<white-list-map>
	/// 		<entry key="..." value="..." />
	/// 		<entry key="..." value="..." />
	/// 	</white-list-map>
	///
	/// 	<black-list-map>
	/// 		<entry key="..." value="..." />
	/// 		<entry key="..." value="..." />
	/// 	</black-list-map>
	///
	/// 	<default-option-map>
	/// 		<entry key="..." value="..." />
	/// 		<entry key="..." value="..." />
	/// 	</default-option-map>
	/// </option-group>
	/// ```
	///
	/// - parameters:
	/// 	- xml: 对应的XML元素。
	internal convenience init(xml: XmlElement) {
		self.init()
		
		id = xml.attributeOrChildText(name: "id")!
		
		options = xml.children(name: "option").map {
			let option = Option(xml: $0)
			option.groupId = id
			
			return option
		}
		
		whiteListMap = {
			if let whiteListMapXml = xml.firstChild(name: "white-list-map") {
				var whiteListMap = OptionSetMap<[String]>()
				
				for entryXml in whiteListMapXml.children(name: "entry") {
					let key = OptionSetRule(string: entryXml.attributeOrChildText(name: "key") ?? "")
					let value = entryXml.attributeOrChildText(name: "value")?.substrings(for: regex0) ?? []
					whiteListMap.entries.append((key, value))
				}
				
				return whiteListMap
			}
			else {
				return nil
			}
		} ()
		
		blackListMap = {
			if let blackListMapXml = xml.firstChild(name: "black-list-map") {
				var blackListMap = OptionSetMap<[String]>()
				
				for entryXml in blackListMapXml.children(name: "entry") {
					let key = OptionSetRule(string: entryXml.attributeOrChildText(name: "key") ?? "")
					let value = entryXml.attributeOrChildText(name: "value")?.substrings(for: regex0) ?? []
					blackListMap.entries.append((key, value))
				}
				
				return blackListMap
			}
			else {
				return nil
			}
		} ()
		
		defaultOptionIdMap = {
			if let defaultOptionMapXml = xml.firstChild(name: "default-option-map") {
				var defaultOptionIdMap = OptionSetMap<String>()
				
				for entryXml in defaultOptionMapXml.children(name: "entry") {
					let key = OptionSetRule(string: entryXml.attributeOrChildText(name: "key") ?? "")
					let value = entryXml.attributeOrChildText(name: "value") ?? ""
					defaultOptionIdMap.entries.append((key, value))
				}
				
				return defaultOptionIdMap
			}
			else {
				return nil
			}
		} ()
	}
}
