import SwiftUI
import CocoaLumberjackSwift

@main
struct ToDoListApp: App {
    
    init() {
        setupLogging()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    
    private func setupLogging() {
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24 * 7)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
}
