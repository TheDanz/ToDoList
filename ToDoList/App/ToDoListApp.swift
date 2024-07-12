import SwiftUI
import CocoaLumberjackSwift

@main
struct ToDoListApp: App {
    init() {
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24 * 7)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
