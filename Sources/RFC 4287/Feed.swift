import Foundation
import RFC_3987

extension RFC_4287 {
    /// An Atom feed document as defined in RFC 4287 Section 4.1.1
    ///
    /// The top-level element of an Atom feed document.
    public struct Feed: Hashable, Sendable, Codable {
        /// Feed authors (at least one required if entries don't have authors)
        public let authors: [Person]

        /// Feed categories
        public let categories: [Category]

        /// Feed contributors
        public let contributors: [Person]

        /// Generator information
        public let generator: Generator?

        /// Icon IRI (should be small and square)
        ///
        /// Per RFC 4287 Section 4.2.5, this should be an IRI reference.
        public let icon: RFC_3987.IRI?

        /// Permanent, universally unique identifier (required)
        ///
        /// Per RFC 4287 Section 4.2.6, this MUST be an IRI reference.
        /// It MUST be permanent and universally unique, and MUST NOT change.
        public let id: RFC_3987.IRI

        /// Links associated with the feed
        public let links: [Link]

        /// Logo IRI (should be rectangular)
        ///
        /// Per RFC 4287 Section 4.2.8, this should be an IRI reference.
        public let logo: RFC_3987.IRI?

        /// Copyright and licensing information
        public let rights: Text?

        /// Subtitle or tagline
        public let subtitle: Text?

        /// Human-readable title (required)
        public let title: Text

        /// Timestamp of last significant modification (required)
        public let updated: Date

        /// Feed entries
        public let entries: [Entry]

        /// Creates a new feed with validation
        ///
        /// - Parameters:
        ///   - id: Permanent, universally unique identifier
        ///   - title: Human-readable title
        ///   - updated: Timestamp of last modification
        ///   - authors: Feed authors
        ///   - entries: Feed entries
        ///   - links: Associated links
        ///   - categories: Feed categories
        ///   - contributors: Feed contributors
        ///   - generator: Generator information
        ///   - icon: Icon IRI
        ///   - logo: Logo IRI
        ///   - rights: Rights information
        ///   - subtitle: Feed subtitle
        ///
        /// - Returns: A validated feed, or nil if validation fails
        public init?(
            id: RFC_3987.IRI,
            title: Text,
            updated: Date,
            authors: [Person] = [],
            entries: [Entry] = [],
            links: [Link] = [],
            categories: [Category] = [],
            contributors: [Person] = [],
            generator: Generator? = nil,
            icon: RFC_3987.IRI? = nil,
            logo: RFC_3987.IRI? = nil,
            rights: Text? = nil,
            subtitle: Text? = nil
        ) {
            // Validation: feed must have authors OR all entries must have authors
            let feedHasAuthors = !authors.isEmpty
            let allEntriesHaveAuthors = entries.allSatisfy { !$0.authors.isEmpty }

            guard feedHasAuthors || entries.isEmpty || allEntriesHaveAuthors else {
                return nil
            }

            self.id = id
            self.title = title
            self.updated = updated
            self.authors = authors
            self.entries = entries
            self.links = links
            self.categories = categories
            self.contributors = contributors
            self.generator = generator
            self.icon = icon
            self.logo = logo
            self.rights = rights
            self.subtitle = subtitle
        }

        /// Creates a new feed with validation using IRI.Representable types (convenience)
        ///
        /// Accepts any IRI.Representable types such as Foundation URL.
        ///
        /// - Parameters:
        ///   - id: Permanent, universally unique identifier (e.g., URL)
        ///   - title: Human-readable title
        ///   - updated: Timestamp of last modification
        ///   - authors: Feed authors
        ///   - entries: Feed entries
        ///   - links: Associated links
        ///   - categories: Feed categories
        ///   - contributors: Feed contributors
        ///   - generator: Generator information
        ///   - icon: Icon IRI (e.g., URL)
        ///   - logo: Logo IRI (e.g., URL)
        ///   - rights: Rights information
        ///   - subtitle: Feed subtitle
        ///
        /// - Returns: A validated feed, or nil if validation fails
        public init?(
            id: any RFC_3987.IRI.Representable,
            title: Text,
            updated: Date,
            authors: [Person] = [],
            entries: [Entry] = [],
            links: [Link] = [],
            categories: [Category] = [],
            contributors: [Person] = [],
            generator: Generator? = nil,
            icon: (any RFC_3987.IRI.Representable)? = nil,
            logo: (any RFC_3987.IRI.Representable)? = nil,
            rights: Text? = nil,
            subtitle: Text? = nil
        ) {
            self.init(
                id: id.iri,
                title: title,
                updated: updated,
                authors: authors,
                entries: entries,
                links: links,
                categories: categories,
                contributors: contributors,
                generator: generator,
                icon: icon?.iri,
                logo: logo?.iri,
                rights: rights,
                subtitle: subtitle
            )
        }

        /// Creates a new feed without validation (for internal use, e.g. decoding)
        internal static func makeUnchecked(
            id: String,
            title: Text,
            updated: Date,
            authors: [Person],
            entries: [Entry],
            links: [Link],
            categories: [Category],
            contributors: [Person],
            generator: Generator?,
            icon: String?,
            logo: String?,
            rights: Text?,
            subtitle: Text?
        ) -> Feed {
            Feed(
                uncheckedId: RFC_3987.IRI(unchecked: id),
                uncheckedTitle: title,
                uncheckedUpdated: updated,
                uncheckedAuthors: authors,
                uncheckedEntries: entries,
                uncheckedLinks: links,
                uncheckedCategories: categories,
                uncheckedContributors: contributors,
                uncheckedGenerator: generator,
                uncheckedIcon: icon.map { RFC_3987.IRI(unchecked: $0) },
                uncheckedLogo: logo.map { RFC_3987.IRI(unchecked: $0) },
                uncheckedRights: rights,
                uncheckedSubtitle: subtitle
            )
        }

        private init(
            uncheckedId id: RFC_3987.IRI,
            uncheckedTitle title: Text,
            uncheckedUpdated updated: Date,
            uncheckedAuthors authors: [Person],
            uncheckedEntries entries: [Entry],
            uncheckedLinks links: [Link],
            uncheckedCategories categories: [Category],
            uncheckedContributors contributors: [Person],
            uncheckedGenerator generator: Generator?,
            uncheckedIcon icon: RFC_3987.IRI?,
            uncheckedLogo logo: RFC_3987.IRI?,
            uncheckedRights rights: Text?,
            uncheckedSubtitle subtitle: Text?
        ) {
            self.id = id
            self.title = title
            self.updated = updated
            self.authors = authors
            self.entries = entries
            self.links = links
            self.categories = categories
            self.contributors = contributors
            self.generator = generator
            self.icon = icon
            self.logo = logo
            self.rights = rights
            self.subtitle = subtitle
        }
    }
}
