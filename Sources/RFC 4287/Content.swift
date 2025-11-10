import Foundation
import RFC_3987

extension RFC_4287 {
    /// A content construct as defined in RFC 4287 Section 4.1.3
    ///
    /// Contains or links to the content of an entry.
    public struct Content: Hashable, Sendable, Codable {
        /// The type of content
        public enum ContentType: Hashable, Sendable, Codable {
            case text
            case html
            case xhtml
            case media(String)  // e.g., "image/png", "application/pdf"

            public var stringValue: String {
                switch self {
                case .text: return "text"
                case .html: return "html"
                case .xhtml: return "xhtml"
                case .media(let type): return type
                }
            }

            public init(stringValue: String) {
                switch stringValue {
                case "text": self = .text
                case "html": self = .html
                case "xhtml": self = .xhtml
                default: self = .media(stringValue)
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

        /// The type of this content
        public let type: ContentType

        /// The content value or URI reference
        public let value: String?

        /// The source IRI (when content is out-of-line)
        public let src: RFC_3987.IRI?

        /// Creates inline content
        ///
        /// - Parameters:
        ///   - value: The content
        ///   - type: The content type
        public init(value: String, type: ContentType = .text) {
            self.value = value
            self.type = type
            self.src = nil
        }

        /// Creates inline binary content from data
        ///
        /// - Parameters:
        ///   - data: The binary content data (will be base64-encoded)
        ///   - mediaType: The MIME type of the content
        ///
        /// This initializer automatically base64-encodes the data as required by RFC 4287
        /// for binary media types.
        public init(data: Data, mediaType: String) {
            self.value = data.base64EncodedString()
            self.type = .media(mediaType)
            self.src = nil
        }

        /// Creates out-of-line content
        ///
        /// - Parameters:
        ///   - src: The IRI of the content
        ///   - type: The content type
        public init(src: RFC_3987.IRI, type: ContentType = .text) {
            self.value = nil
            self.type = type
            self.src = src
        }

        /// Determines if this content type requires base64 encoding per RFC 4287 Section 4.1.3.3
        ///
        /// Returns true if the content is a binary media type that requires base64 encoding:
        /// - Not text, html, or xhtml
        /// - Not an XML media type (doesn't end with /xml or +xml)
        /// - Doesn't begin with "text/"
        public var requiresBase64Encoding: Bool {
            guard case .media(let mediaType) = type else {
                return false
            }

            // Check if it's an XML media type
            if mediaType.hasSuffix("/xml") || mediaType.hasSuffix("+xml") {
                return false
            }

            // Check if it begins with "text/"
            if mediaType.hasPrefix("text/") {
                return false
            }

            // All other media types require base64 encoding
            return true
        }
    }
}
