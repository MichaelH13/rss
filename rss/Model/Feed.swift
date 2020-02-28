import Foundation

final class Feed: Codable {
	let title: String?
	let id: String?
	let author: Author?
	let copyright: String?
	let country: String?
	let icon: String?
	let updated: String?
	let albums: [Album]?

    // MARK: - Codable

	enum CodingKeys: String, CodingKey {
		case title = "title"
		case id = "id"
		case author = "author"
		case copyright = "copyright"
		case country = "country"
		case icon = "icon"
		case updated = "updated"
		case albums = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		author = try values.decodeIfPresent(Author.self, forKey: .author)
		copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
		country = try values.decodeIfPresent(String.self, forKey: .country)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
		updated = try values.decodeIfPresent(String.self, forKey: .updated)
		albums = try values.decodeIfPresent([Album].self, forKey: .albums)
	}
}
