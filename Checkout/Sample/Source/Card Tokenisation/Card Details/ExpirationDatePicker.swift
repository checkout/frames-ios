//
//  ExpirationDatePicker.swift
//
//
//  Created by Harry Brown on 08/02/2022.
//

import UIKit

final class ExpirationDatePicker: UIPickerView {
  private static let secondsInYear: TimeInterval = 60 * 60 * 24 * 365

  struct ViewModel {
    var onDateChanged: ((_ month: Int, _ year: Int) -> Void)?
  }

  var viewModel: ViewModel?

  private let months: [String]
  private let years: [Int]

  private let calendar: Calendar
  private let timeZone = TimeZone.utc

  private let maximumDate: Date
  private let minimumDate: Date

  convenience override init(frame: CGRect = .zero) {
    let calendar = Calendar(identifier: .gregorian)

    let minimumDate = Date()
    let maximumDate = Date(timeIntervalSinceNow: 20 * ExpirationDatePicker.secondsInYear)

    let months = (1...12).map { String(format: "%02d", $0) }
    let years = Array(calendar.component(.year, from: minimumDate)...calendar.component(.year, from: maximumDate))

    self.init(
      frame: frame,
      calendar: calendar,
      months: months,
      years: years,
      minimumDate: minimumDate,
      maximumDate: maximumDate
    )
  }

  public init(frame: CGRect, calendar: Calendar, months: [String], years: [Int], minimumDate: Date, maximumDate: Date) {
    self.calendar = calendar
    self.months = months
    self.years = years
    self.minimumDate = minimumDate
    self.maximumDate = maximumDate

    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    delegate = self
    dataSource = self

    setDate(minimumDate, animated: false)
  }

  public func setDate(_ date: Date, animated: Bool) {
    let (month, year) = monthAndYear(from: date)

    let monthIndex = month - 1
    let yearIndex = years.firstIndex(of: year)

    guard monthIndex < 12, let yearIndex = yearIndex else {
      return
    }

    selectRow(monthIndex, inComponent: 0, animated: animated)
    selectRow(yearIndex, inComponent: 1, animated: animated)
  }

  private func monthAndYear(from date: Date) -> (month: Int, year: Int) {
    let month = calendar.component(.month, from: date)
    let year = calendar.component(.year, from: date)

    return (month, year)
  }
}

extension ExpirationDatePicker: UIPickerViewDelegate {
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard var selectedDate = getDateFromPicker(pickerView: pickerView) else {
      return
    }

    if correctIfNeeded(selectedDate: selectedDate) {
      guard let newDate = getDateFromPicker(pickerView: pickerView) else {
        return
      }

      selectedDate = newDate
    }

    onDateChanged(selectedDate: selectedDate)
  }

  private func getDateFromPicker(pickerView: UIPickerView) -> Date? {
    var dateComponents = DateComponents()

    dateComponents.month = getMonthFromPicker(pickerView)
    dateComponents.year = years[pickerView.selectedRow(inComponent: 1)]
    dateComponents.calendar = calendar
    dateComponents.timeZone = timeZone

    return dateComponents.date
  }

  private func correctIfNeeded(selectedDate: Date) -> Bool {
    guard selectedDate <= maximumDate else {
      setDate(maximumDate, animated: true)
      return true
    }

    guard selectedDate >= minimumDate else {
      setDate(minimumDate, animated: true)
      return true
    }

    return false
  }

  private func onDateChanged(selectedDate: Date) {
    let (month, year) = monthAndYear(from: selectedDate)
    viewModel?.onDateChanged?(month, year)
  }
}

extension ExpirationDatePicker: UIPickerViewDataSource {
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }

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

  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch component {
    case 0:
      return months[row]
    case 1:
      return String(years[row])
    default:
      return nil
    }
  }

  private func getMonthFromPicker(_ pickerView: UIPickerView) -> Int {
    let month = pickerView.selectedRow(inComponent: 0) + 1
    return month
  }
}
