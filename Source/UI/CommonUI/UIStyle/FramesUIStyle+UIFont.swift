import UIKit

/// Default Checkout UI Style
public enum FramesUIStyle {}

public extension FramesUIStyle {

    /// Custom Font for Checkout  UI style
    enum Font {

        // MARK: - Title -

        /// A font for big title with size 24 and medium weight
        static let title2 = FramesUIStyle.font(size: 24, weight: .medium)

        /// A font for headline with size 17 and `semibold` weight
        static let headline = FramesUIStyle.font(size: 17, weight: .semibold)

        // MARK: - Body -

        /// A font for large body with size 17 and regular weight
        static let bodyLarge = FramesUIStyle.font(size: 17, weight: .regular)

        /// A font for default body with size 15 and medium weight
        static let bodyDefault = FramesUIStyle.font(size: 15, weight: .regular)

        /// A font for default plus body with size 15 and regular weight
        static let bodyDefaultPlus = FramesUIStyle.font(size: 15, weight: .medium)

        /// A font for small body with size 13 and regular weight
        static let bodySmall = FramesUIStyle.font(size: 13, weight: .regular)

        /// A font for small plus body with size 13 and medium weight
        static let bodySmallPlus = FramesUIStyle.font(size: 13, weight: .medium)

        // MARK: - Input -

        /// A font for input label with size 15 and regular weight
        static let inputLabel = FramesUIStyle.font(size: 15, weight: .regular)

        // MARK: - Action -

        /// A font for large action with size 15 and medium weight
        static let actionLarge = FramesUIStyle.font(size: 15, weight: .medium)

        /// A font for default action with size 15 and regular weight
        static let actionDefault = FramesUIStyle.font(size: 15, weight: .regular)

    }
}

extension FramesUIStyle {
    /**
        Return the common used font in Checkout UI

        - Parameters:
           - size: size of the font like 24
           - weight: weight of the font like medium

        - Returns: UIFont
        */
    static func font(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: weight)
    }
}
