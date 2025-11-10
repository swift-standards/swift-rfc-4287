import Foundation
import RFC_3987

extension RFC_4287 {
    /// A generator construct as defined in RFC 4287 Section 4.2.4
    ///
    /// Identifies the agent used to generate a feed.
    public struct Generator: Hashable, Sendable, Codable {
        /// The generator name (required)
        public let value: String

        /// IRI for the generator (optional)
        public let uri: RFC_3987.IRI?

        /// Version of the generator (optional)
        public let version: String?

        /// Creates a new generator
        ///
        /// - Parameters:
        ///   - value: The generator name
        ///   - uri: IRI for the generator
        ///   - version: Version of the generator
        public init(
            value: String,
            uri: RFC_3987.IRI? = nil,
            version: String? = nil
        ) {
            self.value = value
            self.uri = uri
            self.version = version
        }

        /// Creates a new generator with IRI.Representable URI (convenience)
        ///
        /// Accepts any IRI.Representable type such as Foundation URL.
        ///
        /// - Parameters:
        ///   - value: The generator name
        ///   - uri: IRI for the generator (e.g., URL)
        ///   - version: Version of the generator
        public init(
            value: String,
            uri: (any RFC_3987.IRI.Representable)?,
            version: String? = nil
        ) {
            self.init(value: value, uri: uri?.iri, version: version)
        }
    }
}
