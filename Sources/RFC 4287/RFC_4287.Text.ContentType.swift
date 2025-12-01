//
//  File.swift
//  swift-rfc-4287
//
//  Created by Coen ten Thije Boonkkamp on 01/12/2025.
//

extension RFC_4287.Text {
    /// The type of text content
    public enum ContentType: String, Hashable, Sendable, Codable {
        case text
        case html
        case xhtml
    }
}
