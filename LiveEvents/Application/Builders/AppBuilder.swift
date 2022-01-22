//

import Foundation

final class AppBuilder {
    func buildEventsList() -> EventsListBuilder  {
        return EventsListBuilder()
    }
}
