import Foundation

protocol DateProviding {
    
    /// Returns a `Date` a date value initialized to the current date and time.
    var currentDate: Date { get }
    
}

final class DateProvider: DateProviding {
    
    var currentDate: Date { return Date() }
    
}
