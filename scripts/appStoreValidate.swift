import Combine
import Foundation

struct AppleIDCredentials: Decodable {
    enum CodingKeys: String, CodingKey {
        case appleID = "appleId"
        case appSpecificPassword
    }

    let appleID: String
    let appSpecificPassword: String
}

func printError(_ text: String, terminator: String = "\n") {
    fputs("Error: \(text)\(terminator)", stderr)
}

func environmentValue(forKey key: String) -> String {
    guard let value = ProcessInfo.processInfo.environment[key] else {
        printError("Unable to get environment variable \(key)")
        exit(EXIT_FAILURE)
    }
    return value
}

func execute(_ arguments: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = arguments
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

func handleCompletion(_ completion: Subscribers.Completion<Error>) {
    if case .failure(let error) = completion {
        printError("Credentials request failed: \(error.localizedDescription)")
        exit(EXIT_FAILURE)
    }
}

func handleAppleIDCredentials(_ appleIDCredentials: AppleIDCredentials) {
    let terminationStatus = execute(
        "xcrun", "altool", "--validate-app",
        "--file", bitriseIPAPath,
        "--username", appleIDCredentials.appleID,
        "--password", appleIDCredentials.appSpecificPassword,
        "-t", "iOS"
    )
    exit(terminationStatus)
}

let bitriseIPAPath = environmentValue(forKey: "BITRISE_IPA_PATH")
let bitriseBuildAPIToken = environmentValue(forKey: "BITRISE_BUILD_API_TOKEN")
let bitriseBuildURLString = environmentValue(forKey: "BITRISE_BUILD_URL")

guard let bitriseBuildURL = URL(string: bitriseBuildURLString) else {
    printError("Unable to create URL from BITRISE_BUILD_URL")
    exit(EXIT_FAILURE)
}

let url = bitriseBuildURL.appendingPathComponent("apple_developer_portal_data.json")
var request = URLRequest(url: url)
request.addValue(bitriseBuildAPIToken, forHTTPHeaderField: "BUILD_API_TOKEN")

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let session = URLSession(configuration: .ephemeral)
let cancellable = session.dataTaskPublisher(for: request)
    .map(\.data)
    .decode(type: AppleIDCredentials.self, decoder: decoder)
    .sink(receiveCompletion: handleCompletion, receiveValue: handleAppleIDCredentials)

dispatchMain()
