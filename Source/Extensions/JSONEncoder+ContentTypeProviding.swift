import Foundation

extension JSONEncoder: ContentTypeProviding {
    
    var contentType: String { return "application/json" }
    
}
