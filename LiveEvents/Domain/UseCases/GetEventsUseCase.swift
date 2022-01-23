struct GetEventsParams {
    typealias Completion = (Result<EventsInfoModel, UseCaseError>) -> Void

    let query: String?
    let page: Int
    let completion: Completion
    
    init(query: String? = nil,
         page: Int = 1,
         completion: @escaping Completion) {
        self.query = query
        self.page = page
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
        provider.getEventsList(query: params.query,
                               page: params.page) { result in
            params.completion(result)
        }
    }
}
