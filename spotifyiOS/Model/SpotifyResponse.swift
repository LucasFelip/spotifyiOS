import Foundation

struct SpotifyAPIResponse: Codable {
    let href: String
    let items: [Item]
}

struct Item: Codable {
    let added_at: String
    let track: Track
}

struct Track: Codable {
    let album: Album
    let artists: [Artist]
    let duration_ms: Int
    let name: String
    let popularity: Int
    let external_urls: ExternalURLs
}

struct Album: Codable {
    let images: [Image]
    let name: String
}

struct Artist: Codable {
    let name: String
}

struct Image: Codable {
    let url: String
}

struct ExternalURLs: Codable {
    let spotify: String
}

struct TokenResponse: Codable {
    let access_token: String
}
