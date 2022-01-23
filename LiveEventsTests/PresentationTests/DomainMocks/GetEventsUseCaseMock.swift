@testable import LiveEvents

final class GetEventsUseCaseMock: GetEventsUseCaseProtocol {
    var result: Result<EventsInfoModel, UseCaseError>?

    func run(_ params: GetEventsParams) {
        guard let result = result else {
            fatalError("Result not provided to mock")
        }
        params.completion(result)
    }
}
