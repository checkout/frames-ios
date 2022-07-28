//
//  CardType.swift
//  
//
//  Created by Harry Brown on 21/10/2021.
//

import Foundation

extension Card {
  /// Enum representing card scheme.
  ///
  /// We only support the following schemes:
  ///   - American Express
  ///   - Diner's Club
  ///   - Discover
  ///   - JCB
  ///   - Mada
  ///   - Maestro
  ///   - Mastercard
  ///   - Visa
  public enum Scheme: String, CaseIterable, CustomStringConvertible {
    case unknown
    case mada
    case visa
    case mastercard
    case maestro
    case americanExpress
    case discover
    case dinersClub
    case jcb

    public init?(rawValue: String) {
      switch rawValue.lowercased() {
      case "unknown":
        self = .unknown
      case "mada", "visa - mada", "mastercard - mada":
        self = .mada
      case "visa":
        self = .visa
      case "mastercard":
        self = .mastercard
      case "maestro":
        self = .maestro
      case "amex", "american express":
        self = .americanExpress
      case "discover":
        self = .discover
      case "diners", "diners club international":
        self = .dinersClub
      case "jcb":
        self = .jcb
      default:
        return nil
      }
    }

    var fullCardNumberRegex: NSRegularExpression? {
      switch self {
      case .unknown:
        return nil
      case .visa:
        return NSRegularExpression(staticPattern: "^4\\d{12}(\\d{3}|\\d{6})?$")
      case .mastercard:
        // swiftlint:disable:next line_length
        return NSRegularExpression(staticPattern: "^(5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)\\d{12}$")
      case .maestro:
        // swiftlint:disable:next line_length
        return NSRegularExpression(staticPattern: "^(?:5[06789]\\d\\d|(?!6011[0234])(?!60117[4789])(?!60118[6789])(?!60119)(?!64[456789])(?!65)6\\d{3})\\d{8,15}$")
      case .americanExpress:
        return NSRegularExpression(staticPattern: "^3[47]\\d{13}$")
      case .discover:
        // swiftlint:disable:next line_length
        return NSRegularExpression(staticPattern: "^6(011(0[0-9]|[2-4]\\d|74|7[7-9]|8[6-9]|9[0-9])|4[4-9]\\d{3}|5\\d{4})\\d{10}$")
      case .dinersClub:
        return NSRegularExpression(staticPattern: "^3(0[0-5]|[68]\\d)\\d{11,16}$")
      case .jcb:
        return NSRegularExpression(staticPattern: "^35\\d{14}$")
      case .mada:
        // swiftlint:disable:next line_length
        return NSRegularExpression(staticPattern: "^(4(0(0861|1757|6996|7(197|395)|9201)|1(2565|0685|7633|9593)|2(281(7|8|9)|8(331|67(1|2|3)))|3(1361|2328|4107|9954)|4(0(533|647|795)|5564|6(393|404|672))|5(5(036|708)|7865|7997|8456)|6(2220|854(0|1|2|3))|8(301(0|1|2)|4783|609(4|5|6)|931(7|8|9))|93428)|5(0(4300|6968|8160)|13213|2(0058|1076|4(130|514)|9(415|741))|3(0(060|906)|1(095|196)|2013|5(825|989)|6023|7767|9931)|4(3(085|357)|9760)|5(4180|7606|8848)|8(5265|8(8(4(5|6|7|8|9)|5(0|1))|98(2|3))|9(005|206)))|6(0(4906|5141)|36120)|9682(0(1|2|3|4|5|6|7|8|9)|1(0|1)))\\d{10}$")
      }
    }

    /// Minimum card length for eager check to pick up on scheme.
    /// Current longest is Maestro eg. 6011775
    static let minCardLengthToGuaranteeScheme = 7

    var eagerCardNumberRegex: NSRegularExpression? {
      switch self {
      case .unknown:
        return nil
      case .visa:
        return NSRegularExpression(staticPattern: "^4")
      case .mastercard:
        return NSRegularExpression(staticPattern: "^(2[3-7]|22[2-9]|5[1-5])")
      case .maestro:
        // swiftlint:disable:next line_length
        return NSRegularExpression(staticPattern: "^(5(018|0[23]|[68])|6[37]|60111|60115|60117([56]|7[56])|60118[0-5]|64[0-3]|66)")
      case .americanExpress:
        return NSRegularExpression(staticPattern: "^3[47]")
      case .discover:
        return NSRegularExpression(staticPattern: "^6(011(0[0-9]|[2-4]|74|7[7-9]|8[6-9]|9[0-9])|4[4-9]|5)")
      case .dinersClub:
        return NSRegularExpression(staticPattern: "^3(0|[68])")
      case .jcb:
        return NSRegularExpression(staticPattern: "^35")
      case .mada:
        // swiftlint:disable:next line_length
        return NSRegularExpression(staticPattern: "^(4(0(0861|1757|6996|7(197|395)|9201)|1(2565|0685|7633|9593)|2(281(7|8|9)|8(331|67(1|2|3)))|3(1361|2328|4107|9954)|4(0(533|647|795)|5564|6(393|404|672))|5(5(036|708)|7865|7997|8456)|6(2220|854(0|1|2|3))|8(301(0|1|2)|4783|609(4|5|6)|931(7|8|9))|93428)|5(0(4300|6968|8160)|13213|2(0058|1076|4(130|514)|9(415|741))|3(0(060|906)|1(095|196)|2013|5(825|989)|6023|7767|9931)|4(3(085|357)|9760)|5(4180|7606|8848)|8(5265|8(8(4(5|6|7|8|9)|5(0|1))|98(2|3))|9(005|206)))|6(0(4906|5141)|36120)|9682(0(1|2|3|4|5|6|7|8|9)|1(0|1)))")
      }
    }

    var cvvLength: Int? {
      switch self {
      case .unknown:
        return nil
      case .americanExpress:
        return 4
      case .visa,
        .mada,
        .mastercard,
        .maestro,
        .discover,
        .dinersClub,
        .jcb:
        return 3
      }
    }

    /// maximum card length for any scheme
    private static let maxCardLengthAllSchemes = 19

    var maxCardLength: Int {
      switch self {
      case .mada,
        .visa,
        .mastercard:
        return 16
      case .americanExpress:
        return 15
      case .unknown,
        .maestro,
        .discover,
        .dinersClub,
        .jcb:
        return Self.maxCardLengthAllSchemes
      }
    }

    public var description: String {
      return "Card.Scheme.\(rawValue)"
    }
  }
}
