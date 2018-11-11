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
				var spec: [String : String] = [:]
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
				var options: [Option] = []
				config.reactive.options.producer.startWithValues { options = $0 }
				
				expect(config.options) == []
				
				expect(options) == config.options
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover, sizeOption_8X8].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.options).to(contain([productOption_LayflatBook, coverOption_HardCover, sizeOption_8X8]))
				
				expect(options) == config.options
			}
			
			it("`option` should change according to `spec` and be observable") {
				var productOption: Option? = nil
				config.reactive.option(for: productGroup.id).producer.startWithValues { productOption = $0 }
				
				var coverOption: Option? = nil
				config.reactive.option(for: coverGroup.id).producer.startWithValues { coverOption = $0 }
				
				var sizeOption: Option? = nil
				config.reactive.option(for: sizeGroup.id).producer.startWithValues { sizeOption = $0 }
				
				expect(config.option(for: productGroup.id) == nil).to(beTrue())
				expect(config.option(for: coverGroup.id) == nil).to(beTrue())
				expect(config.option(for: sizeGroup.id) == nil).to(beTrue())
				
				expect(productOption == config.option(for: productGroup.id)).to(beTrue())
				expect(coverOption == config.option(for: coverGroup.id)).to(beTrue())
				expect(sizeOption == config.option(for: sizeGroup.id)).to(beTrue())
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover, sizeOption_8X8].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.option(for: productGroup.id)) == productOption_LayflatBook
				expect(config.option(for: coverGroup.id)) == coverOption_HardCover
				expect(config.option(for: sizeGroup.id)) == sizeOption_8X8
				
				expect(productOption == config.option(for: productGroup.id)).to(beTrue())
				expect(coverOption == config.option(for: coverGroup.id)).to(beTrue())
				expect(sizeOption == config.option(for: sizeGroup.id)).to(beTrue())
			}
			
			it("`availableOptions` should change according to `spec` and be observable") {
				var availableSizeOptions: [Option] = []
				config.reactive.availableOptions(for: sizeGroup.id).producer.startWithValues { availableSizeOptions = $0 }
				
				expect(config.availableOptions(for: sizeGroup.id)) == [
					sizeOption_6X6,
					sizeOption_8X8,
					sizeOption_12X12,
					sizeOption_7X5,
					sizeOption_5X7,
				]
				
				expect(availableSizeOptions) == config.availableOptions(for: sizeGroup.id)
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.availableOptions(for: sizeGroup.id)) == [
					sizeOption_6X6,
					sizeOption_8X8,
					sizeOption_12X12,
				]
				
				expect(availableSizeOptions) == config.availableOptions(for: sizeGroup.id)
			}
			
			it("`defaultOption` should change according to `spec` and be observable") {
				var defaultSizeOption: Option? = nil
				config.reactive.defaultOption(for: sizeGroup.id).producer.startWithValues { defaultSizeOption = $0 }
				
				expect(config.defaultOption(for: sizeGroup.id)) == sizeOption_6X6
				
				expect(defaultSizeOption).to(equal(config.defaultOption(for: sizeGroup.id)))
				
				config.spec = Dictionary(
					uniqueKeysWithValues: [productOption_LayflatBook, coverOption_HardCover].map { option in
						return (option.groupId, option.id)
					}
				)
				
				expect(config.defaultOption(for: sizeGroup.id)) == sizeOption_8X8
				
				expect(defaultSizeOption).to(equal(config.defaultOption(for: sizeGroup.id)))
			}
			
			// TODO: ...
		}
	}
}
