import UIKit

/// A view controller that allows the user to select a country.
public class CountrySelectionViewController: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UISearchBarDelegate {

    // MARK: - Properties

    var countries: [(String, String)] {
        let locale = Locale.current
        let countries = Locale.isoRegionCodes.map {
            return (locale.localizedString(forRegionCode: $0)!, $0)
        }
        return countries.sorted { $0.0 < $1.0 }
    }

    var filteredCountries: [(String, String)] = []

    let searchController = UISearchController(searchResultsController: nil)

    let tableView = UITableView()
    let tableViewCell = UITableViewCell(style: .default, reuseIdentifier: "countryCell")
    let searchBar = UISearchBar()

    /// Country selection view controller delegate
    public weak var delegate: CountrySelectionViewControllerDelegate?

    // MARK: - Lifecycle

    /// Called after the controller's view is loaded into memory.
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = CheckoutTheme.primaryBackgroundColor
        navigationItem.title = "countryRegion".localized(forClass: CountrySelectionViewController.self)
        // table view
        filteredCountries = countries
        tableView.delegate = self
        tableView.dataSource = self
        // search bar
        searchBar.delegate = self

        tableView.backgroundColor = CheckoutTheme.primaryBackgroundColor
        searchBar.barStyle = CheckoutTheme.barStyle
    }

    private func setup() {
        // add views
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "countryCell")
        view.addSubview(searchBar)
        view.addSubview(tableView)
        addConstraints()
    }

    private func addConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
    }

    // MARK: - UITableViewDataSource

    /// Asks the data source to return the number of sections in the table view.
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = CheckoutTheme.tertiaryBackgroundColor
        cell.textLabel?.font = CheckoutTheme.font
        cell.textLabel?.textColor = CheckoutTheme.color
    }

    /// Tells the data source to return the number of rows in a given section of a table view.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }

    /// Asks the data source for a cell to insert in a particular location of the table view.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        cell.textLabel?.text = filteredCountries[indexPath.row].0
        return cell
    }

    /// Tells the delegate that the specified row is now selected.
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onCountrySelected(country: filteredCountries[indexPath.row].0,
                                    regionCode: filteredCountries[indexPath.row].1)
        navigationController?.popViewController(animated: true)
    }

    func updateSearchResults(text: String?) {
        guard let searchText = text else { return }
        filteredCountries = countries.filter { country in
            return country.0.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    // MARK: - UISearchBarDelegate

    /// Tells the delegate that the user changed the search text.
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCountries = countries
            tableView.reloadData()
        } else {
            updateSearchResults(text: searchText)
        }
    }

    /// Tells the delegate that the search button was tapped.
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResults(text: searchBar.text)
        searchBar.endEditing(true)
    }

    /// Tells the delegate that the cancel button was tapped.
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        filteredCountries = countries
        tableView.reloadData()
    }

}
