@testable import LiveEvents

final class EventsListRouterMock: EventsListRouterProtocol {
    var showEventDetailsCalled = false
    var model: EventModel?

    func showEventDetails(model: EventModel) {
        showEventDetailsCalled = true
        self.model = model
    }
}
