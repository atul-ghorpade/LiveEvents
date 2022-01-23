@testable import LiveEvents

final class EventDetailsViewMock: EventDetailsView {
    var presenter: EventDetailsPresenterProtocol!
    var viewState: EventDetailsViewState?

    func changeViewState(viewState: EventDetailsViewState) {
        self.viewState = viewState
    }
}
