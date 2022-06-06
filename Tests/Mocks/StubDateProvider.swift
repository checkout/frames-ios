import Foundation

@testable import Frames

final class StubDateProvider: DateProviding {

    var currentDateReturnValue: Date!

    var currentDate: Date {

        return currentDateReturnValue
    }

}
