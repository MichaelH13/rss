import Foundation

struct Feed: Codable {
	let title: String?
	let id: String?
	let author: Author?
	let copyright: String?
	let country: String?
	let icon: String?
	let updated: String?
	let results: [Results]?

	enum CodingKeys: String, CodingKey {
		case title
		case id
		case author
		case copyright
		case country
		case icon
		case updated
		case results
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
		results = try values.decodeIfPresent([Results].self, forKey: .results)
	}

}
