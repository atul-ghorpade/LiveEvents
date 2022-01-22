//

import Foundation

final class EventDetailsBuilder {
    func buildEventDetailsView(router: EventDetailsRouterProtocol,
                               eventModel: EventModel) -> EventDetailsView {
        let eventDetailsView = EventDetailsViewController.instantiate()
        eventDetailsView.presenter = buildEventDetailsPresenter(view: eventDetailsView,
                                                                router: router,
                                                                eventModel: eventModel)
        return eventDetailsView
    }

    private func buildEventDetailsPresenter(view: EventDetailsView,
                                            router: EventDetailsRouterProtocol,
                                            eventModel: EventModel) -> EventDetailsPresenterProtocol {
        return EventDetailsPresenter(view: view,
                                     router: router,
                                     eventModel: eventModel)
    }
}
