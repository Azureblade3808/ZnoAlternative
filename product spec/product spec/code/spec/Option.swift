import KMSXmlProcessor

/// 选项，用于描述产品的状态。
public final class Option : CustomStringConvertible, Equatable {
	/// 所处选项组的ID。
	public internal(set) var groupId: String = ""
	
	/// 自身ID。应在组内唯一。
	public internal(set) var id: String = ""
	
	/// 标题，描述性文本。
	public internal(set) var title: String = ""
	
	// MARK: Conform - CustomStringConvertible
	
	public var description: String {
		return "\(groupId).\(id)"
	}
}

// MARK: -

public func ==(a: Option, b: Option) -> Bool {
	return a === b
}

// MARK: -

extension Option {
	/// 从XML中加载内容进行初始化。
	///
	/// - note:
	/// XML片段形如：
	/// ```xml
	/// <option id="..." title="..." />
	/// ```
	///
	/// - parameters:
	/// 	- xml: 对应的XML元素。
	internal convenience init(xml: XmlElement) {
		self.init()
		
		id = xml.attributeOrChildText(name: "id")!
		
		title = xml.attributeOrChildText(name: "title")!
	}
}
