extension Dictionary {
    
    /// Returns an updated `Dictionary`containing the `value` associated to the `key`, if the value is not nil.
    /// If the key does not exist, then the value is inserted, otherwise the existing value associated with the key is replaced.
    /// - Parameters:
    ///   - key: The key to associate with `value`.
    ///   - value: The value to insert or replace.
    /// - Returns: A new `Dictionary`  containing the `value` associated to the `key`, if the value is not nil.
    func updating(key: Key, value: Value?) -> Self {
        
        guard let value = value else { return self }
        
        var result = self
        result[key] = value
        return result
    }
    
    /// Returns a new dictionary that has its keys transformed by the supplied closure.
    ///
    /// - Parameter transform: A closure that transforms the key to a different type.
    /// - Returns: A dictionary with transformed keys that correspond to the same values.
    func mapKeys<T>(_ transform: (Key) throws -> T) rethrows -> [T : Value] {
        
        return .init(uniqueKeysWithValues: try map { (key, value) in (try transform(key), value) })
    }
    
}
