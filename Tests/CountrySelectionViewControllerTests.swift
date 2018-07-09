import XCTest
@testable import FramesIos

class MockDelegate: CountrySelectionViewControllerDelegate {

    public var methodCalledTimes = 0
    public var methodLastCalledWith = ("", "")

    func onCountrySelected(country: String, regionCode: String) {
        methodCalledTimes += 1
        methodLastCalledWith = (country, regionCode)
    }
}

class CountrySelectionViewControllerTests: XCTestCase {

    var countrySelectionViewController = CountrySelectionViewController()
    let numberOfCountries = 256

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        countrySelectionViewController = CountrySelectionViewController()
        countrySelectionViewController.viewDidLoad()
    }

    func testInitialization() {
        let countrySelectionViewController = CountrySelectionViewController()
        countrySelectionViewController.viewDidLoad()
        XCTAssertEqual(countrySelectionViewController.filteredCountries.count, numberOfCountries)
    }

    func testNumberOfSectionsInTableView() {
        XCTAssertEqual(countrySelectionViewController.numberOfSections(in: countrySelectionViewController.tableView), 1)
    }

    func testNumberOfRowsInSection() {
       let actual = countrySelectionViewController.tableView(countrySelectionViewController.tableView,
                                                             numberOfRowsInSection: 0)
    XCTAssertEqual(actual, numberOfCountries)
    }

    func testCallDelegateMethodOnCountrySelected() {
        let delegate = MockDelegate()
        countrySelectionViewController.delegate = delegate
        countrySelectionViewController.tableView(countrySelectionViewController.tableView,
                                                 didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(delegate.methodCalledTimes, 1)
        XCTAssertEqual(delegate.methodLastCalledWith.0, countrySelectionViewController.countries[0].0)
        XCTAssertEqual(delegate.methodLastCalledWith.1, countrySelectionViewController.countries[0].1)
    }

    func testUpdateSearchResults() {
        /// Initial list
        XCTAssertEqual(countrySelectionViewController.filteredCountries.count,
                       countrySelectionViewController.countries.count)
        /// Search with nothing
        countrySelectionViewController.updateSearchResults(text: nil)
        XCTAssertEqual(countrySelectionViewController.filteredCountries.count,
                       countrySelectionViewController.countries.count)
        /// Search with 'A'
        countrySelectionViewController.updateSearchResults(text: "A")
        XCTAssertLessThan(countrySelectionViewController.filteredCountries.count,
                          countrySelectionViewController.countries.count)
    }

    func testSearchBarSearchButtonClicked() {
        countrySelectionViewController.searchBar.text = "A"
        XCTAssertEqual(countrySelectionViewController.filteredCountries.count,
                       countrySelectionViewController.countries.count)
        countrySelectionViewController.searchBarSearchButtonClicked(countrySelectionViewController.searchBar)
        XCTAssertLessThan(countrySelectionViewController.filteredCountries.count,
                          countrySelectionViewController.countries.count)
    }

    func testSearchBarCancelButtonClicked() {
        // setup
        countrySelectionViewController.searchBar.text = "A"
        countrySelectionViewController.updateSearchResults(text: "A")
        XCTAssertLessThan(countrySelectionViewController.filteredCountries.count,
                          countrySelectionViewController.countries.count)
        // execute
        countrySelectionViewController.searchBarCancelButtonClicked(countrySelectionViewController.searchBar)
        // assert
        XCTAssertEqual(countrySelectionViewController.searchBar.text, "")
        XCTAssertEqual(countrySelectionViewController.filteredCountries.count,
                       countrySelectionViewController.countries.count)
    }

    func testUpdateSearchOnTextChanged() {
        countrySelectionViewController.searchBar(countrySelectionViewController.searchBar, textDidChange: "A")
        XCTAssertLessThan(countrySelectionViewController.filteredCountries.count,
                          countrySelectionViewController.countries.count)
    }

    func testResetSearchResultsWhenTextBecomesEmpty() {
        testUpdateSearchOnTextChanged()
        countrySelectionViewController.searchBar(countrySelectionViewController.searchBar, textDidChange: "")
        XCTAssertEqual(countrySelectionViewController.filteredCountries.count,
                          countrySelectionViewController.countries.count)
    }

    func testCellInsertedAtTheLocation() {
        let countryAt50 = countrySelectionViewController.filteredCountries[50].0
        let indexPath = IndexPath(row: 50, section: 0)
        let cell = countrySelectionViewController.tableView(countrySelectionViewController.tableView,
                                                            cellForRowAt: indexPath)
        XCTAssertEqual(cell.textLabel?.text, countryAt50)
    }

}
