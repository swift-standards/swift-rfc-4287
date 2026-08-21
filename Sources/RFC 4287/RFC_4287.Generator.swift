import RFC_3987

extension RFC_4287 {

    public struct Generator: Hashable, Sendable, Codable {

        public let value: String

        public let uri: RFC_3987.IRI?

        public let version: String?

        public let base: RFC_3987.IRI?

        public let lang: String?

        public init(
            value: String,
            uri: RFC_3987.IRI? = nil,
            version: String? = nil,
            base: RFC_3987.IRI? = nil,
            lang: String? = nil
        ) {
            self.value = value
            self.uri = uri
            self.version = version
            self.base = base
            self.lang = lang
        }

        public init(
            value: String,

            uri: (any RFC_3987.IRI.Representable)?,
            version: String? = nil,

            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.init(value: value, uri: uri?.iri, version: version, base: base?.iri, lang: lang)
        }
    }
}
