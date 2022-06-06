@testable import Frames

final class StubDispatcher: Dispatching {
    
    private(set) var asyncCalledWithBlock: (() -> Void)?
    
    func async(_ block: @escaping () -> Void) {
        
        asyncCalledWithBlock = block
    }
    
}
