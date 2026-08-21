extension RFC_4287.Text {

    public enum ContentType: String, Hashable, Sendable, Codable {
        case text
        case html
        case xhtml
    }
}
