import UIKit

/// Expiration Date Picker is a control used for the inputting of expiration date.
@IBDesignable public class ExpirationDatePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Properties

    // Managing the date and calendar
    let calendar = Calendar(identifier: .gregorian)
    let timeZone = TimeZone(secondsFromGMT: 0)!

    // Configuring temporal attributes
    var maximumDate = Date(timeIntervalSinceNow: 31556926 * 20)
    let minimumDate = Date()

    /// Expiration picker delegate
    public weak var pickerDelegate: ExpirationDatePickerDelegate?

    // private properties
    private var months: [String] = []
    private var years: [String] = []

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        delegate = self
        dataSource = self

        #if !TARGET_INTERFACE_BUILDER
        for year in calendar.component(.year, from: minimumDate)...calendar.component(.year, from: maximumDate) {
            years.append(String(year))
        }

        for (index, month) in DateFormatter().shortStandaloneMonthSymbols.enumerated() {
            let monthNumber = index < 9 ? "0\(index + 1)" : "\(index + 1)"
            months.append("\(monthNumber) - \(month.uppercased())")
        }

        setDate(minimumDate, animated: false)
        #endif
    }

    // MARK: - Methods

    /// Set the date of the expiration picker
    ///
    /// - parameter date: Date
    /// - parameter animated: set it to true if the picker should be animated
    public func setDate(_ date: Date, animated: Bool) {
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)

        let monthIndex = month - 1
        let yearIndex = years.firstIndex(of: String(year))

        selectRow(monthIndex, inComponent: 0, animated: animated)
        selectRow(yearIndex!, inComponent: 1, animated: animated)
    }

    // MARK: - UIPickerViewDelegate

    /// Called by the picker view when the user selects a row in a component.
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // get the date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMyyyy"
        let selectedDateString =
        "\(getMonthFromPicker(pickerView))\(years[pickerView.selectedRow(inComponent: 1)])"
        let selectedDateOpt = formatter.date(from: selectedDateString)

        // check if between minimum and maximum dates
        guard let selectedDate = selectedDateOpt else { return }
        if selectedDate > maximumDate {
            setDate(maximumDate, animated: true)
        }
        if selectedDate < minimumDate {
            setDate(minimumDate, animated: true)
        }

        // call the delegate method to trigger the onDateChanged
        pickerDelegate?.onDateChanged(month: getMonthFromPicker(pickerView),
                                      year: years[pickerView.selectedRow(inComponent: 1)])
    }

    // MARK: - UIPickerViewDataSource

    /// Called by the picker view when it needs the number of components.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    /// Called by the picker view when it needs the number of rows for a specified component.
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }

    /// Called by the picker view when it needs the title to use for a given row in a given component.
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return years[row]
        default:
            return nil
        }
    }

    private func getMonthFromPicker(_ pickerView: UIPickerView) -> String {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        return selectedRow < 9 ? "0\(selectedRow + 1)" : "\(selectedRow + 1)"
    }

}
