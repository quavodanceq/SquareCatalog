import Foundation

enum GitHubEndpoint {
    case squareRepos
    
    private var path: String {
        switch self {
        case .squareRepos:
            return "orgs/square/repos"
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .squareRepos:
            return "GET"
        }
    }

    func makeRequest(baseURL: URL, userAgent: String) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        return request
    }
}


