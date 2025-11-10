import Foundation
import RFC_3987

extension RFC_4287 {
    /// A link construct as defined in RFC 4287 Section 4.2.7
    ///
    /// Links define references to Web resources.
    public struct Link: Hashable, Sendable, Codable {
        /// Link relation types as defined in RFC 4287 and extensions
        public enum Relation: Hashable, Sendable, Codable {
            case alternate
            case related
            case `self`
            case enclosure
            case via
            case custom(String)

            public var stringValue: String {
                switch self {
                case .alternate: return "alternate"
                case .related: return "related"
                case .`self`: return "self"
                case .enclosure: return "enclosure"
                case .via: return "via"
                case .custom(let value): return value
                }
            }

            public init(stringValue: String) {
                switch stringValue {
                case "alternate": self = .alternate
                case "related": self = .related
                case "self": self = .`self`
                case "enclosure": self = .enclosure
                case "via": self = .via
                default: self = .custom(stringValue)
                }
            }

            // MARK: - Codable

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let string = try container.decode(String.self)
                self.init(stringValue: string)
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(stringValue)
            }
        }

        /// The IRI of the referenced resource (required)
        ///
        /// Per RFC 4287 Section 4.2.7, the href attribute contains an IRI reference.
        public let href: RFC_3987.IRI

        /// The link relation type (optional)
        ///
        /// Per RFC 4287 Section 4.2.7.2: If the rel attribute is not present,
        /// the link element MUST be interpreted as if the link relation type is "alternate".
        ///
        /// When `nil`, consumers should treat the link as having relation type "alternate".
        public let rel: Relation?

        /// The media type of the resource (optional)
        public let type: String?

        /// The language of the resource (optional)
        public let hreflang: String?

        /// Human-readable title for the link (optional)
        public let title: String?

        /// The length of the resource in bytes (optional)
        public let length: Int?

        /// Creates a new link
        ///
        /// - Parameters:
        ///   - href: The IRI of the resource
        ///   - rel: The link relation type
        ///   - type: The media type
        ///   - hreflang: The language
        ///   - title: A title for the link
        ///   - length: The length in bytes
        public init(
            href: RFC_3987.IRI,
            rel: Relation? = nil,
            type: String? = nil,
            hreflang: String? = nil,
            title: String? = nil,
            length: Int? = nil
        ) {
            self.href = href
            self.rel = rel
            self.type = type
            self.hreflang = hreflang
            self.title = title
            self.length = length
        }

        /// Creates a new link with IRI.Representable href (convenience)
        ///
        /// Accepts any IRI.Representable type such as Foundation URL.
        ///
        /// - Parameters:
        ///   - href: The IRI of the resource (e.g., URL, RFC_3987.IRI)
        ///   - rel: The link relation type
        ///   - type: The media type
        ///   - hreflang: The language
        ///   - title: A title for the link
        ///   - length: The length in bytes
        public init(
            href: any RFC_3987.IRI.Representable,
            rel: Relation? = nil,
            type: String? = nil,
            hreflang: String? = nil,
            title: String? = nil,
            length: Int? = nil
        ) {
            self.init(href: href.iri, rel: rel, type: type, hreflang: hreflang, title: title, length: length)
        }

        /// Returns true if this link should be treated as an "alternate" relation
        ///
        /// Per RFC 4287 Section 4.2.7.2: If the rel attribute is not present,
        /// the link element MUST be interpreted as if the link relation type is "alternate".
        public var isAlternate: Bool {
            rel == .alternate || rel == nil
        }
    }
}

// MARK: - ExpressibleByStringLiteral
extension RFC_4287.Link: ExpressibleByStringLiteral {
    /// Creates a link from a string literal (just href, alternate relation)
    ///
    /// Example:
    /// ```swift
    /// let link: RFC_4287.Link = "https://example.com/post"
    /// ```
    ///
    /// Note: This does not perform IRI validation at compile time.
    /// For runtime validation, use `try RFC_3987.IRI("...")` and pass to `init(href:)`.
    public init(stringLiteral value: String) {
        self.init(
            href: RFC_3987.IRI(unchecked: value), rel: nil, type: nil, hreflang: nil, title: nil,
            length: nil)
    }
}
