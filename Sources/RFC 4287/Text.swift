import Foundation

extension RFC_4287 {
    /// A text construct as defined in RFC 4287 Section 3.1
    ///
    /// Text constructs are used for human-readable text in Atom documents.
    /// They can be plain text, HTML, or XHTML.
    public struct Text: Hashable, Sendable, Codable {
        /// The type of text content
        public enum ContentType: String, Hashable, Sendable, Codable {
            case text
            case html
            case xhtml
        }

        /// The type of this text construct
        public let type: ContentType

        /// The content of this text construct
        public let value: String

        /// Creates a new text construct
        ///
        /// - Parameters:
        ///   - value: The text content
        ///   - type: The type of content (defaults to .text)
        public init(_ value: String, type: ContentType = .text) {
            self.value = value
            self.type = type
        }
    }
}

// MARK: - ExpressibleByStringLiteral
extension RFC_4287.Text: ExpressibleByStringLiteral {
    /// Creates a text construct from a string literal (defaults to .text type)
    ///
    /// Example:
    /// ```swift
    /// let title: RFC_4287.Text = "My Blog Post"
    /// // Equivalent to: RFC_4287.Text("My Blog Post", type: .text)
    /// ```
    public init(stringLiteral value: String) {
        self.init(value, type: .text)
    }
}
