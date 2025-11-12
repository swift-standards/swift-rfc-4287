import Foundation
import RFC_3987

extension RFC_4287 {
    /// An Atom entry as defined in RFC 4287 Section 4.1.2
    ///
    /// Represents an individual entry in an Atom feed.
    public struct Entry: Hashable, Sendable, Codable {
        /// Entry authors (at least one required if feed has no authors)
        public let authors: [Author]

        /// Entry categories
        public let categories: [Category]

        /// Entry content
        public let content: Content?

        /// Entry contributors
        public let contributors: [Contributor]

        /// Permanent, universally unique identifier (required)
        ///
        /// Per RFC 4287 Section 4.2.6, this MUST be an IRI reference.
        /// It MUST be permanent and universally unique, and MUST NOT change.
        public let id: RFC_3987.IRI

        /// Links associated with the entry
        public let links: [Link]

        /// Timestamp of last significant modification (required)
        public let updated: Date

        /// Timestamp of initial creation or publication (optional)
        public let published: Date?

        /// Copyright and licensing information (optional)
        public let rights: Rights?

        /// Source feed metadata (optional)
        public let source: Source?

        /// Summary or excerpt (optional)
        public let summary: Summary?

        /// Human-readable title (required)
        public let title: Title

        /// Base IRI for resolving relative references (xml:base)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:base attribute.
        public let base: RFC_3987.IRI?

        /// Language of the entry content (xml:lang)
        ///
        /// Per RFC 4287 Section 2, any element may have an xml:lang attribute.
        public let lang: String?

        /// Creates a new entry with validation
        ///
        /// - Parameters:
        ///   - id: Permanent, universally unique identifier
        ///   - title: Human-readable title
        ///   - updated: Timestamp of last modification
        ///   - authors: Entry authors
        ///   - content: Entry content
        ///   - links: Associated links
        ///   - categories: Entry categories
        ///   - contributors: Entry contributors
        ///   - published: Publication timestamp
        ///   - rights: Rights information
        ///   - source: Source feed metadata
        ///   - summary: Entry summary
        ///   - base: Base IRI for resolving relative references
        ///   - lang: Language of the entry content
        ///
        /// - Returns: A validated entry, or nil if validation fails
        public init?(
            id: RFC_3987.IRI,
            title: Title,
            updated: Date,
            authors: [Author] = [],
            content: Content? = nil,
            links: [Link] = [],
            categories: [Category] = [],
            contributors: [Contributor] = [],
            published: Date? = nil,
            rights: Rights? = nil,
            source: Source? = nil,
            summary: Summary? = nil,
            base: RFC_3987.IRI? = nil,
            lang: String? = nil
        ) {
            // RFC 4287 Section 4.1.2: Entry must have content OR an alternate link
            let hasContent = content != nil
            let hasAlternateLink = links.contains { $0.isAlternate }

            guard hasContent || hasAlternateLink else {
                return nil
            }

            // RFC 4287 Section 4.2.13: Summary is REQUIRED when:
            // 1. Content has src attribute (out-of-line content), OR
            // 2. Content is base64-encoded (binary MIME type)
            if let content = content {
                let summaryRequired = content.src != nil || content.requiresBase64Encoding
                if summaryRequired && summary == nil {
                    return nil
                }
            }

            self.id = id
            self.title = title
            self.updated = updated
            self.authors = authors
            self.content = content
            self.links = links
            self.categories = categories
            self.contributors = contributors
            self.published = published
            self.rights = rights
            self.source = source
            self.summary = summary
            self.base = base
            self.lang = lang
        }

        /// Creates a new entry with validation using IRI.Representable id (convenience)
        ///
        /// Accepts any IRI.Representable type such as Foundation URL.
        ///
        /// - Parameters:
        ///   - id: Permanent, universally unique identifier (e.g., URL)
        ///   - title: Human-readable title
        ///   - updated: Timestamp of last modification
        ///   - authors: Entry authors
        ///   - content: Entry content
        ///   - links: Associated links
        ///   - categories: Entry categories
        ///   - contributors: Entry contributors
        ///   - published: Publication timestamp
        ///   - rights: Rights information
        ///   - source: Source feed metadata
        ///   - summary: Entry summary
        ///   - base: Base IRI for resolving relative references (e.g., URL)
        ///   - lang: Language of the entry content
        ///
        /// - Returns: A validated entry, or nil if validation fails
        public init?(
            id: any RFC_3987.IRI.Representable,
            title: Title,
            updated: Date,
            authors: [Author] = [],
            content: Content? = nil,
            links: [Link] = [],
            categories: [Category] = [],
            contributors: [Contributor] = [],
            published: Date? = nil,
            rights: Rights? = nil,
            source: Source? = nil,
            summary: Summary? = nil,
            base: (any RFC_3987.IRI.Representable)? = nil,
            lang: String? = nil
        ) {
            self.init(
                id: id.iri,
                title: title,
                updated: updated,
                authors: authors,
                content: content,
                links: links,
                categories: categories,
                contributors: contributors,
                published: published,
                rights: rights,
                source: source,
                summary: summary,
                base: base?.iri,
                lang: lang
            )
        }

        /// Creates a new entry without validation (for internal use, e.g. decoding)
        internal static func makeUnchecked(
            id: String,
            title: Title,
            updated: Date,
            authors: [Author],
            content: Content?,
            links: [Link],
            categories: [Category],
            contributors: [Contributor],
            published: Date?,
            rights: Rights?,
            source: Source?,
            summary: Summary?,
            base: String?,
            lang: String?
        ) -> Entry {
            Entry(
                uncheckedId: RFC_3987.IRI(unchecked: id),
                uncheckedTitle: title,
                uncheckedUpdated: updated,
                uncheckedAuthors: authors,
                uncheckedContent: content,
                uncheckedLinks: links,
                uncheckedCategories: categories,
                uncheckedContributors: contributors,
                uncheckedPublished: published,
                uncheckedRights: rights,
                uncheckedSource: source,
                uncheckedSummary: summary,
                uncheckedBase: base.map { RFC_3987.IRI(unchecked: $0) },
                uncheckedLang: lang
            )
        }

        private init(
            uncheckedId id: RFC_3987.IRI,
            uncheckedTitle title: Title,
            uncheckedUpdated updated: Date,
            uncheckedAuthors authors: [Author],
            uncheckedContent content: Content?,
            uncheckedLinks links: [Link],
            uncheckedCategories categories: [Category],
            uncheckedContributors contributors: [Contributor],
            uncheckedPublished published: Date?,
            uncheckedRights rights: Rights?,
            uncheckedSource source: Source?,
            uncheckedSummary summary: Summary?,
            uncheckedBase base: RFC_3987.IRI?,
            uncheckedLang lang: String?
        ) {
            self.id = id
            self.title = title
            self.updated = updated
            self.authors = authors
            self.content = content
            self.links = links
            self.categories = categories
            self.contributors = contributors
            self.published = published
            self.rights = rights
            self.source = source
            self.summary = summary
            self.base = base
            self.lang = lang
        }
    }
}
