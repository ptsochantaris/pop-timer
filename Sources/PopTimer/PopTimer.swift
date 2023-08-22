import Combine
import Foundation

/// An ultra-simple debouncing push-button / toaster / egg-timer style timer, which starts when pushed and fires its callback when it is done. Pushing it at any point restarts it.
public final class PopTimer {
    private let publisher = CurrentValueSubject<Bool, Never>(false)
    private let observation: Cancellable

    /// Start the timer. If the timer is already running, reset the time interval.
    public func push() {
        publisher.send(true)
    }

    /// Abort the timer so that it doesn't fire the callback when done.
    public func abort() {
        publisher.send(false)
    }

    /// Has the timer been pushed already (i.e. is it ticking?)
    public var isPushed: Bool {
        publisher.value
    }

    /// Create a new timer. The timer does not start until ``push()`` is called.
    /// - Parameters:
    ///   - timeInterval: The time interval that the timer needs to wait since the most recent push to fire the callback
    ///   - callback: The code to run when the timer is done. This can be an async block. The block will call back on @MainActor.
    public init(timeInterval: TimeInterval, callback: @escaping @MainActor () async -> Void) {
        let stride = RunLoop.SchedulerTimeType.Stride(timeInterval)
        observation = publisher
            .debounce(for: stride, scheduler: RunLoop.main)
            .sink {
                if $0 {
                    Task {
                        await callback()
                    }
                }
            }
    }
}
