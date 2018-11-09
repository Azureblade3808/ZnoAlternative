/// 以选项组合规则为键的表，用于测试匹配指定的选项组合。
public struct OptionSetMap<Value> {
	/// 表项的数组。
	public var entries: [(key: OptionSetRule, value: Value?)] = []
}

// MARK: -

extension OptionSetMap {
	/// 获取指定选项组合对应的值。
	///
	/// - paramters:
	/// 	- optionSet: 选项组合。
	///
	/// - returns: 对应的值，或`nil`。
	public func value(for optionSet: [Option]) -> Value? {
		for (key, value) in entries {
			if key.matches(optionSet) {
				return value
			}
		}
		
		return nil
	}
	
	public subscript(optionSet: [Option]) -> Value? {
		return value(for: optionSet)
	}
}
