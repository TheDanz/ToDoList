import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        
        return try await withCheckedThrowingContinuation { continuation in
            
            let task = self.dataTask(with: urlRequest) { data, response, error in
                
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let data = data, let response = response else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                    return
                }
                
                continuation.resume(returning: (data, response))
            }
            
            Task {
                await withTaskCancellationHandler {
                    task.resume()
                } onCancel: {
                    task.cancel()
                }
            }
        }
    }
}
