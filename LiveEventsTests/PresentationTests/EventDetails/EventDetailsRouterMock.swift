@testable import LiveEvents

final class EventDetailsRouterMock: EventDetailsRouterProtocol {
    var goBackCalled = false

    func goBack() {
        goBackCalled = true
    }
}
