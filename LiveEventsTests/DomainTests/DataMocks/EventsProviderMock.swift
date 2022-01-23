@testable import LiveEvents

final class EventsProviderMock: EventsProviderProtocol {
    var eventsListResult: Result<EventsInfoModel, UseCaseError>?

    func getEventsList(query: String?,
                       page: Int,
                       completion: @escaping EventsListCompletion) {
        guard let eventsListResult = eventsListResult else {
            fatalError("Result not provided")
        }
        completion(eventsListResult)
    }
}
