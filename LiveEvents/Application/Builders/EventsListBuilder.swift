//

import Foundation

final class EventsListBuilder {
    func buildEventsListView(router: EventsListRouterProtocol) -> EventsListView {
        let eventsListView = EventsListViewController.instantiate()
        eventsListView.presenter = buildEventsListPresenter(view:
                                                                eventsListView,
                                                            router: router)
        return eventsListView
    }

    private func buildEventsListPresenter(view: EventsListView,
                                          router: EventsListRouterProtocol)-> EventsListPresenterProtocol {
        let getEventsUseCaseProtocol = buildGetEventsUseCase()
        return EventsListPresenter(view: view,
                                   getEventsUseCase: getEventsUseCaseProtocol,
                                   router: router)
    }

    private func buildGetEventsUseCase() -> GetEventsUseCaseProtocol {
        let providerProtocol = EventsProvider()
        return GetEventsUseCase(provider: providerProtocol)
    }
}
