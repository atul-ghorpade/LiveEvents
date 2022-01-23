@testable import LiveEvents

final class EventsListViewMock: EventsListView {
    var presenter: EventsListPresenterProtocol!
    var viewState: EventsListViewState?

    func changeViewState(viewState: EventsListViewState) {
        self.viewState = viewState
    }
}
