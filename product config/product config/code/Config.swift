import ReactiveCocoa
import ReactiveSwift

import data
import product_spec

/// 产品的规格配置。
open class Config : Equatable, ReactiveExtensionsProvider {
	/// 参考的规格手册。
	public let manual: Manual
	
	/// 【RAC可变属性】规格配置表。
	///
	/// 表键为选项组ID，表值为该组内已选的选项ID。
	public let specProperty = MutableProperty<[String : String]>([:])
	
	/// 【RAC属性】已选选项的数组。
	public let optionsProperty: Property<[Option]>
	
	/// 表键为选项组ID，表值为【RAC属性】该选项组内已选的选项。
	public let optionPropertiesByGroupId: [String : Property<Option?>]
	
	/// 表键为选项组ID，表值为【RAC属性】该选项组内可用选项数组。
	public let availableOptionsPropertiesByGroupId: [String : Property<[Option]>]
	
	/// 表键为选项组ID，表值为【RAC属性】该选项组内默认选项。
	public let defaultOptionPropertiesByGroupId: [String : Property<Option?>]
	
	/// 【RAC属性】已选选项中冲突选项数组。
	public let conflictedOptionsProperty: Property<[Option]>
	
	/// 表键为布尔型参数表ID，表值为【RAC属性】该参数表内参数值。
	public let booleanValuePropertiesByMapId: [String : Property<Bool?>]
	
	/// 表键为整型参数表ID，表值为【RAC属性】该参数表内参数值。
	public let integerValuePropertiesByMapId: [String : Property<Int?>]
	
	/// 表键为浮点型参数表ID，表值为【RAC属性】该参数表内参数值。
	public let floatValuePropertiesByMapId: [String : Property<Double?>]
	
	/// 表键为字符串型参数表ID，表值为【RAC属性】该参数表内参数值。
	public let stringValuePropertiesByMapId: [String : Property<String?>]
	
	/// 表键为尺寸型参数表ID，表值为【RAC属性】该参数表内参数值。
	public let sizeValuePropertiesByMapId: [String : Property<Offset?>]
	
	/// 表键为包边型参数表ID，表值为【RAC属性】该参数表内参数值。
	public let paddingValuePropertiesByMapId: [String : Property<Padding?>]
	
	/// 表键为颜色型参数表ID，表值为【RAC属性】该参数表内参数值。
	public let colorValuePropertiesByMapId: [String : Property<Color?>]
	
	/// 表键为图片型参数表ID，表值为【RAC属性】该参数表内参数值。
	public let imageValuePropertiesByMapId: [String : Property<Image?>]
	
	/// 是否合法的RAC属性。
	///
	/// - note: 在此仅判断是否不存在冲突选项，子类可通过公开覆盖`isValidProperty`属性来增加其余条件。
	private let _isValidProperty: Property<Bool>
	
	public init(manual: Manual) {
		self.manual = manual
		
		optionsProperty = specProperty.map { spec in
			var options: [Option] = []
			
			for group in manual.optionGroups {
				let groupId = group.id
				
				if let optionId = spec[groupId], let option = group.option(for: optionId) {
					options.append(option)
				}
			}
			
			return options
		}
		
		if true {
			var optionPropertiesByGroupId: [String : Property<Option?>] = [:]
			var availableOptionsPropertiesByGroupId: [String : Property<[Option]>] = [:]
			var defaultOptionPropertiesByGroupId: [String : Property<Option?>] = [:]
			
			for group in manual.optionGroups {
				let groupId = group.id
				
				optionPropertiesByGroupId[groupId] = specProperty.map { spec in
					if let optionId = spec[groupId], let option = group.option(for: optionId) {
						return option
					}
					else {
						return nil
					}
				}
				
				availableOptionsPropertiesByGroupId[groupId] = optionsProperty.map { options in
					return group.availableOptions(for: options)
				}
				
				defaultOptionPropertiesByGroupId[groupId] = optionsProperty.map { options in
					return group.defaultOption(for: options)
				}
			}
			
			self.optionPropertiesByGroupId = optionPropertiesByGroupId
			self.availableOptionsPropertiesByGroupId = availableOptionsPropertiesByGroupId
			self.defaultOptionPropertiesByGroupId = defaultOptionPropertiesByGroupId
		}
		else { fatalError() }
		
		conflictedOptionsProperty = optionsProperty.map { options in
			return options.filter { option in
				let group = manual.optionGroup(for: option.groupId)!
				let availableOptions = group.availableOptions(for: options)
				let isConflicted = !availableOptions.contains(option)
				
				return isConflicted
			}
		}
		
		if true {
			var booleanValuePropertiesByMapId: [String : Property<Bool?>] = [:]
			
			for mapId in manual.booleanMapIds {
				booleanValuePropertiesByMapId[mapId] = optionsProperty.map { options in
					return manual.booleanValue(for: (mapId, options))
				}
			}
			
			self.booleanValuePropertiesByMapId = booleanValuePropertiesByMapId
		}
		else { fatalError() }
		
		if true {
			var integerValuePropertiesByMapId: [String : Property<Int?>] = [:]
			
			for mapId in manual.integerMapIds {
				integerValuePropertiesByMapId[mapId] = optionsProperty.map { options in
					return manual.integerValue(for: (mapId, options))
				}
			}
			
			self.integerValuePropertiesByMapId = integerValuePropertiesByMapId
		}
		else { fatalError() }
		
		if true {
			var floatValuePropertiesByMapId: [String : Property<Double?>] = [:]
			
			for mapId in manual.floatMapIds {
				floatValuePropertiesByMapId[mapId] = optionsProperty.map { options in
					return manual.floatValue(for: (mapId, options))
				}
			}
			
			self.floatValuePropertiesByMapId = floatValuePropertiesByMapId
		}
		else { fatalError() }
		
		if true {
			var stringValuePropertiesByMapId: [String : Property<String?>] = [:]
			
			for mapId in manual.booleanMapIds {
				stringValuePropertiesByMapId[mapId] = optionsProperty.map { options in
					return manual.stringValue(for: (mapId, options))
				}
			}
			
			self.stringValuePropertiesByMapId = stringValuePropertiesByMapId
		}
		else { fatalError() }
		
		if true {
			var sizeValuePropertiesByMapId: [String : Property<Offset?>] = [:]
			
			for mapId in manual.sizeMapIds {
				sizeValuePropertiesByMapId[mapId] = optionsProperty.map { options in
					return manual.sizeValue(for: (mapId, options))
				}
			}
			
			self.sizeValuePropertiesByMapId = sizeValuePropertiesByMapId
		}
		else { fatalError() }
		
		if true {
			var paddingValuePropertiesByMapId: [String : Property<Padding?>] = [:]
			
			for mapId in manual.paddingMapIds {
				paddingValuePropertiesByMapId[mapId] = optionsProperty.map { options in
					return manual.paddingValue(for: (mapId, options))
				}
			}
			
			self.paddingValuePropertiesByMapId = paddingValuePropertiesByMapId
		}
		else { fatalError() }
		
		if true {
			var colorValuePropertiesByMapId: [String : Property<Color?>] = [:]
			
			for mapId in manual.colorMapIds {
				colorValuePropertiesByMapId[mapId] = optionsProperty.map { options in
					return manual.colorValue(for: (mapId, options))
				}
			}
			
			self.colorValuePropertiesByMapId = colorValuePropertiesByMapId
		}
		else { fatalError() }
		
		if true {
			var imageValuePropertiesByMapId: [String : Property<Image?>] = [:]
			
			for mapId in manual.imageMapIds {
				imageValuePropertiesByMapId[mapId] = optionsProperty.map { options in
					return manual.imageValue(for: (mapId, options))
				}
			}
			
			self.imageValuePropertiesByMapId = imageValuePropertiesByMapId
		}
		else { fatalError() }
		
		_isValidProperty = conflictedOptionsProperty.map { conflictedOptions in
			return !conflictedOptions.isEmpty
		}
	}
	
	/// 【RAC属性】是否合法。
	open var isValidProperty: Property<Bool> {
		return _isValidProperty
	}
	
	public var spec: [String : String] {
		get { return specProperty.value }
		
		set { specProperty.value = newValue }
	}
	
	public var options: [Option] {
		get { return optionsProperty.value }
		
		set { spec = Dictionary(uniqueKeysWithValues: options.map { ($0.groupId, $0.id) }) }
	}
	
	public func option(for groupId: String) -> Option? {
		return optionPropertiesByGroupId[groupId]!.value
	}
	
	public func setOption(_ option: Option?, for groupId: String) {
		precondition(option == nil || option!.groupId == groupId)
		
		spec[groupId] = option?.id
	}
	
	public func adoptOption(_ option: Option) {
		spec[option.groupId] = option.id
	}
	
	public func availableOptions(for groupId: String) -> [Option] {
		return availableOptionsPropertiesByGroupId[groupId]!.value
	}
	
	public func defaultOption(for groupId: String) -> Option? {
		return defaultOptionPropertiesByGroupId[groupId]!.value
	}
	
	public var conflictedOptions: [Option] {
		return conflictedOptionsProperty.value
	}
	
	public func booleanValue(for mapId: String) -> Bool? {
		return booleanValuePropertiesByMapId[mapId]!.value
	}
	
	public func integerValue(for mapId: String) -> Int? {
		return integerValuePropertiesByMapId[mapId]!.value
	}
	
	public func floatValue(for mapId: String) -> Double? {
		return floatValuePropertiesByMapId[mapId]!.value
	}
	
	public func stringValue(for mapId: String) -> String? {
		return stringValuePropertiesByMapId[mapId]!.value
	}
	
	public func sizeValue(for mapId: String) -> Offset? {
		return sizeValuePropertiesByMapId[mapId]!.value
	}
	
	public func paddingValue(for mapId: String) -> Padding? {
		return paddingValuePropertiesByMapId[mapId]!.value
	}
	
	public func colorValue(for mapId: String) -> Color? {
		return colorValuePropertiesByMapId[mapId]!.value
	}
	
	public func imageValue(for mapId: String) -> Image? {
		return imageValuePropertiesByMapId[mapId]!.value
	}
	
	public var isValid: Bool {
		return isValidProperty.value
	}
	
	/// 只读入口。
	open var readonly: Readonly {
		return Readonly(base: self)
	}
	
	/// 读写入口。
	open var readwrite: Readwrite {
		return Readwrite(base: self)
	}
	
	// MARK: Conform - Equatable
	
	public static func ==(a: Config, b: Config) -> Bool {
		guard type(of: a) == type(of: b) else { return false }
		
		guard a.manual === b.manual else { return false }
		guard a.specProperty.value == b.specProperty.value else { return false }
		
		return true
	}
}

// MARK: -

extension Reactive where Base : Config {
	public var spec: MutableProperty<[String : String]> {
		return base.specProperty
	}
	
	public var options: Property<[Option]> {
		return base.optionsProperty
	}
	
	public func option(for groupId: String) -> Property<Option?> {
		return base.optionPropertiesByGroupId[groupId]!
	}
	
	public func availableOptions(for groupId: String) -> Property<[Option]> {
		return base.availableOptionsPropertiesByGroupId[groupId]!
	}
	
	public func defaultOption(for groupId: String) -> Property<Option?> {
		return base.defaultOptionPropertiesByGroupId[groupId]!
	}
	
	public var conflictedOptions: Property<[Option]> {
		return base.conflictedOptionsProperty
	}
	
	public func booleanValue(for mapId: String) -> Property<Bool?> {
		return base.booleanValuePropertiesByMapId[mapId]!
	}
	
	public func integerValue(for mapId: String) -> Property<Int?> {
		return base.integerValuePropertiesByMapId[mapId]!
	}
	
	public func floatValue(for mapId: String) -> Property<Double?> {
		return base.floatValuePropertiesByMapId[mapId]!
	}
	
	public func stringValue(for mapId: String) -> Property<String?> {
		return base.stringValuePropertiesByMapId[mapId]!
	}
	
	public func sizeValue(for mapId: String) -> Property<Offset?> {
		return base.sizeValuePropertiesByMapId[mapId]!
	}
	
	public func paddingValue(for mapId: String) -> Property<Padding?> {
		return base.paddingValuePropertiesByMapId[mapId]!
	}
	
	public func colorValue(for mapId: String) -> Property<Color?> {
		return base.colorValuePropertiesByMapId[mapId]!
	}
	
	public func imageValue(for mapId: String) -> Property<Image?> {
		return base.imageValuePropertiesByMapId[mapId]!
	}
	
	public var isValid: Property<Bool> {
		return base.isValidProperty
	}
}

// MARK: -

extension Config {
	open class Readonly : ReactiveExtensionsProvider {
		fileprivate let base: Config
		
		public init(base: Config) {
			self.base = base
		}
		
		public var manual: Manual {
			return base.manual
		}
		
		public var spec: [String : String] {
			return base.spec
		}
		
		public var options: [Option] {
			return base.options
		}
		
		public func option(for groupId: String) -> Option? {
			return base.option(for: groupId)
		}
		
		public func availableOptions(for groupId: String) -> [Option] {
			return base.availableOptions(for: groupId)
		}
		
		public func defaultOption(for groupId: String) -> Option? {
			return base.defaultOption(for: groupId)
		}
		
		public var conflictedOptions: [Option] {
			return base.conflictedOptions
		}
		
		public func booleanValue(for mapId: String) -> Bool? {
			return base.booleanValue(for: mapId)
		}
		
		public func integerValue(for mapId: String) -> Int? {
			return base.integerValue(for: mapId)
		}
		
		public func floatValue(for mapId: String) -> Double? {
			return base.floatValue(for: mapId)
		}
		
		public func stringValue(for mapId: String) -> String? {
			return base.stringValue(for: mapId)
		}
		
		public func sizeValue(for mapId: String) -> Offset? {
			return base.sizeValue(for: mapId)
		}
		
		public func paddingValue(for mapId: String) -> Padding? {
			return base.paddingValue(for: mapId)
		}
		
		public func colorValue(for mapId: String) -> Color? {
			return base.colorValue(for: mapId)
		}
		
		public func imageValue(for mapId: String) -> Image? {
			return base.imageValue(for: mapId)
		}
		
		public var isValid: Bool {
			return base.isValid
		}
	}
}

// MARK: -

extension Reactive where Base : Config.Readonly {
	public var spec: Property<[String : String]> {
		return Property(capturing: base.base.reactive.spec)
	}
	
	public var options: Property<[Option]> {
		return base.base.reactive.options
	}
	
	public func option(for groupId: String) -> Property<Option?> {
		return base.base.reactive.option(for: groupId)
	}
	
	public func availableOptions(for groupId: String) -> Property<[Option]> {
		return base.base.reactive.availableOptions(for: groupId)
	}
	
	public func defaultOption(for groupId: String) -> Property<Option?> {
		return base.base.reactive.defaultOption(for: groupId)
	}
	
	public var conflictedOptions: Property<[Option]> {
		return base.base.reactive.conflictedOptions
	}
	
	public func booleanValue(for mapId: String) -> Property<Bool?> {
		return base.base.reactive.booleanValue(for: mapId)
	}
	
	public func integerValue(for mapId: String) -> Property<Int?> {
		return base.base.reactive.integerValue(for: mapId)
	}
	
	public func floatValue(for mapId: String) -> Property<Double?> {
		return base.base.reactive.floatValue(for: mapId)
	}
	
	public func stringValue(for mapId: String) -> Property<String?> {
		return base.base.reactive.stringValue(for: mapId)
	}
	
	public func sizeValue(for mapId: String) -> Property<Offset?> {
		return base.base.reactive.sizeValue(for: mapId)
	}
	
	public func paddingValue(for mapId: String) -> Property<Padding?> {
		return base.base.reactive.paddingValue(for: mapId)
	}
	
	public func colorValue(for mapId: String) -> Property<Color?> {
		return base.base.reactive.colorValue(for: mapId)
	}
	
	public func imageValue(for mapId: String) -> Property<Image?> {
		return base.base.reactive.imageValue(for: mapId)
	}
	
	public var isValid: Property<Bool> {
		return base.base.reactive.isValid
	}
}

// MARK: -

extension Config {
	open class Readwrite : Readonly {
		override
		public var spec: [String : String] {
			get { return super.spec }
			
			set { base.spec = newValue }
		}
		
		override
		public var options: [Option] {
			get { return super.options }
			
			set { base.options = newValue }
		}
		
		public func setOption(_ option: Option?, for groupId: String) {
			base.setOption(option, for: groupId)
		}
		
		public func adoptOption(_ option: Option) {
			base.adoptOption(option)
		}
	}
}

// MARK: -

extension Reactive where Base : Config.Readwrite {
	public var spec: MutableProperty<[String : String]> {
		return base.base.specProperty
	}
}
