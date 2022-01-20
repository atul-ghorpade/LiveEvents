import Foundation

protocol EventsProviderProtocol {
    typealias EventsListCompletion = (Result<[EventModel], UseCaseError>) -> Void

    func getEventsList(query: String?,
                       completion: @escaping EventsListCompletion)
}
