
extension Date {
    /// Formats the date according to RFC 3339 (used by Atom)
    ///
    /// - Returns: ISO 8601 formatted date string
    public func atomFormatted() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }

    /// Creates a date from an RFC 3339 formatted string
    ///
    /// - Parameter atomString: The RFC 3339 date string
    /// - Throws: ValidationError if the string cannot be parsed
    public init(atomString: String) throws {
        let formatter = ISO8601DateFormatter()

        // Try with fractional seconds first
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: atomString) {
            self = date
            return
        }

        // Try without fractional seconds
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: atomString) {
            self = date
            return
        }

        throw RFC_4287.ValidationError.invalidDateFormat(atomString)
    }
}
