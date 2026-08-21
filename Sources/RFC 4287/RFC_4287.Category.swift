import RFC_3987

extension RFC_4287 {

    public struct Category: Hashable, Sendable, Codable {

        public let term: String

        public let scheme: RFC_3987.IRI?

        public let label: String?

        public let base: RFC_3987.IRI?

        public let lang: String?

        public init(
            term: String,
            scheme: RFC_3987.IRI? = nil,
            label: String? = nil,
            base: RFC_3987.IRI? = nil,
            lang: String? = nil
        ) {
            self.term = term
            self.scheme = scheme
            self.label = label
            self.base = base
            self.lang = lang
        }

    }
}

extension RFC_4287.Category {

    public init(
        term: String,

        scheme: (any RFC_3987.IRI.Representable)?,
        label: String? = nil,

        base: (any RFC_3987.IRI.Representable)? = nil,
        lang: String? = nil
    ) {
        self.init(term: term, scheme: scheme?.iri, label: label, base: base?.iri, lang: lang)
    }
}

extension RFC_4287.Category: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(term: value, scheme: nil, label: nil)
    }
}
