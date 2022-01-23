import Foundation

protocol EventsProviderProtocol {
    typealias EventsListCompletion = (Result<EventsInfoModel, UseCaseError>) -> Void

    func getEventsList(query: String?,
                       page: Int,
                       completion: @escaping EventsListCompletion)
}
