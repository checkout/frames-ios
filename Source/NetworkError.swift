import Foundation

public enum NetworkError: Error, Decodable {
    
    case checkout(requestId: String, errorType: String, errorCodes: [String])
    case other(error: Error)
    case invalidData
    case invalidURL
    case unknown
    
    private enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case errorType = "error_type"
        case errorCodes = "error_codes"
    }
    
    public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        guard let requestId = try? values.decode(String.self, forKey: .requestId),
              let errorType = try? values.decode(String.self, forKey: .errorType),
              let errorCodes = try? values.decode([String].self, forKey: .errorCodes) else {

            self = .unknown
            return
        }

        self = .checkout(requestId: requestId, errorType: errorType, errorCodes: errorCodes)
    }
}
