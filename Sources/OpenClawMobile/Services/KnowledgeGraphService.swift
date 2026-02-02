import Foundation

// MARK: - Knowledge Graph Service

@MainActor
final class KnowledgeGraphService: ObservableObject {
    private let config: AppConfiguration

    @Published var entities: [Entity] = []
    @Published var tasks: [AgentTask] = []
    @Published var stats: KGStats?
    @Published var searchResults: [SearchResult] = []
    @Published var isLoading: Bool = false
    @Published var error: String?

    init(config: AppConfiguration) {
        self.config = config
    }

    // MARK: - Stats

    func fetchStats() async -> KGStats? {
        guard config.isKGConfigured else { return nil }
        do {
            let data = try await request(path: "/api/stats")
            let stats = try JSONDecoder().decode(KGStats.self, from: data)
            self.stats = stats
            config.kgConnected = true
            return stats
        } catch {
            config.kgConnected = false
            self.error = error.localizedDescription
            return nil
        }
    }

    // MARK: - Entities

    func fetchEntities(type: String? = nil) async {
        guard config.isKGConfigured else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            var path = "/api/entities"
            if let type = type {
                path += "?type=\(type)"
            }
            let data = try await request(path: path)
            entities = try JSONDecoder().decode([Entity].self, from: data)
        } catch {
            self.error = "Failed to fetch entities: \(error.localizedDescription)"
        }
    }

    // MARK: - Entity Detail

    func fetchEntity(name: String) async -> Entity? {
        guard config.isKGConfigured else { return nil }
        do {
            let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? name
            let data = try await request(path: "/api/entity/\(encodedName)")
            return try JSONDecoder().decode(Entity.self, from: data)
        } catch {
            self.error = "Failed to fetch entity: \(error.localizedDescription)"
            return nil
        }
    }

    // MARK: - Tasks

    func fetchTasks(status: String? = nil) async {
        guard config.isKGConfigured else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            var path = "/api/tasks"
            if let status = status {
                path += "?status=\(status)"
            }
            let data = try await request(path: path)
            tasks = try JSONDecoder().decode([AgentTask].self, from: data)
        } catch {
            self.error = "Failed to fetch tasks: \(error.localizedDescription)"
        }
    }

    // MARK: - Relationships

    func fetchRelationships(entity: String) async -> [Relationship] {
        guard config.isKGConfigured else { return [] }
        do {
            let encoded = entity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? entity
            let data = try await request(path: "/api/relationships?entity=\(encoded)")
            return try JSONDecoder().decode([Relationship].self, from: data)
        } catch {
            self.error = "Failed to fetch relationships: \(error.localizedDescription)"
            return []
        }
    }

    // MARK: - Graph

    func fetchGraph() async -> GraphData? {
        guard config.isKGConfigured else { return nil }
        do {
            let data = try await request(path: "/api/graph")
            return try JSONDecoder().decode(GraphData.self, from: data)
        } catch {
            self.error = "Failed to fetch graph: \(error.localizedDescription)"
            return nil
        }
    }

    // MARK: - Search

    func search(query: String) async {
        guard config.isKGConfigured, !query.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            let data = try await request(path: "/api/search?q=\(encoded)")
            searchResults = try JSONDecoder().decode([SearchResult].self, from: data)
        } catch {
            self.error = "Failed to search: \(error.localizedDescription)"
        }
    }

    // MARK: - Network Request

    private func request(path: String) async throws -> Data {
        let urlString = config.normalizedKGURL + path
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("Bearer \(config.kgAPIToken)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.timeoutInterval = 30

        let (data, response) = try await URLSession.shared.data(for: req)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(
                domain: "KnowledgeGraphService",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode): \(errorBody)"]
            )
        }

        return data
    }
}
