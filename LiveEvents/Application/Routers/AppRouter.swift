//

import Foundation
import UIKit

final class AppRouter {
    private let navigationController: UINavigationController
    private let appBuilder: AppBuilder
    private var eventsRouter: EventsRouter?

    init(navigationController: UINavigationController,
         appBuilder: AppBuilder) {
        self.navigationController = navigationController
        self.appBuilder = appBuilder
    }

    func start() {
        let eventsRouter = EventsRouter(navigationController: navigationController)
        eventsRouter.start()
        self.eventsRouter = eventsRouter
    }
}
