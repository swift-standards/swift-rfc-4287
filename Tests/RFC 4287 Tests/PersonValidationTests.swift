import RFC_2822
import Testing

@testable import RFC_4287

@Suite("Person Email Validation")
struct PersonValidationTests {

    @Test("Person with valid email succeeds")
    func validEmail() throws {
        let email = try RFC_2822.AddrSpec(localPart: "john", domain: "example.com")
        let person = RFC_4287.Person(name: "John Doe", uri: nil, email: email)

        #expect(person.name == "John Doe")
        #expect(person.email?.description == "john@example.com")
    }

    @Test("Person with nil email succeeds")
    func nilEmail() {
        let person = RFC_4287.Person(name: "Jane Doe", uri: nil, email: nil)

        #expect(person.name == "Jane Doe")
        #expect(person.email == nil)
    }

    @Test("Person with URI and email")
    func withURIAndEmail() throws {
        let email = try RFC_2822.AddrSpec(localPart: "contact", domain: "example.org")
        let person = RFC_4287.Person(
            name: "Contact Person",
            uri: "https://example.org",
            email: email
        )

        #expect(person.name == "Contact Person")
        #expect(person.uri == "https://example.org")
        #expect(person.email?.description == "contact@example.org")
    }

    @Test("Person with convenience emailString initializer")
    func emailStringInit() throws {
        let person = try RFC_4287.Person(
            name: "Test User",
            uri: nil,
            emailString: "test@example.com"
        )

        #expect(person.name == "Test User")
        #expect(person.email?.description == "test@example.com")
    }

    @Test("Invalid email string throws")
    func invalidEmailString() {
        #expect(throws: RFC_2822.ValidationError.self) {
            try RFC_4287.Person(
                name: "Invalid",
                uri: nil,
                emailString: "not-an-email"
            )
        }
    }

    @Test("Email with special characters in local-part")
    func specialCharactersEmail() throws {
        let email = try RFC_2822.AddrSpec(localPart: "user+tag", domain: "example.com")
        let person = RFC_4287.Person(name: "Tagged User", uri: nil, email: email)

        #expect(person.email?.description == "user+tag@example.com")
    }

    @Test("Email with subdomain")
    func subdomainEmail() throws {
        let email = try RFC_2822.AddrSpec(localPart: "admin", domain: "mail.example.com")
        let person = RFC_4287.Person(name: "Admin", uri: nil, email: email)

        #expect(person.email?.description == "admin@mail.example.com")
    }
}

@Suite("Person Codable with Email")
struct PersonCodableTests {

    @Test("Encode Person with email")
    func encodeWithEmail() throws {
        let email = try RFC_2822.AddrSpec(localPart: "test", domain: "example.com")
        let person = RFC_4287.Person(name: "Test", uri: nil, email: email)

        let encoder = JSONEncoder()
        let data = try encoder.encode(person)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"name\":\"Test\""))
        #expect(json.contains("\"email\":\"test@example.com\""))
    }

    @Test("Decode Person with email")
    func decodeWithEmail() throws {
        let json = """
            {"name":"Decoder","email":"decode@example.com"}
            """

        let decoder = JSONDecoder()
        let person = try decoder.decode(RFC_4287.Person.self, from: json.data(using: .utf8)!)

        #expect(person.name == "Decoder")
        #expect(person.email?.description == "decode@example.com")
    }

    @Test("Decode Person without email")
    func decodeWithoutEmail() throws {
        let json = """
            {"name":"No Email"}
            """

        let decoder = JSONDecoder()
        let person = try decoder.decode(RFC_4287.Person.self, from: json.data(using: .utf8)!)

        #expect(person.name == "No Email")
        #expect(person.email == nil)
    }

    @Test("Decode Person with invalid email format throws")
    func decodeInvalidEmail() {
        let json = """
            {"name":"Bad","email":"invalid"}
            """

        let decoder = JSONDecoder()
        #expect(throws: DecodingError.self) {
            _ = try decoder.decode(RFC_4287.Person.self, from: json.data(using: .utf8)!)
        }
    }

    @Test("Round-trip encoding preserves email")
    func roundTrip() throws {
        let email = try RFC_2822.AddrSpec(localPart: "round", domain: "trip.com")
        let original = RFC_4287.Person(name: "Round Trip", uri: "https://trip.com", email: email)

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(RFC_4287.Person.self, from: data)

        #expect(decoded.name == original.name)
        #expect(decoded.uri == original.uri)
        #expect(decoded.email?.description == original.email?.description)
    }
}

@Suite("Person IRI.Representable Integration")
struct PersonIRIIntegrationTests {

    @Test("Person with IRI from string literal")
    func iriFromStringLiteral() throws {
        let iri: RFC_3987.IRI = "https://example.com/~user"
        let email = try RFC_2822.AddrSpec(localPart: "user", domain: "example.com")
        let person = RFC_4287.Person(name: "User", uri: iri, email: email)

        #expect(person.uri == "https://example.com/~user")
    }

    @Test("Person with Foundation URL via IRI.Representable")
    func foundationURLSupport() throws {
        let url = URL(string: "https://example.com/~user")!
        let email = try RFC_2822.AddrSpec(localPart: "user", domain: "example.com")
        let person = RFC_4287.Person(name: "User", uri: url, email: email)

        #expect(person.uri == "https://example.com/~user")
    }
}
