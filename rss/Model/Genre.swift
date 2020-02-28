import Foundation

final class Genre: Codable {

    // MARK: - Properties

    let genreId: String?
	let name: String?
	let url: String?

    // MARK: - Codable

	enum CodingKeys: String, CodingKey {
		case genreId
		case name
		case url
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		genreId = try values.decodeIfPresent(String.self, forKey: .genreId)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}
}
