import Foundation

final class EventsProvider: EventsProviderProtocol {
    private let provider: Provider<EventsService>

    convenience init() {
        self.init(provider: Provider<EventsService>())
    }

    init(provider: Provider<EventsService>) {
        self.provider = provider
    }

    func getEventsList(query: String?,
                       page: Int,
                       completion: @escaping EventsListCompletion) {
        let eventListService = EventsService.eventsList(query: query,
                                                        page: page)
        provider.request(eventListService) { result in
            switch result {
            case let .success(response):
                do {
                    let eventsInfoEntity = try response.map(EventsInfoEntity.self)
                    let eventsInfoModel = try eventsInfoEntity.toDomain()
                    completion(.success(eventsInfoModel))
                } catch {
                    print(error)
                    completion(.failure(.mapping(error)))
                }
            case let .failure(error):
                completion(.failure(.network(.generic(error))))
            }
        }
    }
}
