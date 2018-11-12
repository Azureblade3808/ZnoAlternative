import ReactiveCocoa
import ReactiveSwift

import data
import product_spec

/// 产品的规格配置。
open class Config : Equatable, ReactiveExtensionsProvider {
	/// 参考的规格手册。
	public let manual: Manual
	
	/// 规格配置表的RAC可变属性。
	///
	/// 表键为选项组ID，表值为该组内已选的选项ID。
	public let specProperty = MutableProperty<[String : String]>([:])
	
	public init(manual: Manual) {
		self.manual = manual
	}
	
	/// 规格配置表。
	///
	/// 表键为选项组ID，表值为该组内已选的选项ID。
	public var spec: [String : String] {
		get { return specProperty.value }
		
		set { specProperty.value = newValue }
	}
	
	private weak var weakOptionsProperty: Property<[Option]>?
	
	/// 已选选项的数组的RAC属性。
	public var optionsProperty: Property<[Option]> {
		if let optionsProperty = weakOptionsProperty {
			return optionsProperty
		}
		else {
			let groups = manual.optionGroups
			
			let optionsProperty: Property<[Option]> = specProperty.map { spec in
				var options: [Option] = []
				
				for group in groups {
					let groupId = group.id
					
					if let optionId = spec[groupId], let option = group.option(for: optionId) {
						options.append(option)
					}
				}
				
				return options
			}
			weakOptionsProperty = optionsProperty
			
			return optionsProperty
		}
	}
	
	/// 已选选项的数组。
	public var options: [Option] {
		get { return optionsProperty.value }
		
		set { spec = Dictionary(uniqueKeysWithValues: newValue.map { ($0.groupId, $0.id) }) }
	}
	
	private var weakOptionPropertiesByGroupId: [String : WeakReference<Property<Option?>>] = [:]
	
	/// 返回指定选项组的已选选项的RAC属性。
	///
	/// - parameters:
	/// 	- groupId: 某个由`manual`提供的合法的选项组ID。
	///
	/// - returns: 对应的已选选项的RAC属性。
	public func optionProperty(for groupId: String) -> Property<Option?> {
		if let optionProperty = weakOptionPropertiesByGroupId[groupId]?.value {
			return optionProperty
		}
		else {
			let group = manual.optionGroup(for: groupId)!
			
			let optionProperty: Property<Option?> = specProperty.map { spec in
				if let optionId = spec[groupId], let option = group.option(for: optionId) {
					return option
				}
				else {
					return nil
				}
			}
			weakOptionPropertiesByGroupId[groupId] = WeakReference(optionProperty)
			
			return optionProperty
		}
	}
	
	/// 返回指定选项组的已选选项。
	///
	/// - parameters:
	/// 	- groupId: 某个由`manual`提供的合法的选项组ID。
	///
	/// - returns: 对应的已选选项。
	public func option(for groupId: String) -> Option? {
		return optionProperty(for: groupId).value
	}
	
	/// 为制定选项组设置已选选项。
	///
	/// - parameters:
	/// 	- option: 选项。
	/// 	- groupId: 选项组ID。
	public func setOption(_ option: Option?, for groupId: String) {
		precondition(option == nil || option!.groupId == groupId)
		
		spec[groupId] = option?.id
	}
	
	/// 启用指定选项，即将该选项设置为其选项组的已选选项。
	///
	/// - parameters:
	/// 	- option: 选项。
	public func adoptOption(_ option: Option) {
		spec[option.groupId] = option.id
	}
	
	private var weakAvailableOptionsPropertiesByGroupId: [String : WeakReference<Property<[Option]>>] = [:]
	
	/// 返回当前选项配置下，指定选项组的可用选项的数组的RAC属性。
	///
	/// - parameters:
	/// 	- groupId: 某个由`manual`提供的合法的选项组ID。
	///
	/// - returns: 对应的可用选项的数组的RAC属性。
	public func availableOptionsProperty(for groupId: String) -> Property<[Option]> {
		if let availableOptionsProperty = weakAvailableOptionsPropertiesByGroupId[groupId]?.value {
			return availableOptionsProperty
		}
		else {
			let group = manual.optionGroup(for: groupId)!
			
			let availableOptionsProperty = optionsProperty.map { options in
				return group.availableOptions(for: options)
			}
			weakAvailableOptionsPropertiesByGroupId[groupId] = WeakReference(availableOptionsProperty)
			
			return availableOptionsProperty
		}
	}
	
	/// 返回当前选项配置下，指定选项组的可用选项的数组。
	///
	/// - parameters:
	/// 	- groupId: 某个由`manual`提供的合法的选项组ID。
	///
	/// - returns: 对应的可用选项的数组。
	public func availableOptions(for groupId: String) -> [Option] {
		return availableOptionsProperty(for: groupId).value
	}
	
	private var weakDefaultOptionPropertiesByGroupId: [String : WeakReference<Property<Option?>>] = [:]
	
	/// 返回当前选项配置下，指定选项组的默认选项的RAC属性。
	///
	/// - parameters:
	/// 	- groupId: 某个由`manual`提供的合法的选项组ID。
	///
	/// - returns: 对应的默认选项的RAC属性。
	public func defaultOptionProperty(for groupId: String) -> Property<Option?> {
		if let defaultOptionProperty = weakDefaultOptionPropertiesByGroupId[groupId]?.value {
			return defaultOptionProperty
		}
		else {
			let group = manual.optionGroup(for: groupId)!
			
			let defaultOptionProperty = optionsProperty.map { options in
				return group.defaultOption(for: options)
			}
			weakDefaultOptionPropertiesByGroupId[groupId] = WeakReference(defaultOptionProperty)
			
			return defaultOptionProperty
		}
	}
	
	/// 返回当前选项配置下，指定选项组的默认选项。
	///
	/// - parameters:
	/// 	- groupId: 某个由`manual`提供的合法的选项组ID。
	///
	/// - returns: 对应的默认选项。
	public func defaultOption(for groupId: String) -> Option? {
		return defaultOptionProperty(for: groupId).value
	}
	
	private weak var weakConflictedOptionsProperty: Property<[Option]>?
	
	/// 已选选项中冲突选项的数组的RAC属性。
	public var conflictedOptionsProperty: Property<[Option]> {
		if let conflictedOptionsProperty = weakConflictedOptionsProperty {
			return conflictedOptionsProperty
		}
		else {
			let manual = self.manual
			
			let conflictedOptionsProperty = optionsProperty.map { optionSet in
				return optionSet.filter { option in
					let group = manual.optionGroup(for: option.groupId)!
					let availableOptions = group.availableOptions(for: optionSet)
					let isConflicted = !availableOptions.contains(option)
					
					return isConflicted
				}
			}
			weakConflictedOptionsProperty = conflictedOptionsProperty
			
			return conflictedOptionsProperty
		}
	}
	
	/// 已选选项中冲突选项的数组。
	public var conflictedOptions: [Option] {
		return conflictedOptionsProperty.value
	}
	
	private var weakBooleanValuePropertiesByMapId: [String : WeakReference<Property<Bool?>>] = [:]
	
	/// 返回指定ID的布尔型参数在当前选项配置下的值的RAC属性。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值的RAC属性。
	public func booleanValueProperty(for mapId: String) -> Property<Bool?> {
		if let booleanValueProperty = weakBooleanValuePropertiesByMapId[mapId]?.value {
			return booleanValueProperty
		}
		else {
			let manual = self.manual
			
			let booleanValueProperty = optionsProperty.map { options in
				return manual.booleanValue(for: (mapId, options))
			}
			weakBooleanValuePropertiesByMapId[mapId] = WeakReference(booleanValueProperty)
			
			return booleanValueProperty
		}
	}
	
	/// 返回指定ID的布尔型参数在当前选项配置下的值。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值。
	public func booleanValue(for mapId: String) -> Bool? {
		return booleanValueProperty(for: mapId).value
	}
	
	private var weakIntegerValuePropertiesByMapId: [String : WeakReference<Property<Int?>>] = [:]
	
	/// 返回指定ID的整数型参数在当前选项配置下的值的RAC属性。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值的RAC属性。
	public func integerValueProperty(for mapId: String) -> Property<Int?> {
		if let integerValueProperty = weakIntegerValuePropertiesByMapId[mapId]?.value {
			return integerValueProperty
		}
		else {
			let manual = self.manual
			
			let integerValueProperty = optionsProperty.map { options in
				return manual.integerValue(for: (mapId, options))
			}
			weakIntegerValuePropertiesByMapId[mapId] = WeakReference(integerValueProperty)
			
			return integerValueProperty
		}
	}
	
	/// 返回指定ID的整数型参数在当前选项配置下的值。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值。
	public func integerValue(for mapId: String) -> Int? {
		return integerValueProperty(for: mapId).value
	}
	
	private var weakFloatValuePropertiesByMapId: [String : WeakReference<Property<Double?>>] = [:]
	
	/// 返回指定ID的浮点数型参数在当前选项配置下的值的RAC属性。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值的RAC属性。
	public func floatValueProperty(for mapId: String) -> Property<Double?> {
		if let floatValueProperty = weakFloatValuePropertiesByMapId[mapId]?.value {
			return floatValueProperty
		}
		else {
			let manual = self.manual
			
			let floatValueProperty = optionsProperty.map { options in
				return manual.floatValue(for: (mapId, options))
			}
			weakFloatValuePropertiesByMapId[mapId] = WeakReference(floatValueProperty)
			
			return floatValueProperty
		}
	}
	
	/// 返回指定ID的浮点数型参数在当前选项配置下的值。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值。
	public func floatValue(for mapId: String) -> Double? {
		return floatValueProperty(for: mapId).value
	}
	
	private var weakStringValuePropertiesByMapId: [String : WeakReference<Property<String?>>] = [:]
	
	/// 返回指定ID的字符串型参数在当前选项配置下的值的RAC属性。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值的RAC属性。
	public func stringValueProperty(for mapId: String) -> Property<String?> {
		if let stringValueProperty = weakStringValuePropertiesByMapId[mapId]?.value {
			return stringValueProperty
		}
		else {
			let manual = self.manual
			
			let stringValueProperty = optionsProperty.map { options in
				return manual.stringValue(for: (mapId, options))
			}
			weakStringValuePropertiesByMapId[mapId] = WeakReference(stringValueProperty)
			
			return stringValueProperty
		}
	}
	
	/// 返回指定ID的字符串型参数在当前选项配置下的值。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值。
	public func stringValue(for mapId: String) -> String? {
		return stringValueProperty(for: mapId).value
	}
	
	private var weakSizeValuePropertiesByMapId: [String : WeakReference<Property<Offset?>>] = [:]
	
	/// 返回指定ID的尺寸型参数在当前选项配置下的值的RAC属性。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值的RAC属性。
	public func sizeValueProperty(for mapId: String) -> Property<Offset?> {
		if let sizeValueProperty = weakSizeValuePropertiesByMapId[mapId]?.value {
			return sizeValueProperty
		}
		else {
			let manual = self.manual
			
			let sizeValueProperty = optionsProperty.map { options in
				return manual.sizeValue(for: (mapId, options))
			}
			weakSizeValuePropertiesByMapId[mapId] = WeakReference(sizeValueProperty)
			
			return sizeValueProperty
		}
	}
	
	/// 返回指定ID的尺寸型参数在当前选项配置下的值。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值。
	public func sizeValue(for mapId: String) -> Offset? {
		return sizeValueProperty(for: mapId).value
	}
	
	private var weakPaddingValuePropertiesByMapId: [String : WeakReference<Property<Padding?>>] = [:]
	
	/// 返回指定ID的包边型参数在当前选项配置下的值的RAC属性。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值的RAC属性。
	public func paddingValueProperty(for mapId: String) -> Property<Padding?> {
		if let paddingValueProperty = weakPaddingValuePropertiesByMapId[mapId]?.value {
			return paddingValueProperty
		}
		else {
			let manual = self.manual
			
			let paddingValueProperty = optionsProperty.map { options in
				return manual.paddingValue(for: (mapId, options))
			}
			weakPaddingValuePropertiesByMapId[mapId] = WeakReference(paddingValueProperty)
			
			return paddingValueProperty
		}
	}
	
	/// 返回指定ID的包边型参数在当前选项配置下的值。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值。
	public func paddingValue(for mapId: String) -> Padding? {
		return paddingValueProperty(for: mapId).value
	}
	
	private var weakColorValuePropertiesByMapId: [String : WeakReference<Property<Color?>>] = [:]
	
	/// 返回指定ID的颜色型参数在当前选项配置下的值的RAC属性。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值的RAC属性。
	public func colorValueProperty(for mapId: String) -> Property<Color?> {
		if let colorValueProperty = weakColorValuePropertiesByMapId[mapId]?.value {
			return colorValueProperty
		}
		else {
			let manual = self.manual
			
			let colorValueProperty = optionsProperty.map { options in
				return manual.colorValue(for: (mapId, options))
			}
			weakColorValuePropertiesByMapId[mapId] = WeakReference(colorValueProperty)
			
			return colorValueProperty
		}
	}
	
	/// 返回指定ID的颜色型参数在当前选项配置下的值。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值。
	public func colorValue(for mapId: String) -> Color? {
		return colorValueProperty(for: mapId).value
	}
	
	private var weakImageValuePropertiesByMapId: [String : WeakReference<Property<Image?>>] = [:]
	
	/// 返回指定ID的图片型参数在当前选项配置下的值的RAC属性。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值的RAC属性。
	public func imageValueProperty(for mapId: String) -> Property<Image?> {
		if let imageValueProperty = weakImageValuePropertiesByMapId[mapId]?.value {
			return imageValueProperty
		}
		else {
			let manual = self.manual
			
			let imageValueProperty = optionsProperty.map { options in
				return manual.imageValue(for: (mapId, options))
			}
			weakImageValuePropertiesByMapId[mapId] = WeakReference(imageValueProperty)
			
			return imageValueProperty
		}
	}
	
	/// 返回指定ID的图片型参数在当前选项配置下的值。
	///
	/// - parameters:
	/// 	- mapId: 参数表ID。
	///
	/// - returns: 对应的值。
	public func imageValue(for mapId: String) -> Image? {
		return imageValueProperty(for: mapId).value
	}
	
	private weak var weakIsValidProperty: Property<Bool>?
	
	/// 是否合法的RAC属性。
	open var isValidProperty: Property<Bool> {
		if let isValidProperty = weakIsValidProperty {
			return isValidProperty
		}
		else {
			let isValidProperty = conflictedOptionsProperty.map { conflictedOptions in
				return conflictedOptions.isEmpty
			}
			weakIsValidProperty = isValidProperty
			
			return isValidProperty
		}
		
	}
	
	/// 是否合法。
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
		return base.optionProperty(for: groupId)
	}
	
	public func availableOptions(for groupId: String) -> Property<[Option]> {
		return base.availableOptionsProperty(for: groupId)
	}
	
	public func defaultOption(for groupId: String) -> Property<Option?> {
		return base.defaultOptionProperty(for: groupId)
	}
	
	public var conflictedOptions: Property<[Option]> {
		return base.conflictedOptionsProperty
	}
	
	public func booleanValue(for mapId: String) -> Property<Bool?> {
		return base.booleanValueProperty(for: mapId)
	}
	
	public func integerValue(for mapId: String) -> Property<Int?> {
		return base.integerValueProperty(for: mapId)
	}
	
	public func floatValue(for mapId: String) -> Property<Double?> {
		return base.floatValueProperty(for: mapId)
	}
	
	public func stringValue(for mapId: String) -> Property<String?> {
		return base.stringValueProperty(for: mapId)
	}
	
	public func sizeValue(for mapId: String) -> Property<Offset?> {
		return base.sizeValueProperty(for: mapId)
	}
	
	public func paddingValue(for mapId: String) -> Property<Padding?> {
		return base.paddingValueProperty(for: mapId)
	}
	
	public func colorValue(for mapId: String) -> Property<Color?> {
		return base.colorValueProperty(for: mapId)
	}
	
	public func imageValue(for mapId: String) -> Property<Image?> {
		return base.imageValueProperty(for: mapId)
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
