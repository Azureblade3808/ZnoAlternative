internal class WeakReference<Value : AnyObject> {
	private weak var _value: Value?
	
	internal init(_ value: Value) {
		self._value = value
	}
	
	public var value: Value? {
		return _value
	}
}
