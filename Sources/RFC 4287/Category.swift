import Foundation
import RFC_3987

extension RFC_4287 {
    /// A category construct as defined in RFC 4287 Section 4.2.2
    ///
    /// Categories convey information about categories associated with an entry or feed.
    public struct Category: Hashable, Sendable, Codable {
        /// The category term (required)
        public let term: String

        /// The categorization scheme IRI (optional)
        public let scheme: RFC_3987.IRI?

        /// Human-readable label for the category (optional)
        public let label: String?

        /// Creates a new category
        ///
        /// - Parameters:
        ///   - term: The category term
        ///   - scheme: The categorization scheme IRI
        ///   - label: A human-readable label
        public init(
            term: String,
            scheme: RFC_3987.IRI? = nil,
            label: String? = nil
        ) {
            self.term = term
            self.scheme = scheme
            self.label = label
        }

        /// Creates a new category with IRI.Representable scheme (convenience)
        ///
        /// Accepts any IRI.Representable type such as Foundation URL.
        ///
        /// - Parameters:
        ///   - term: The category term
        ///   - scheme: The categorization scheme IRI (e.g., URL)
        ///   - label: A human-readable label
        public init(
            term: String,
            scheme: (any RFC_3987.IRI.Representable)?,
            label: String? = nil
        ) {
            self.init(term: term, scheme: scheme?.iri, label: label)
        }
    }
}

// MARK: - ExpressibleByStringLiteral
extension RFC_4287.Category: ExpressibleByStringLiteral {
    /// Creates a category from a string literal (just term, no scheme or label)
    ///
    /// Example:
    /// ```swift
    /// let category: RFC_4287.Category = "Technology"
    /// // Equivalent to: RFC_4287.Category(term: "Technology")
    /// ```
    public init(stringLiteral value: String) {
        self.init(term: value, scheme: nil, label: nil)
    }
}
