import Foundation

enum EventsService {
    case eventsList(query: String?)
}

extension EventsService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.seatgeek.com/2/" + servicePath)!
    }

    var servicePath: String {
        "events"
    }

    var path: String {
        switch self {
        case .eventsList:
            return "/dummy-response.json"
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .eventsList(let query):
            return ["q": query ?? "",
                    "client_id" : "clientID"]
        }
    }

    var method: Method {
        switch self {
        case .eventsList:
            return .get
        }
    }

    var task: Task {
        return .requestPlain
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
