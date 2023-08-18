import Combine
import Foundation

// An ultra-simple debouncing push-button / toaster / egg-timer style timer which starts when pushed and fires its callback when it is done. Pushing it again restarts it.
final class PopTimer {
    private let publisher = CurrentValueSubject<Bool, Never>(false)
    private var observation: Cancellable?

    /// Start the timer. If the timer is already running, reset the time interval.
    func push() {
        publisher.send(true)
    }

    /// Abort the timer so that it doesn't fire the callback when done.
    func abort() {
        publisher.send(false)
    }

    /// Has the timer been pushed already (i.e. is it ticking?)
    var isPushed: Bool {
        publisher.value
    }
    
    /// Create a new timer. The timer does not start until ``push()`` is called.
    /// - Parameters:
    ///   - timeInterval: The time interval that the timer needs to wait since the most recent push to fire the callback
    ///   - callback: The code to run when the timer is done. This can be an async block. The block will run in the thread in which the timer was created unless otherwise specified (for instance, with @MainActor).
    init(timeInterval: TimeInterval, callback: @escaping () async -> Void) {
        let stride = RunLoop.SchedulerTimeType.Stride(timeInterval)
        observation = publisher.debounce(for: stride, scheduler: RunLoop.current).sink { value in
            guard value else { return }
            Task {
                await callback()
            }
        }
    }
}
