import Foundation
@testable import Frames

class NotificationCenterMock: NotificationCenter {
    var handlers: [NotificationHandlers] = []
    override func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object: Any?) {
        guard let name = name else {
            assertionFailure("name is nil")
            return
        }
        handlers.append(NotificationHandlers(
            observer: observer,
            selector: selector,
            name: name,
            object: object))
    }

    override func removeObserver(_ observer: Any, name: NSNotification.Name?, object: Any?) {
        handlers = handlers.filter { handler in
            return handler.name != name
        }
    }
}

class NotificationHandlers {
    let observer: Any
    let selector: Selector
    let name: NSNotification.Name
    let object: Any?

    public init(observer: Any, selector: Selector, name: NSNotification.Name, object: Any?) {
        self.observer = observer
        self.selector = selector
        self.name = name
        self.object = object
    }
}
