import Foundation

enum EventsService {
    case eventsList(query: String?, page: Int)
}

extension EventsService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.seatgeek.com/2/")!
    }

    var servicePath: String {
        "events"
    }

    var path: String {
        switch self {
        case .eventsList:
            return "events"
        }
    }
    
    var task: Task {
        switch self {
        case .eventsList(let query, let page):
            var requestParamters: [String: Any] = [:]
            requestParamters["client_id"] = "MjM5NzYxMjV8MTYzNDU0MjY4NC4xNzk3Mzgz"
            requestParamters["page"] = page
            if let query = query, query != "" {
                requestParamters["q"] = query
            }
            return .requestParameters(parameters: requestParamters,
                                      encoding: URLEncoding.queryString)
        }
    }

    var method: Method {
        switch self {
        case .eventsList:
            return .get
        }
    }

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    var mockResource: String {
        switch self {
        case .eventsList:
            return "EventsList"
        }
    }

    var mockResourceExtension: String {
        return "json"
    }
}
