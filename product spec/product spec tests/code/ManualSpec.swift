import Nimble
import Quick

import product_spec

internal class ManualSpec : QuickSpec {
	override
	internal func spec() {
		describe("`Manual`") {
			let manual = Manual(named: "sample_spec", in: Bundle(for: ManualSpec.self))
			
			let productGroup = manual.optionGroup(for: "product")!
			let productOption_LayflatBook = productGroup.option(for: "LayflatBook")!
			let productOption_PressBook = productGroup.option(for: "PressBook")!
			
			let coverGroup = manual.optionGroup(for: "cover")!
			let coverOption_HardCover = coverGroup.option(for: "HardCover")!
			let coverOption_SoftCover = coverGroup.option(for: "SoftCover")!
			let coverOption_PaperCover = coverGroup.option(for: "PaperCover")!
			let coverOption_Leatherette = coverGroup.option(for: "Leatherette")!
			
			let sizeGroup = manual.optionGroup(for: "size")!
			let sizeOption_5X7 = sizeGroup.option(for: "5X7")!
			let sizeOption_12X12 = sizeGroup.option(for: "12X12")!
			
			it("`version` is '1.0'") {
				expect(manual.version) == "1.0"
			}
			
			it("'size' group has 5 options") {
				expect(sizeGroup.options.count) == 5
			}
			
			it("'5X7' is available for 'LayflatBook PaperCover'") {
				expect(sizeGroup.availableOptions(for: [productOption_LayflatBook, coverOption_PaperCover])).to(contain(sizeOption_5X7))
			}

			it("'5X7' is NOT available for 'LayflatBook HardCover'") {
				expect(sizeGroup.availableOptions(for: [productOption_LayflatBook, coverOption_HardCover])).toNot(contain(sizeOption_5X7))
			}
			
			it("`12X12` is available for 'PressBook Leatherette'") {
				expect(sizeGroup.availableOptions(for: [productOption_PressBook, coverOption_Leatherette])).to(contain(sizeOption_12X12))
			}

			it("`12X12` is NOT available for 'PressBook SoftCover'") {
				expect(sizeGroup.availableOptions(for: [productOption_PressBook, coverOption_SoftCover])).toNot(contain(sizeOption_12X12))
			}
			
			it("'orientation' is 'Portrait' for '5X7'") {
				expect(manual.stringValue(for: ("orientation", [sizeOption_5X7]))) == "Portrait"
			}
			
			it("'orientation' is 'Square' for '12X12'") {
				expect(manual.stringValue(for: ("orientation", [sizeOption_12X12]))) == "Square"
			}
		}
	}
}
