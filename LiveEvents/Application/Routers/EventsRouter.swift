import UIKit

final class EventsRouter {
    private weak var navigationController: UINavigationController?
    private weak var eventsListViewController: UIViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let eventsListViewController = EventsListBuilder().buildEventsListView(router: self) as? UIViewController else {
            fatalError("EventsListViewController not built")
        }
        navigationController?.pushViewController(eventsListViewController, animated: false)
        self.eventsListViewController = eventsListViewController
    }
}

protocol EventsListRouterProtocol: AnyObject {
    func showEventDetails(model: EventModel)
}

protocol EventDetailsRouterProtocol: AnyObject {
    func goBack()
}

extension EventsRouter: EventsListRouterProtocol {
    func showEventDetails(model: EventModel) {
        guard let eventDetailsViewController = EventDetailsBuilder().buildEventDetailsView(router: self,
                                                                                                       eventModel: model) as? UIViewController else {
            fatalError("EventDetailsViewController not built")
        }
        navigationController?.pushViewController(eventDetailsViewController,
                                                 animated: true)
    }
}

extension EventsRouter: EventDetailsRouterProtocol {
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

