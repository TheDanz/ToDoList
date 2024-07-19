import Foundation

class RevisionManager {
    private let revisionKey = "1"
    
    var currentRevision: Int {
        get {
            return UserDefaults.standard.integer(forKey: revisionKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: revisionKey)
        }
    }
    
    func updateRevision(from response: ServerResponse) {
        self.currentRevision = response.revision ?? Int(revisionKey)!
    }
}
