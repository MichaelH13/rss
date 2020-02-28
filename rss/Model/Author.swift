import Foundation

final class Author: Codable {

    // MARK: - Properties

    let name: String?

    let uri: String?

    // MARK: - Codable

	enum CodingKeys: String, CodingKey {
		case name
		case uri
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		uri = try values.decodeIfPresent(String.self, forKey: .uri)
	}
}
