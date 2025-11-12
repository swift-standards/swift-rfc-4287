import Foundation
import RFC_3987

extension RFC_4287 {
    /// A title text construct as defined in RFC 4287
    ///
    /// Represents the title element used in feeds and entries.
    public struct Title: Hashable, Sendable, Codable {
        /// The underlying text construct
        public let text: Text

        /// Creates a new title
        ///
        /// - Parameter text: The text construct
        public init(_ text: Text) {
            self.text = text
        }

        /// Creates a new title with a string value
        ///
        /// - Parameters:
        ///   - value: The title text
        ///   - type: The content type (defaults to .text)
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the content
        public init(
            _ value: String,
            type: Text.ContentType = .text,
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.text = Text(value, type: type, base: base, lang: lang)
        }

        /// The title value
        public var value: String { text.value }

        /// The content type
        public var type: Text.ContentType { text.type }

        /// Base IRI for resolving relative references
        public var base: RFC_3987.IRI? { text.base }

        /// Language of the content
        public var lang: String? { text.lang }
    }

    /// A subtitle text construct as defined in RFC 4287
    ///
    /// Represents the subtitle element used in feeds.
    public struct Subtitle: Hashable, Sendable, Codable {
        /// The underlying text construct
        public let text: Text

        /// Creates a new subtitle
        ///
        /// - Parameter text: The text construct
        public init(_ text: Text) {
            self.text = text
        }

        /// Creates a new subtitle with a string value
        ///
        /// - Parameters:
        ///   - value: The subtitle text
        ///   - type: The content type (defaults to .text)
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the content
        public init(
            _ value: String,
            type: Text.ContentType = .text,
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.text = Text(value, type: type, base: base, lang: lang)
        }

        /// The subtitle value
        public var value: String { text.value }

        /// The content type
        public var type: Text.ContentType { text.type }

        /// Base IRI for resolving relative references
        public var base: RFC_3987.IRI? { text.base }

        /// Language of the content
        public var lang: String? { text.lang }
    }

    /// A summary text construct as defined in RFC 4287
    ///
    /// Represents the summary element used in entries.
    public struct Summary: Hashable, Sendable, Codable {
        /// The underlying text construct
        public let text: Text

        /// Creates a new summary
        ///
        /// - Parameter text: The text construct
        public init(_ text: Text) {
            self.text = text
        }

        /// Creates a new summary with a string value
        ///
        /// - Parameters:
        ///   - value: The summary text
        ///   - type: The content type (defaults to .text)
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the content
        public init(
            _ value: String,
            type: Text.ContentType = .text,
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.text = Text(value, type: type, base: base, lang: lang)
        }

        /// The summary value
        public var value: String { text.value }

        /// The content type
        public var type: Text.ContentType { text.type }

        /// Base IRI for resolving relative references
        public var base: RFC_3987.IRI? { text.base }

        /// Language of the content
        public var lang: String? { text.lang }
    }

    /// A rights text construct as defined in RFC 4287
    ///
    /// Represents the rights element used in feeds and entries.
    public struct Rights: Hashable, Sendable, Codable {
        /// The underlying text construct
        public let text: Text

        /// Creates a new rights statement
        ///
        /// - Parameter text: The text construct
        public init(_ text: Text) {
            self.text = text
        }

        /// Creates a new rights statement with a string value
        ///
        /// - Parameters:
        ///   - value: The rights text
        ///   - type: The content type (defaults to .text)
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the content
        public init(
            _ value: String,
            type: Text.ContentType = .text,
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.text = Text(value, type: type, base: base, lang: lang)
        }

        /// The rights value
        public var value: String { text.value }

        /// The content type
        public var type: Text.ContentType { text.type }

        /// Base IRI for resolving relative references
        public var base: RFC_3987.IRI? { text.base }

        /// Language of the content
        public var lang: String? { text.lang }
    }
}

// MARK: - ExpressibleByStringLiteral

extension RFC_4287.Title: ExpressibleByStringLiteral {
    /// Creates a title from a string literal (defaults to .text type)
    public init(stringLiteral value: String) {
        self.init(value, type: .text)
    }
}

extension RFC_4287.Subtitle: ExpressibleByStringLiteral {
    /// Creates a subtitle from a string literal (defaults to .text type)
    public init(stringLiteral value: String) {
        self.init(value, type: .text)
    }
}

extension RFC_4287.Summary: ExpressibleByStringLiteral {
    /// Creates a summary from a string literal (defaults to .text type)
    public init(stringLiteral value: String) {
        self.init(value, type: .text)
    }
}

extension RFC_4287.Rights: ExpressibleByStringLiteral {
    /// Creates a rights statement from a string literal (defaults to .text type)
    public init(stringLiteral value: String) {
        self.init(value, type: .text)
    }
}
