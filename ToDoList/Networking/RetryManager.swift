import Foundation
import CocoaLumberjackSwift

struct RetryConfig {
    let minDelay: TimeInterval
    let maxDelay: TimeInterval
    let factor: Double
    let jitter: Double
}

actor RetryManager {
    private var retryConfig: RetryConfig
    private var currentDelay: TimeInterval
    
    init(retryConfig: RetryConfig) {
        self.retryConfig = retryConfig
        self.currentDelay = retryConfig.minDelay
    }
    
    func executeWithRetry<T: Sendable>(operation: @escaping () async throws -> T) async throws -> T {
        while true {
            do {
                let result = try await operation()
                return result
            } catch {
                DDLogVerbose("\(Date()): Operation failed, retrying in \(nextDelay) seconds. Error: \(error)")
                try await Task.sleep(nanoseconds: UInt64(nextDelay * 1_000_000_000))
            }
        }
    }
    
    private var nextDelay: TimeInterval {
        let jitterValue = Double.random(in: 0..<retryConfig.jitter*2) - retryConfig.jitter
        let delayWithJitter = currentDelay * (1 + jitterValue)
        currentDelay = min(currentDelay * retryConfig.factor, retryConfig.maxDelay)
        
        return delayWithJitter
    }
}
