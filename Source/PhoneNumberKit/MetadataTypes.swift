//
//  MetadataTypes.swift
//  PhoneNumberKit
//
//  Created by Roy Marmelstein on 02/11/2015.
//  Copyright © 2020 Roy Marmelstein. All rights reserved.
//

import Foundation

/**
 CKOMetadataTerritory object
 - Parameter codeID: ISO 639 compliant region code
 - Parameter countryCode: International country code
 - Parameter internationalPrefix: International prefix. Optional.
 - Parameter mainCountryForCode: Whether the current metadata is the main country for its country code.
 - Parameter nationalPrefix: National prefix
 - Parameter nationalPrefixFormattingRule: National prefix formatting rule
 - Parameter nationalPrefixForParsing: National prefix for parsing
 - Parameter nationalPrefixTransformRule: National prefix transform rule
 - Parameter emergency: MetadataPhoneNumberDesc for emergency numbers
 - Parameter fixedLine: MetadataPhoneNumberDesc for fixed line numbers
 - Parameter generalDesc: MetadataPhoneNumberDesc for general numbers
 - Parameter mobile: MetadataPhoneNumberDesc for mobile numbers
 - Parameter pager: MetadataPhoneNumberDesc for pager numbers
 - Parameter personalNumber: MetadataPhoneNumberDesc for personal number numbers
 - Parameter premiumRate: MetadataPhoneNumberDesc for premium rate numbers
 - Parameter sharedCost: MetadataPhoneNumberDesc for shared cost numbers
 - Parameter tollFree: MetadataPhoneNumberDesc for toll free numbers
 - Parameter voicemail: MetadataPhoneNumberDesc for voice mail numbers
 - Parameter voip: MetadataPhoneNumberDesc for voip numbers
 - Parameter uan: MetadataPhoneNumberDesc for uan numbers
 - Parameter leadingDigits: Optional leading digits for the territory
 */
public struct CKOMetadataTerritory: Decodable {
    public let codeID: String
    public let countryCode: UInt64
    public let internationalPrefix: String?
    public let mainCountryForCode: Bool
    public let nationalPrefix: String?
    public let nationalPrefixFormattingRule: String?
    public let nationalPrefixForParsing: String?
    public let nationalPrefixTransformRule: String?
    public let preferredExtnPrefix: String?
    public let emergency: CKOMetadataPhoneNumberDesc?
    public let fixedLine: CKOMetadataPhoneNumberDesc?
    public let generalDesc: CKOMetadataPhoneNumberDesc?
    public let mobile: CKOMetadataPhoneNumberDesc?
    public let pager: CKOMetadataPhoneNumberDesc?
    public let personalNumber: CKOMetadataPhoneNumberDesc?
    public let premiumRate: CKOMetadataPhoneNumberDesc?
    public let sharedCost: CKOMetadataPhoneNumberDesc?
    public let tollFree: CKOMetadataPhoneNumberDesc?
    public let voicemail: CKOMetadataPhoneNumberDesc?
    public let voip: CKOMetadataPhoneNumberDesc?
    public let uan: CKOMetadataPhoneNumberDesc?
    public let numberFormats: [CKOMetadataPhoneNumberFormat]
    public let leadingDigits: String?
}

/**
 MetadataPhoneNumberDesc object
 - Parameter exampleNumber: An example phone number for the given type. Optional.
 - Parameter nationalNumberPattern:  National number regex pattern. Optional.
 - Parameter possibleNumberPattern:  Possible number regex pattern. Optional.
 - Parameter possibleLengths: Possible phone number lengths. Optional.
 */
public struct CKOMetadataPhoneNumberDesc: Decodable {
    public let exampleNumber: String?
    public let nationalNumberPattern: String?
    public let possibleNumberPattern: String?
    public let possibleLengths: CKOMetadataPossibleLengths?
}

public struct CKOMetadataPossibleLengths: Decodable {
    let national: String?
    let localOnly: String?
}

/**
 CKOMetadataPhoneNumberFormat object
 - Parameter pattern: Regex pattern. Optional.
 - Parameter format: Formatting template. Optional.
 - Parameter intlFormat: International formatting template. Optional.

 - Parameter leadingDigitsPatterns: Leading digits regex pattern. Optional.
 - Parameter nationalPrefixFormattingRule: National prefix formatting rule. Optional.
 - Parameter nationalPrefixOptionalWhenFormatting: National prefix optional bool. Optional.
 - Parameter domesticCarrierCodeFormattingRule: Domestic carrier code formatting rule. Optional.
 */
public struct CKOMetadataPhoneNumberFormat: Decodable {
    public let pattern: String?
    public let format: String?
    public let intlFormat: String?
    public let leadingDigitsPatterns: [String]?
    public var nationalPrefixFormattingRule: String?
    public let nationalPrefixOptionalWhenFormatting: Bool?
    public let domesticCarrierCodeFormattingRule: String?
}

/// Internal object for metadata parsing
internal struct CKOPhoneNumberMetadata: Decodable {
    var territories: [CKOMetadataTerritory]
}
