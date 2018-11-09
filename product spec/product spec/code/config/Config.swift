import ReactiveCocoa
import ReactiveSwift

/// 产品的规格配置。
open class Config {
	/// 参考的规格手册。
	public let manual: Manual
	
	public let specProperty: MutableProperty<[String : String]>
	
	public let optionsProperty: Property<[Option]>
	
	public let optionPropertiesByGroupId: [String : Property<Option?>]
	
	public let availableOptionsPropertiesByGroupId: [String : Property<[Option]>]
	
	public let defaultOptionPropertiesByGroupId: [String : Property<Option?>]
	
	public init(manual: Manual) {
		self.manual = manual
		
		specProperty = MutableProperty<[String : String]>([:])
		
		optionsProperty = specProperty.map { spec in
			var options: [Option] = []
			
			spec.forEach { groupId, optionId in
				if let option = manual.optionGroup(for: groupId)?.option(for: optionId) {
					options.append(option)
				}
			}
			
			return options
		}
		
		var optionPropertiesByGroupId: [String : Property<Option?>] = [:]
		var availableOptionsPropertiesByGroupId: [String : Property<[Option]>] = [:]
		var defaultOptionPropertiesByGroupId: [String : Property<Option?>] = [:]
		
		let groupIds = manual.optionGroupIds
		for groupId in groupIds {
			let group = manual.optionGroup(for: groupId)!
			
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
	
	/// 只读入口。
	public var readonly: Readonly {
		return Readonly(base: self)
	}
	
	/// 读写入口。
	public var readwrite: Readwrite {
		return Readwrite(base: self)
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
			return base.specProperty.value
		}
		
		public var options: [Option] {
			return base.optionsProperty.value
		}
		
		public func option(for groupId: String) -> Option? {
			return base.optionPropertiesByGroupId[groupId]!.value
		}
		
		public func availableOptions(for groupId: String) -> [Option] {
			return base.availableOptionsPropertiesByGroupId[groupId]!.value
		}
		
		public func defaultOption(for groupId: String) -> Option? {
			return base.defaultOptionPropertiesByGroupId[groupId]!.value
		}
	}
}

// MARK: -

extension Reactive where Base : Config.Readonly {
	public var spec: Property<[String : String]> {
		return Property(capturing: base.base.specProperty)
	}
	
	public var options: Property<[Option]> {
		return Property(capturing: base.base.optionsProperty)
	}
	
	public func option(for groupId: String) -> Property<Option?> {
		return base.base.optionPropertiesByGroupId[groupId]!
	}
	
	public func availableOptions(for groupId: String) -> Property<[Option]> {
		return base.base.availableOptionsPropertiesByGroupId[groupId]!
	}
	
	public func defaultOption(for groupId: String) -> Property<Option?> {
		return base.base.defaultOptionPropertiesByGroupId[groupId]!
	}
}

// MARK: -

extension Config {
	open class Readwrite : Readonly {
		override
		public var spec: [String : String] {
			get { return super.spec }
			
			set { base.specProperty.value = newValue }
		}
	}
}

// MARK: -

extension Reactive where Base : Config.Readwrite {
	public var spec: MutableProperty<[String : String]> {
		return base.base.specProperty
	}
}
