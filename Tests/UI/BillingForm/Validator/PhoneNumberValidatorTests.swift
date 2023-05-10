import XCTest
import Checkout
@testable import Frames

class PhoneNumberValidatorTests: XCTestCase {

    func testShouldAcceptEmptyInput() {
        let testString = ""
        let validator = PhoneNumberValidator()
        XCTAssertTrue(validator.shouldAccept(text: testString))
    }
    
    func testShouldAcceptNonNumericalInput() {
        let testString = "acJGy9^$.achtgfl)= Htha73"
        let validator = PhoneNumberValidator()
        XCTAssertFalse(validator.shouldAccept(text: testString))
    }
    
    func testShouldAcceptValidCharacterInput() {
        let testString = "12 + 0345 ) 6789 - ("
        let validator = PhoneNumberValidator()
        XCTAssertTrue(validator.shouldAccept(text: testString))
    }
    
    func testShouldAcceptOversizedInput() {
        var testString = ""
        (0...Checkout.Constants.Phone.phoneMaxLength).forEach { _ in
            testString.append("1")
        }
        let validator = PhoneNumberValidator()
        XCTAssertFalse(validator.shouldAccept(text: testString))
    }
    
    func testIsValidEmptyInput() {
        let testString = ""
        let validator = PhoneNumberValidator()
        XCTAssertFalse(validator.isValid(text: testString))
    }

    func testIsValidInputInvalidCharacters() {
        let testString = "acJGy9^$.achtgfl)= Htha73"
        let validator = PhoneNumberValidator()
        XCTAssertFalse(validator.isValid(text: testString))
    }
    
    func testIsValidInputValidCharactersNotPhoneNumber() {
        let testString = "+1234567890123"
        let validator = PhoneNumberValidator()
        XCTAssertFalse(validator.isValid(text: testString))
    }

    func testIsValidInputValidLocalePhoneNumber() {
        let testString = "01206333222"
        let validator = PhoneNumberValidator()
        validator.countryCode = "GB"
        XCTAssertTrue(validator.isValid(text: testString))
    }
    
    func testIsValidInputValidInternationalPhoneNumber() {
        let testString = "+919999999999"
        let validator = PhoneNumberValidator()
        XCTAssertTrue(validator.isValid(text: testString))
    }
    
    func testFormatForDisplayInvalidString() {
        let testString = "acJGy9^$.achtgfl)= Htha73"
        let validator = PhoneNumberValidator()
        XCTAssertEqual(validator.formatForDisplay(text: testString), testString)
    }
    
    func testFormatForDisplayValidStringInvalidPhoneNumber() {
        let testString = "012345678901234"
        let validator = PhoneNumberValidator()
        XCTAssertEqual(validator.formatForDisplay(text: testString), testString)
    }
    
    func testFormatForDisplayInternationPhoneNumber() {
        let testString = "+919999999999"
        let validator = PhoneNumberValidator()
        XCTAssertEqual(validator.formatForDisplay(text: testString), "+91 99999 99999")
    }
    
    func testFormatForDisplayValidPhoneNumber() {
        let testString = "01206321321"
        let validator = PhoneNumberValidator()
        validator.countryCode = "GB"
        XCTAssertEqual(validator.formatForDisplay(text: testString), "+44 1206 321321")
    }
    
    
    // MARK: Check country phone number outcomes
    func testUKNumber() {
        let testNumber = "+442073233888"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+44 20 7323 3888")
    }
    
    func testUSNumber() {
        let testNumber = "+14156914688"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+1 415-691-4688")
    }
    
    func testFranceNumber() {
        let testNumber = "+33187169980"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+33 1 87 16 99 80")
    }
    
    func testSaudiArabiaNumber() {
        let testNumber = "+966112735522"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+966 11 273 5522")
    }
    
    func testUAENumber() {
        let testNumber = "+97144202886"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+971 4 420 2886")
    }
    
    func testGermanyNumber() {
        let testNumber = "+493088789157"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+49 30 88789157")
    }
    
    func testHongKongNumber() {
        let testNumber = "+85230024051"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+852 3002 4051")
    }
    
    func testSingaporeNumber() {
        let testNumber = "+6569290270"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+65 6929 0270")
    }
    
    func testPortugalNumber() {
        let testNumber = "+351221208500"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+351 22 120 8500")
    }
    
    func testNewZeelandNumber() {
        let testNumber = "+6498888625"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+64 9 888 8625")
    }
    
    func testIrelandNumber() {
        let testNumber = "+35315747380"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+353 1 574 7380")
    }
    
    func testJapanNumber() {
        let testNumber = "+81332341077"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+81 3-3234-1077")
    }
    
    func testSpainNumber() {
        let testNumber = "+34919012170"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+34 919 01 21 70")
    }
    
    func testChinaNumber() {
        let testNumber = "+8602180510459"
        let validator = PhoneNumberValidator()
        
        XCTAssertTrue(validator.shouldAccept(text: testNumber))
        XCTAssertTrue(validator.isValid(text: testNumber))
        XCTAssertEqual(validator.formatForDisplay(text: testNumber), "+86 21 8051 0459")
    }
    
    func testSingletonBehaviour() {
        // GIVEN I need the validator singleton, I will receive a valid singleton to use
        weak var originalFormatter = PhoneNumberValidator.shared
        
        // WHEN I remove the singleton from memory, the reference I had is deallocated
        // confirming singleton was removed
        PhoneNumberValidator.removeSingleton()
        XCTAssertNil(originalFormatter)
        
        // THEN if I need to use singleton again, a NEW one will be created
        let newFormatter = PhoneNumberValidator.shared
        XCTAssertNil(originalFormatter)
        XCTAssertFalse(newFormatter === originalFormatter)
    }
    
    func testSingletonIsErasedWhenBillingViewModelIsRemoved() {
        /**
         Following the previous test, this ensures that the singleton lifetime is correctly coupled to
         the DefaultPaymentViewModel, as the DefaultPaymentViewModel is the object responsible for the
         lifetime of the Frames functionality.
         
         Test could also be moved to `DefaultPaymentViewModel` but either way it will create a coupling between the objects in test
         */
        var paymentViewModel: PaymentViewModel? = DefaultPaymentViewModel(
            checkoutAPIService: StubCheckoutAPIService(),
            cardValidator: CardValidator(environment: .sandbox),
            logger: StubFramesEventLogger(),
            billingFormData: nil,
            paymentFormStyle: nil,
            billingFormStyle: nil,
            supportedSchemes: [.mada])
        // Just a write action to silence compiler warning. This warnings seems to be
        // escalated to an error on CI
        paymentViewModel?.supportedSchemes = [.mada]
        weak var phoneNumberFormatter = PhoneNumberValidator.shared
        XCTAssertNotNil(phoneNumberFormatter)
        
        paymentViewModel = nil
        XCTAssertNil(phoneNumberFormatter)
    }
}
