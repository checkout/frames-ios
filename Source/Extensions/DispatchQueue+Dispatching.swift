import Foundation

extension DispatchQueue: Dispatching {
    
    func async(_ block: @escaping () -> Void) {
        async(group: nil, execute: block)
    }
    
}
