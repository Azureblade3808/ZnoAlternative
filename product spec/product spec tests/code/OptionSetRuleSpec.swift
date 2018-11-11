import Nimble
import Quick

@testable
import product_spec

internal class OptionSetRuleSpec : QuickSpec {
	override
	internal func spec() {
		describe("`OptionSetRuleSpec`") {
			
			it("`matches(_:)` should work") {
				let rule = OptionSetRule(string: "product: LayflatBook cover: [HardCover Leatherette]")
				
				let productOption_LayflatBook = Option(id: "LayflatBook", groupId: "product")
				let coverOption_HardCover = Option(id: "HardCover", groupId: "cover")
				let coverOption_Leatherette = Option(id: "Leatherette", groupId: "cover")
				let sizeOption_8X8 = Option(id: "8X8", groupId: "size")
				
				expect(rule.matches([])).to(beFalse())
				expect(rule.matches([productOption_LayflatBook])).to(beFalse())
				expect(rule.matches([productOption_LayflatBook, coverOption_HardCover])).to(beTrue())
				expect(rule.matches([productOption_LayflatBook, coverOption_Leatherette])).to(beTrue())
				expect(rule.matches([productOption_LayflatBook, coverOption_HardCover, sizeOption_8X8])).to(beTrue())
			}
		}
	}
}

// MARK: -

extension Option {
	fileprivate convenience init(id: String, groupId: String) {
		self.init()
		
		self.id = id
		self.groupId = groupId
	}
}
