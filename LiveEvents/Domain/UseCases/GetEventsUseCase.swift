struct GetEventsParams {
    typealias Completion = (Result<[EventModel], UseCaseError>) -> Void

    let query: String?
    let completion: Completion
    
    init(query: String? = nil,
         completion: @escaping Completion) {
        self.query = query
        self.completion = completion
    }
}

protocol GetEventsUseCaseProtocol {
    func run(_ params: GetEventsParams)
}

final class GetEventsUseCase: GetEventsUseCaseProtocol {
    private let provider: EventsProviderProtocol!

    init(provider: EventsProviderProtocol) {
        self.provider = provider
    }

    func run(_ params: GetEventsParams) {
        provider.getEventsList(query: params.query) { result in
            params.completion(result)
        }
    }
}
