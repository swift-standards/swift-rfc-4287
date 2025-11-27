@_exported import RFC_3987

/// RFC 4287: The Atom Syndication Format
///
/// This module implements the Atom Syndication Format as specified in RFC 4287.
/// Atom is an XML-based document format for web feeds, providing a standardized
/// way to syndicate and aggregate web content.
///
/// This module re-exports RFC 3987 (IRI) types for convenience, as IRIs are
/// fundamental to the Atom format.
public enum RFC_4287 {
    /// Errors that can occur when validating or parsing Atom documents
    public enum Error: Swift.Error, Hashable, Sendable {
        case feedRequiresAuthors
        case entryRequiresContentOrAlternateLink
        case invalidDateFormat(String)
        case invalidXML(String)
        case missingRequiredElement(String)
        case invalidElementValue(String, String)
    }
}
