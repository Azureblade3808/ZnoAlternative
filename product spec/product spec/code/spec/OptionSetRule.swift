import Foundation

/// 选项组合规则。
public struct OptionSetRule {
	/// 内部表。
	///
	/// 键为选项组ID，值为该选项组内可接受的选项ID的数组。
	public var innerMap: [String : [String]] = [:]
}

// MARK: -

extension OptionSetRule {
	/// 检测是否匹配指定选项组合。
	///
	/// - note:
	/// 如果提供的选项组合内某个选项的组ID没有在内部表中出现，当启用严格匹配时，匹配失败；否则，该选项被忽略。
	///
	/// - parameters:
	/// 	- optionSet: 选项组合。
	/// 	- strictly: 是否启用严格匹配。缺省为`false`。
	///
	/// - returns: 是否匹配。
	public func matches(_ optionSet: [Option], strictly: Bool = false) -> Bool {
		for option in optionSet {
			if let matchingOptionIds = innerMap[option.groupId] {
				if !matchingOptionIds.contains(option.id) {
					return false
				}
			}
			else {
				if strictly {
					return false
				}
			}
		}
		
		return true
	}
}

// MARK: -

/// 正则表达式，用于匹配形如"product: LayflatBook"或"size: [5X7 7X5]"的字符串。
///
/// 解析成功后，第一个捕获组分别为"product"或"size"，第二个捕获组分别为"LayflatBook"或"[5X7 7X5]"。
fileprivate let regex0 = try! NSRegularExpression(pattern: "([\\w]+)\\s*:\\s*(\\w+|(?:\\[[^\\]]+\\]))")

/// 正则表达式，用于匹配标识符。
fileprivate let regex1 = try! NSRegularExpression(pattern: "\\w+")

extension OptionSetRule {
	public init(string: String) {
		for capturedGroups in string.capturedGroupsInMatches(for: regex0) {
			let groupId = capturedGroups[1]
			let optionIds = capturedGroups[2].substrings(for: regex1)
			innerMap[groupId] = optionIds
		}
	}
}
