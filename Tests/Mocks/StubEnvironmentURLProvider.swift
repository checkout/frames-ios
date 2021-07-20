import Foundation

@testable import Frames

final class StubEnvironmentURLProvider: EnvironmentURLProviding {
    
    var classicURLReturnValue: URL!
    var unifiedPaymentsURLReturnValue: URL!
    
    var classicURL: URL { return classicURLReturnValue }
    var unifiedPaymentsURL: URL { return unifiedPaymentsURLReturnValue }
    
}
