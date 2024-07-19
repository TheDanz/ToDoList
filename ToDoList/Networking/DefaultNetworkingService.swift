import Foundation

final class DefaultNetworkingService: NetworkingService, Sendable {
    private static let httpStatusCodeSuccess = 200..<300
    private static let TOKEN = "Tilinion"
    
    func fetchList() async throws -> [ToDoItem] {
        let url = try makeURL()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Self.TOKEN)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.unexpectedResponse(response)
        }
        
        guard Self.httpStatusCodeSuccess.contains(response.statusCode) else {
            throw RequestError.failedResponse(response)
        }
        
        let revisionManager = RevisionManager()
        let serverResponseJSON = try JSONSerialization.jsonObject(with: data)
        guard let serverResponse = ServerResponse.parse(json: serverResponseJSON) else {
            throw RequestError.failedParsing
        }
        revisionManager.updateRevision(from: serverResponse)
        guard let toDoItems = serverResponse.list else {
            throw RequestError.failedParsing
        }
        
        return toDoItems
    }
    
    func updateList(_ list: [ToDoItem]) async throws {
        let url = try makeURL()
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(Self.TOKEN)", forHTTPHeaderField: "Authorization")
        let revisionManager = RevisionManager()
        let currentRevision = String(revisionManager.currentRevision)
        request.setValue(currentRevision, forHTTPHeaderField: "X-Last-Known-Revision")
        let jsonData = try JSONSerialization.data(withJSONObject: ServerResponse(list: list).json)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.unexpectedResponse(response)
        }
        
        guard Self.httpStatusCodeSuccess.contains(response.statusCode) else {
            throw RequestError.failedResponse(response)
        }
        
        let serverResponseJSON = try JSONSerialization.jsonObject(with: data)
        guard let serverResponse = ServerResponse.parse(json: serverResponseJSON) else { return }
        revisionManager.updateRevision(from: serverResponse)
    }
    
    func getElement(by id: String) async throws -> ToDoItem {
        let url = try makeURL(withID: id)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Self.TOKEN)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.unexpectedResponse(response)
        }
        
        guard Self.httpStatusCodeSuccess.contains(response.statusCode) else {
            throw RequestError.failedResponse(response)
        }
        
        let revisionManager = RevisionManager()
        let serverResponseJSON = try JSONSerialization.jsonObject(with: data)
        guard let serverResponse = ServerResponse.parse(json: serverResponseJSON) else {
            throw RequestError.failedParsing
        }
        revisionManager.updateRevision(from: serverResponse)
        guard let toDoItem = serverResponse.element else {
            throw RequestError.failedParsing
        }
        
        return toDoItem
    }
    
    func addElement(_ item: ToDoItem) async throws {
        let url = try makeURL()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Self.TOKEN)", forHTTPHeaderField: "Authorization")
        let revisionManager = RevisionManager()
        let currentRevision = String(revisionManager.currentRevision)
        request.setValue(currentRevision, forHTTPHeaderField: "X-Last-Known-Revision")
        let jsonData = try JSONSerialization.data(withJSONObject: ServerResponse(element: item).json)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.unexpectedResponse(response)
        }
        
        guard Self.httpStatusCodeSuccess.contains(response.statusCode) else {
            throw RequestError.failedResponse(response)
        }
        
        let serverResponseJSON = try JSONSerialization.jsonObject(with: data)
        guard let serverResponse = ServerResponse.parse(json: serverResponseJSON) else { return }
        revisionManager.updateRevision(from: serverResponse)
    }
    
    func updateElement(_ item: ToDoItem) async throws {
        let url = try makeURL(withID: item.id)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(Self.TOKEN)", forHTTPHeaderField: "Authorization")
        let revisionManager = RevisionManager()
        let currentRevision = String(revisionManager.currentRevision)
        request.setValue(currentRevision, forHTTPHeaderField: "X-Last-Known-Revision")
        let jsonData = try JSONSerialization.data(withJSONObject: ServerResponse(element: item).json)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.unexpectedResponse(response)
        }
        
        guard Self.httpStatusCodeSuccess.contains(response.statusCode) else {
            throw RequestError.failedResponse(response)
        }
        
        let serverResponseJSON = try JSONSerialization.jsonObject(with: data)
        guard let serverResponse = ServerResponse.parse(json: serverResponseJSON) else { return }
        revisionManager.updateRevision(from: serverResponse)
    }
    
    func deleteElement(by id: String) async throws {
        let url = try makeURL(withID: id)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(Self.TOKEN)", forHTTPHeaderField: "Authorization")
        let revisionManager = RevisionManager()
        let currentRevision = String(revisionManager.currentRevision)
        request.setValue(currentRevision, forHTTPHeaderField: "X-Last-Known-Revision")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.unexpectedResponse(response)
        }
        
        guard Self.httpStatusCodeSuccess.contains(response.statusCode) else {
            throw RequestError.failedResponse(response)
        }
        
        let serverResponseJSON = try JSONSerialization.jsonObject(with: data)
        guard let serverResponse = ServerResponse.parse(json: serverResponseJSON) else { return }
        revisionManager.updateRevision(from: serverResponse)
    }
    
    func makeURL(withID id: String? = nil) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "hive.mrdekk.ru"
        components.path = "/todo/list/"
        
        if let id = id {
            components.path.append(id)
        }
        
        guard let url = components.url else {
            throw RequestError.wrongURL(components)
        }
        
        return url
    }
}

enum RequestError: Error {
    case wrongURL(URLComponents)
    case unexpectedResponse(URLResponse)
    case failedResponse(HTTPURLResponse)
    case failedParsing
}
