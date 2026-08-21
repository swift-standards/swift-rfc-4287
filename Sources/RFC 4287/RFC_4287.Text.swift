import RFC_3987

extension RFC_4287 {

    public struct Text: Hashable, Sendable, Codable {

        public let type: RFC_4287.Text.ContentType

        public let value: String

        public let base: RFC_3987.IRI?

        public let lang: String?

        public init(
            _ value: String,
            type: RFC_4287.Text.ContentType = .text,

            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.value = value
            self.type = type
            self.base = base?.iri
            self.lang = lang
        }
    }
}

extension RFC_4287.Text: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value, type: .text)
    }
}
