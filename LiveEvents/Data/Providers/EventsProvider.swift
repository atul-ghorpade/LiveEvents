import Foundation

final class EventsProvider: EventsProviderProtocol {
    private let provider: Provider<EventsService>

    convenience init() {
        self.init(provider: Provider<EventsService>())
    }

    init(provider: Provider<EventsService>) {
        self.provider = provider
    }

    func getEventsList(query: String?, completion: @escaping EventsListCompletion) {
        let eventListService = EventsService.eventsList(query: query)
        provider.request(eventListService) { result in
            switch result {
            case let .success(response):
                do {
                    let eventsListEntities = try response.map([EventEntity].self)
                    let eventsListModels = try eventsListEntities.map {
                        try $0.toDomain()
                    }
                    print("Number of events received from service API - \(eventsListModels.count)")
                    completion(.success(eventsListModels))
                } catch {
                    completion(.failure(.mapping(error)))
                }
            case let .failure(error):
                completion(.failure(.network(.generic(error))))
            }
        }
    }
}
