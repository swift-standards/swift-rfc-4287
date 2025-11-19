import Testing

@testable import RFC_4287

@Suite
struct `Date Formatting Tests` {
    @Test func dateToAtomString() async throws {
        let date = Date(timeIntervalSince1970: 1_609_459_200)  // 2021-01-01 00:00:00 UTC

        let formatted = date.atomFormatted()

        // Should be ISO 8601 format
        #expect(formatted.contains("2021-01-01"))
        #expect(formatted.contains("T"))
        #expect(formatted.contains("Z"))
    }

    @Test func atomStringToDate() async throws {
        let dateString = "2021-01-01T00:00:00Z"

        let date = try Date(atomString: dateString)

        #expect(date.timeIntervalSince1970 == 1_609_459_200)
    }

    @Test func atomStringWithFractionalSeconds() async throws {
        let dateString = "2021-01-01T00:00:00.123Z"

        let date = try Date(atomString: dateString)

        #expect(date.timeIntervalSince1970 > 0)
    }

    @Test func roundTripDateFormatting() async throws {
        let originalDate = Date(timeIntervalSince1970: 1_609_459_200)

        let formatted = originalDate.atomFormatted()
        let parsedDate = try Date(atomString: formatted)

        // Should be equal within a second (accounting for fractional seconds)
        let difference = abs(originalDate.timeIntervalSince1970 - parsedDate.timeIntervalSince1970)
        #expect(difference < 1.0)
    }

    @Test func invalidDateStringThrows() async throws {
        let invalidString = "not a date"

        #expect(throws: RFC_4287.ValidationError.self) {
            try Date(atomString: invalidString)
        }
    }

    @Test func variousRFC3339Formats() async throws {
        let formats = [
            "2021-01-01T00:00:00Z",
            "2021-01-01T00:00:00.000Z",
            "2021-01-01T12:30:45Z",
            "2021-12-31T23:59:59Z",
        ]

        for format in formats {
            let date = try Date(atomString: format)
            #expect(date.timeIntervalSince1970 > 0)
        }
    }
}
