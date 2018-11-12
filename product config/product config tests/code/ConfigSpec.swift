import Nimble
import Quick

import product_spec
import product_config

internal class ConfigSpec : QuickSpec {
	override
	internal func spec() {
		let manual = Manual(named: "sample_spec", in: Bundle(for: ConfigSpec.self))
		
		let productGroup = manual.optionGroup(for: "product")!
		let productOption_LayflatBook = productGroup.option(for: "LayflatBook")!
		let productOption_PressBook = productGroup.option(for: "PressBook")!
		
		let coverGroup = manual.optionGroup(for: "cover")!
		let coverOption_HardCover = coverGroup.option(for: "HardCover")!
		
		let sizeGroup = manual.optionGroup(for: "size")!
		let sizeOption_6X6 = sizeGroup.option(for: "6X6")!
		let sizeOption_8X8 = sizeGroup.option(for: "8X8")!
		let sizeOption_12X12 = sizeGroup.option(for: "12X12")!
		let sizeOption_5X7 = sizeGroup.option(for: "5X7")!
		let sizeOption_7X5 = sizeGroup.option(for: "7X5")!
		
		describe("`Config`") {
			var config: Config!
			
			beforeEach {
				config = Config(manual: manual)
			}
			
			afterEach {
				expect(config.readonly.spec) == config.spec
				expect(config.readwrite.spec) == config.spec
			}
			
			it("`spec` should be observable") {
				var spec: [String : String]? = nil
				config.reactive.spec.producer.startWithValues { spec = $0 }
				
				expect(spec) == [:]
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover, sizeOption_8X8].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(spec) == Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover, sizeOption_8X8].map { option in
						return (option.groupId, option.id)
					}
				)
			}
			
			it("`options` should change according to `spec` and be observable") {
				var options: [Option]? = nil
				config.reactive.options.producer.startWithValues { options = $0 }
				
				expect(config.options) == []
				expect(options) == []
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover, sizeOption_8X8].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.options).to(contain([productOption_LayflatBook, coverOption_HardCover, sizeOption_8X8]))
				expect(options).to(contain([productOption_LayflatBook, coverOption_HardCover, sizeOption_8X8]))
			}
			
			it("`option` should change according to `spec` and be observable") {
				var productOption: Option? = nil
				config.reactive.option(for: productGroup.id).producer.startWithValues { productOption = $0 }
				
				var coverOption: Option? = nil
				config.reactive.option(for: coverGroup.id).producer.startWithValues { coverOption = $0 }
				
				var sizeOption: Option? = nil
				config.reactive.option(for: sizeGroup.id).producer.startWithValues { sizeOption = $0 }
				
				expect(config.option(for: productGroup.id)).to(beNil())
				expect(productOption).to(beNil())
				
				expect(config.option(for: coverGroup.id)).to(beNil())
				expect(coverOption).to(beNil())
				
				expect(config.option(for: sizeGroup.id)).to(beNil())
				expect(sizeOption).to(beNil())
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover, sizeOption_8X8].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.option(for: productGroup.id)) == productOption_LayflatBook
				expect(productOption) == productOption_LayflatBook
				
				expect(config.option(for: coverGroup.id)) == coverOption_HardCover
				expect(coverOption) == coverOption_HardCover
				
				expect(config.option(for: sizeGroup.id)) == sizeOption_8X8
				expect(sizeOption) == sizeOption_8X8
			}
			
			it("`availableOptions` should change according to `spec` and be observable") {
				var availableSizeOptions: [Option]? = nil
				config.reactive.availableOptions(for: sizeGroup.id).producer.startWithValues { availableSizeOptions = $0 }
				
				expect(config.availableOptions(for: sizeGroup.id)) == [sizeOption_6X6, sizeOption_8X8, sizeOption_12X12, sizeOption_7X5, sizeOption_5X7]
				expect(availableSizeOptions) == [sizeOption_6X6, sizeOption_8X8, sizeOption_12X12, sizeOption_7X5, sizeOption_5X7]
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.availableOptions(for: sizeGroup.id)) == [sizeOption_6X6, sizeOption_8X8, sizeOption_12X12]
				expect(availableSizeOptions) == [sizeOption_6X6, sizeOption_8X8, sizeOption_12X12]
			}
			
			it("`defaultOption` should change according to `spec` and be observable") {
				var defaultSizeOption: Option? = nil
				config.reactive.defaultOption(for: sizeGroup.id).producer.startWithValues { defaultSizeOption = $0 }
				
				expect(config.defaultOption(for: sizeGroup.id)) == sizeOption_6X6
				expect(defaultSizeOption) == sizeOption_6X6
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.defaultOption(for: sizeGroup.id)) == sizeOption_8X8
				expect(defaultSizeOption) == sizeOption_8X8
			}
			
			it("`conflictedOptions` should change according to `spec` and be observable") {
				var conflictedOptions: [Option]? = nil
				config.reactive.conflictedOptions.producer.startWithValues { conflictedOptions = $0 }
				
				expect(config.conflictedOptions) == []
				expect(conflictedOptions) == []
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover, sizeOption_7X5].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.conflictedOptions) == [sizeOption_7X5]
				expect(conflictedOptions) == [sizeOption_7X5]
			}
			
			it("`booleanValue` should change according to `spec` and be observable") {
				var isPressBook: Bool? = nil
				config.reactive.booleanValue(for: "isPressBook").producer.startWithValues { isPressBook = $0 }
				
				expect(config.booleanValue(for: "isPressBook")) == false
				expect(isPressBook) == false
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_PressBook].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.booleanValue(for: "isPressBook")) == true
				expect(isPressBook) == true
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.booleanValue(for: "isPressBook")) == false
				expect(isPressBook) == false
			}
			
			it("`integerValue` should change according to `spec` and be observable") {
				var minimalNumberOfSpreads: Int? = nil
				config.reactive.integerValue(for: "minimalNumberOfSpreads").producer.startWithValues { minimalNumberOfSpreads = $0 }
				
				expect(config.integerValue(for: "minimalNumberOfSpreads")) == 10
				expect(minimalNumberOfSpreads) == 10
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_PressBook].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.integerValue(for: "minimalNumberOfSpreads")) == 15
				expect(minimalNumberOfSpreads) == 15
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.integerValue(for: "minimalNumberOfSpreads")) == 10
				expect(minimalNumberOfSpreads) == 10
			}
			
			it("`stringValue` should change according to `spec` and be observable") {
				var orientation: String? = nil
				config.reactive.stringValue(for: "orientation").producer.startWithValues { orientation = $0 }
				
				expect(config.stringValue(for: "orientation")).to(beNil())
				expect(orientation).to(beNil())
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [sizeOption_6X6].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.stringValue(for: "orientation")) == "Square"
				expect(orientation) == "Square"
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [sizeOption_7X5].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.stringValue(for: "orientation")) == "Landscape"
				expect(orientation) == "Landscape"
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [sizeOption_5X7].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.stringValue(for: "orientation")) == "Portrait"
				expect(orientation) == "Portrait"
			}
			
			it("`isValid` should change according to `spec` and be observable") {
				var isValid: Bool? = nil
				config.reactive.isValid.producer.startWithValues { isValid = $0 }
				
				expect(config.isValid) == true
				expect(isValid) == true
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover, sizeOption_7X5].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.isValid) == false
				expect(isValid) == false
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover, sizeOption_6X6].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.isValid) == true
				expect(isValid) == true
			}
		}
	}
}
