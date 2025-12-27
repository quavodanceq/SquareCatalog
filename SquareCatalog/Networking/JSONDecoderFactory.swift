import Foundation

struct JSONDecoderFactory {
    func makeGitHubAPIDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}


