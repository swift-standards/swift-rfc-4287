import Foundation
import RFC_2822
import RFC_3987

extension RFC_4287 {
    /// A person construct as defined in RFC 4287 Section 3.2
    ///
    /// Person constructs describe authors and contributors.
    public struct Person: Hashable, Sendable {
        /// The human-readable name of the person (required)
        public let name: String

        /// The IRI associated with the person (optional)
        ///
        /// Per RFC 4287 Section 3.2.2, this should be an IRI reference.
        public let uri: RFC_3987.IRI?

        /// The email address of the person (optional)
        ///
        /// Per RFC 4287 Section 3.2.3, this must be an email address
        /// conforming to the "addr-spec" production in RFC 2822.
        public let email: RFC_2822.AddrSpec?

        /// Creates a new person construct
        ///
        /// - Parameters:
        ///   - name: The person's name
        ///   - uri: An optional IRI for the person
        ///   - email: An optional email address (RFC 2822 AddrSpec)
        public init(
            name: String,
            uri: RFC_3987.IRI? = nil,
            email: RFC_2822.AddrSpec? = nil
        ) {
            self.name = name
            self.uri = uri
            self.email = email
        }

        /// Creates a new person construct with IRI.Representable URI (convenience)
        ///
        /// Accepts any IRI.Representable type such as Foundation URL.
        ///
        /// - Parameters:
        ///   - name: The person's name
        ///   - uri: An optional IRI-representable value (e.g., URL)
        ///   - email: An optional email address (RFC 2822 AddrSpec)
        public init(
            name: String,
            uri: (any RFC_3987.IRI.Representable)?,
            email: RFC_2822.AddrSpec? = nil
        ) {
            self.init(name: name, uri: uri?.iri, email: email)
        }

        /// Creates a new person construct with string email (convenience)
        ///
        /// - Parameters:
        ///   - name: The person's name
        ///   - uri: An optional IRI string for the person
        ///   - emailString: Email address as string (will be parsed as local@domain)
        /// - Throws: RFC_2822.ValidationError if email is invalid
        public init(
            name: String,
            uri: String? = nil,
            emailString: String
        ) throws {
            // Parse email into local-part and domain
            let components = emailString.split(separator: "@", maxSplits: 1)
            guard components.count == 2 else {
                throw RFC_2822.ValidationError.invalidFieldValue("email", emailString)
            }
            let addrSpec = try RFC_2822.AddrSpec(
                localPart: String(components[0]),
                domain: String(components[1])
            )
            self.init(name: name, uri: uri.map { RFC_3987.IRI(unchecked: $0) }, email: addrSpec)
        }
    }
}

// MARK: - Codable
extension RFC_4287.Person: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case uri
        case email
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        uri = try container.decodeIfPresent(String.self, forKey: .uri).map {
            RFC_3987.IRI(unchecked: $0)
        }

        // Decode email as string and convert to AddrSpec
        if let emailString = try container.decodeIfPresent(String.self, forKey: .email) {
            let components = emailString.split(separator: "@", maxSplits: 1)
            guard components.count == 2 else {
                throw DecodingError.dataCorruptedError(
                    forKey: .email,
                    in: container,
                    debugDescription: "Invalid email format: \(emailString)"
                )
            }
            email = try RFC_2822.AddrSpec(
                localPart: String(components[0]),
                domain: String(components[1])
            )
        } else {
            email = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(uri?.value, forKey: .uri)
        // Encode email as string
        if let email = email {
            try container.encode(email.description, forKey: .email)
        }
    }
}

// MARK: - ExpressibleByStringLiteral
extension RFC_4287.Person: ExpressibleByStringLiteral {
    /// Creates a person from a string literal (just name, no URI or email)
    ///
    /// Example:
    /// ```swift
    /// let author: RFC_4287.Person = "John Doe"
    /// // Equivalent to: RFC_4287.Person(name: "John Doe")
    /// ```
    public init(stringLiteral value: String) {
        self.init(name: value, uri: nil, email: nil)
    }
}
