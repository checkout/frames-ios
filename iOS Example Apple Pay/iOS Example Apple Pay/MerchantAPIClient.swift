import Foundation
import FramesIos
import Alamofire

class MerchantAPIClient {
    
    let baseUrl = "https://just-a-test-2.herokuapp.com/"
    let headers = [
        "Content-Type": "application/json"
    ]
    
    func get(customer: String, successHandler: @escaping (Customer) -> Void) {
        let endpoint = "customers/\(customer)"
        request("\(baseUrl)\(endpoint)").validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let data = String(data: jsonData, encoding: .utf8)?.data(using: .utf8)
                    let decoder = JSONDecoder()
                    let customerResponse = try decoder.decode(Customer.self, from: data!)
                    successHandler(customerResponse)
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func save(cardWith cardToken: String, for customer: String, isId: Bool = false,
              successHandler: @escaping () -> Void) {
        let endpoint = "cards/verify"
        let url = "\(baseUrl)\(endpoint)"
        // swiftlint:disable:next force_try
        var urlRequest = try! URLRequest(url: URL(string: url)!, method: HTTPMethod.post, headers: headers)
        if isId {
            urlRequest.httpBody = "{ \"cardToken\": \"\(cardToken)\", \"customerId\": \"\(customer)\" }"
                .data(using: .utf8)
        } else {
            urlRequest.httpBody = "{ \"cardToken\": \"\(cardToken)\", \"customerEmail\": \"\(customer)\" }"
                .data(using: .utf8)
        }
        request(urlRequest).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
//                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    successHandler()
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

