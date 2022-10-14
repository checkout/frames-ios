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
  public enum Scheme: CaseIterable, Equatable, Hashable {
      
    public static var allCases: [Card.Scheme] = [.unknown, .discover, .mada, .mastercard, .maestro(length: 0), .americanExpress, .dinersClub, .jcb, .visa]

      
    private enum Constants {
      static let validCVVLengthsUnknownScheme = [0, 3, 4]
    }
      
    case unknown
    case mada
    case visa
    case mastercard
    case maestro(length: Int = 0)
    case americanExpress
    case discover
    case dinersClub
    case jcb

    public init?(rawValue: String, length: Int? = nil) {
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
        self = .maestro(length: length ?? 0)
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
        return NSRegularExpression(staticPattern: "^65[0-9]{14}|64[4-9][0-9]{13}|6011[0-9]{12}|(622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9][0-9]|9[01][0-9]|92[0-5])[0-9]{10})$")
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
        return NSRegularExpression(staticPattern: "^(?:5[06789]|6[37]|(?!6011[0234])(?!60117[4789])(?!60118[6789])(?!60119)(?!64[456789])(?!65)6\\d{3})")
      case .americanExpress:
        return NSRegularExpression(staticPattern: "^3[47]")
      case .discover:
        return NSRegularExpression(staticPattern: "^65|64[4-9]|6011|(622(?:12[6-9]|1[3-9]|[2-8]|9[01]|92[0-5]))")
      case .dinersClub:
        return NSRegularExpression(staticPattern: "^3(0|[68])")
      case .jcb:
        return NSRegularExpression(staticPattern: "^35")
      case .mada:
        // swiftlint:disable:next line_length
        return NSRegularExpression(staticPattern: "^(4(0(0861|1757|6996|7(197|395)|9201)|1(2565|0685|7633|9593)|2(281(7|8|9)|8(331|67(1|2|3)))|3(1361|2328|4107|9954)|4(0(533|647|795)|5564|6(393|404|672))|5(5(036|708)|7865|7997|8456)|6(2220|854(0|1|2|3))|8(301(0|1|2)|4783|609(4|5|6)|931(7|8|9))|93428)|5(0(4300|6968|8160)|13213|2(0058|1076|4(130|514)|9(415|741))|3(0(060|906)|1(095|196)|2013|5(825|989)|6023|7767|9931)|4(3(085|357)|9760)|5(4180|7606|8848)|8(5265|8(8(4(5|6|7|8|9)|5(0|1))|98(2|3))|9(005|206)))|6(0(4906|5141)|36120)|9682(0(1|2|3|4|5|6|7|8|9)|1(0|1)))")
      }
    }

    var cvvLengths: [Int] {
      switch self {
      case .unknown:
        return Constants.validCVVLengthsUnknownScheme
      case .maestro(let length):
        return length == 16 ? [3] : [0, 3]
      case .americanExpress:
        return [4]
      case .visa,
        .mada,
        .mastercard,
        .discover,
        .dinersClub,
        .jcb:
        return [3]
      }
    }
      
    public var rawValue: String {
        switch self {
        case .unknown:
            return "unknown"
        case .mada:
            return "mada"
        case .visa:
            return "visa"
        case .mastercard:
            return "mastercard"
        case .maestro:
            return "maestro"
        case .americanExpress:
            return "americanExpress"
        case .discover:
            return "discover"
        case .dinersClub:
            return "dinersClub"
        case .jcb:
            return "jcb"
        }
    }
      
    /// map of card scheme to indexes of spaces in formatted card number string
    /// eg. a visa card has gaps at 4, 8 and 12. 4242424242424242 becomes 4242 4242 4242 4242
    public var cardGaps: [Int] {
        switch self {
        case .unknown:
            return []
        case .visa, .discover, .maestro, .jcb:
            return [4, 8, 12, 16]
        case .mada, .mastercard:
            return [4, 8, 12]
        case .americanExpress, .dinersClub:
            return [4, 10]
        }
    }
      
    /// maximum card length for any scheme
    private static let maxCardLengthAllSchemes = 19

    var maxCardLength: Int {
      switch self {
      case .visa:
          return 19
      case .mada,
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
