import Foundation
import RFC_3987

extension RFC_4287 {
    /// A source construct as defined in RFC 4287 Section 4.2.11
    ///
    /// Contains metadata from the source feed when an entry is copied from one feed into another.
    public struct Source: Hashable, Sendable, Codable {
        /// Feed authors
        public let authors: [Person]

        /// Feed categories
        public let categories: [Category]

        /// Feed contributors
        public let contributors: [Person]

        /// Generator information
        public let generator: Generator?

        /// Icon IRI
        public let icon: RFC_3987.IRI?

        /// Feed ID
        public let id: RFC_3987.IRI?

        /// Links
        public let links: [Link]

        /// Logo IRI
        public let logo: RFC_3987.IRI?

        /// Feed rights
        public let rights: Text?

        /// Feed subtitle
        public let subtitle: Text?

        /// Feed title
        public let title: Text?

        /// Last updated timestamp
        public let updated: Date?

        /// Creates a new source construct
        ///
        /// - Parameters:
        ///   - authors: Feed authors
        ///   - categories: Feed categories
        ///   - contributors: Feed contributors
        ///   - generator: Generator information
        ///   - icon: Icon IRI
        ///   - id: Feed ID
        ///   - links: Links
        ///   - logo: Logo IRI
        ///   - rights: Feed rights
        ///   - subtitle: Feed subtitle
        ///   - title: Feed title
        ///   - updated: Last updated timestamp
        public init(
            authors: [Person] = [],
            categories: [Category] = [],
            contributors: [Person] = [],
            generator: Generator? = nil,
            icon: RFC_3987.IRI? = nil,
            id: RFC_3987.IRI? = nil,
            links: [Link] = [],
            logo: RFC_3987.IRI? = nil,
            rights: Text? = nil,
            subtitle: Text? = nil,
            title: Text? = nil,
            updated: Date? = nil
        ) {
            self.authors = authors
            self.categories = categories
            self.contributors = contributors
            self.generator = generator
            self.icon = icon
            self.id = id
            self.links = links
            self.logo = logo
            self.rights = rights
            self.subtitle = subtitle
            self.title = title
            self.updated = updated
        }

        /// Creates a new source construct with IRI.Representable types (convenience)
        ///
        /// Accepts any IRI.Representable types such as Foundation URL.
        ///
        /// - Parameters:
        ///   - authors: Feed authors
        ///   - categories: Feed categories
        ///   - contributors: Feed contributors
        ///   - generator: Generator information
        ///   - icon: Icon IRI (e.g., URL)
        ///   - id: Feed ID (e.g., URL)
        ///   - links: Links
        ///   - logo: Logo IRI (e.g., URL)
        ///   - rights: Feed rights
        ///   - subtitle: Feed subtitle
        ///   - title: Feed title
        ///   - updated: Last updated timestamp
        public init(
            authors: [Person] = [],
            categories: [Category] = [],
            contributors: [Person] = [],
            generator: Generator? = nil,
            icon: (any RFC_3987.IRI.Representable)? = nil,
            id: (any RFC_3987.IRI.Representable)? = nil,
            links: [Link] = [],
            logo: (any RFC_3987.IRI.Representable)? = nil,
            rights: Text? = nil,
            subtitle: Text? = nil,
            title: Text? = nil,
            updated: Date? = nil
        ) {
            self.init(
                authors: authors,
                categories: categories,
                contributors: contributors,
                generator: generator,
                icon: icon?.iri,
                id: id?.iri,
                links: links,
                logo: logo?.iri,
                rights: rights,
                subtitle: subtitle,
                title: title,
                updated: updated
            )
        }
    }
}
