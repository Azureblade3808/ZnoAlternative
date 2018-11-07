import KMSXmlProcessor

extension XmlElement {
	/// 提取对应指定名称的属性或子元素文本（属性优先）。如果两者均不存在，\
	/// 返回`nil`。
	///
	/// - parameters:
	/// 	- name: 属性或子元素的名称。
	///
	/// - returns: 对应的值，或`nil`。
	public func attributeOrChildText(name: String) -> String? {
		return (
			self.attribute(name: name) ??
			self.firstChild(name: name)?.innerText
		)
	}
}
