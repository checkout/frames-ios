import Foundation

/// Method that you can use to handle the country selection by the user
public protocol CountrySelectionViewControllerDelegate: AnyObject {

    /// Executed when an user select a country
    ///
    /// - parameter country: Country selected
    /// - parameter regionCode: Region code of the selected country
    func onCountrySelected(country: String, regionCode: String)
}
