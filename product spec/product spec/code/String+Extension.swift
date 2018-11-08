import Foundation

extension String {
	internal var boolValue: Bool? {
		return Bool(self)
	}
	
	internal var intValue: Int? {
		return Int(self)
	}
	
	internal var doubleValue: Double? {
		return Double(self)
	}
	
	/// 返回所有匹配指定正则表达式的子字符串的数组。
	///
	/// - parameters:
	/// 	- regex: 正则表达式。其中定义的捕获组对于结果没有作用。
	///
	/// - returns: 子字符串组成的数组。
	internal func substrings(for regex: NSRegularExpression) -> [String] {
		let matches = regex.matches(in: self, range: NSRange(location: 0, length: count))
		let substrings: [String] = matches.map { result in
			let range = Range(result.range(at: 0), in: self)!
			let substring = String(self[range])
			
			return substring
		}
		
		return substrings
	}
	
	/// 返回匹配指定正则表达式后，每一次匹配的所有捕获组（包含序号为0的整体捕获组）对应的子字符串组成的二维数组。
	///
	/// - parameters:
	/// 	- regex: 正则表达式。
	///
	/// - returns: 子字符串组成的二维数组。
	internal func capturedGroupsInMatches(for regex: NSRegularExpression) -> [[String]] {
		let matches = regex.matches(in: self, range: NSRange(location: 0, length: count))
		let capturedGroupsInMatches: [[String]] = matches.map { result in
			var capturedGroups: [String] = []
			
			for i in 0 ..< result.numberOfRanges {
				let range = Range(result.range(at: i), in: self)!
				let capturedGroup = String(self[range])
				capturedGroups.append(capturedGroup)
			}
			
			return capturedGroups
		}
		
		return capturedGroupsInMatches
	}
}
