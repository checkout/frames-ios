//
//  Metadata.swift
//  PhoneNumberKit
//
//  Created by Roy Marmelstein on 03/10/2015.
//  Copyright © 2020 Roy Marmelstein. All rights reserved.
//

import Foundation

final class MetadataManager {
    var territories = [CKOMetadataTerritory]()
    var territoriesByCode = [UInt64: [CKOMetadataTerritory]]()
    var mainTerritoryByCode = [UInt64: CKOMetadataTerritory]()
    var territoriesByCountry = [String: CKOMetadataTerritory]()

    // MARK: Lifecycle

    /// Private init populates metadata territories and the two hashed dictionaries for faster lookup.
    ///
    /// - Parameter metadataCallback: a closure that returns metadata as JSON Data.
    public init(metadataCallback: CKOMetadataCallback) {
        self.territories = self.populateTerritories(metadataCallback: metadataCallback)
        for item in self.territories {
            var currentTerritories: [CKOMetadataTerritory] = self.territoriesByCode[item.countryCode] ?? [CKOMetadataTerritory]()
            // In the case of multiple countries sharing a calling code, such as the NANPA countries,
            // the one indicated with "isMainCountryForCode" in the metadata should be first.
            if item.mainCountryForCode {
                currentTerritories.insert(item, at: 0)
            } else {
                currentTerritories.append(item)
            }
            self.territoriesByCode[item.countryCode] = currentTerritories
            if self.mainTerritoryByCode[item.countryCode] == nil || item.mainCountryForCode == true {
                self.mainTerritoryByCode[item.countryCode] = item
            }
            self.territoriesByCountry[item.codeID] = item
        }
    }

    deinit {
        territories.removeAll()
        territoriesByCode.removeAll()
        territoriesByCountry.removeAll()
    }

    /// Populates the metadata from a metadataCallback.
    ///
    /// - Parameter metadataCallback: a closure that returns metadata as JSON Data.
    /// - Returns: array of CKOMetadataTerritory objects
    private func populateTerritories(metadataCallback: CKOMetadataCallback) -> [CKOMetadataTerritory] {
        var territoryArray = [CKOMetadataTerritory]()
        do {
            let jsonData: Data? = try metadataCallback()
            let jsonDecoder = JSONDecoder()
            if let jsonData = jsonData, let metadata: CKOPhoneNumberMetadata = try? jsonDecoder.decode(CKOPhoneNumberMetadata.self, from: jsonData) {
                territoryArray = metadata.territories
            }
        } catch {
            debugPrint("ERROR: Unable to load PhoneNumberMetadata.json resource: \(error.localizedDescription)")
        }
        return territoryArray
    }

    // MARK: Filters

    /// Get an array of CKOMetadataTerritory objects corresponding to a given country code.
    ///
    /// - parameter code:  international country code (e.g 44 for the UK).
    ///
    /// - returns: optional array of CKOMetadataTerritory objects.
    internal func filterTerritories(byCode code: UInt64) -> [CKOMetadataTerritory]? {
        return self.territoriesByCode[code]
    }

    /// Get the CKOMetadataTerritory objects for an ISO 639 compliant region code.
    ///
    /// - parameter country: ISO 639 compliant region code (e.g "GB" for the UK).
    ///
    /// - returns: A CKOMetadataTerritory object.
    internal func filterTerritories(byCountry country: String) -> CKOMetadataTerritory? {
        return self.territoriesByCountry[country.uppercased()]
    }

    /// Get the main CKOMetadataTerritory objects for a given country code.
    ///
    /// - parameter code: An international country code (e.g 1 for the US).
    ///
    /// - returns: A CKOMetadataTerritory object.
    internal func mainTerritory(forCode code: UInt64) -> CKOMetadataTerritory? {
        return self.mainTerritoryByCode[code]
    }
}
