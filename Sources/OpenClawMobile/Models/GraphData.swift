import Foundation

// MARK: - Graph Data

struct GraphData: Codable, Sendable {
    let nodes: [GraphNode]
    let edges: [GraphEdge]
}

// MARK: - Graph Node

struct GraphNode: Codable, Identifiable, Sendable {
    let id: Int
    let name: String
    let type: String
    let factCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, type
        case factCount = "fact_count"
    }
}

// MARK: - Graph Edge

struct GraphEdge: Codable, Identifiable, Sendable {
    let id: Int
    let source: Int
    let target: Int
    let relationType: String
    let strength: Double?

    enum CodingKeys: String, CodingKey {
        case id, source, target
        case relationType = "relation_type"
        case strength
    }
}

// MARK: - Knowledge Graph Stats

struct KGStats: Codable, Sendable {
    let entityCount: Int?
    let factCount: Int?
    let relationshipCount: Int?
    let eventCount: Int?
    let taskCount: Int?

    enum CodingKeys: String, CodingKey {
        case entityCount = "entity_count"
        case factCount = "fact_count"
        case relationshipCount = "relationship_count"
        case eventCount = "event_count"
        case taskCount = "task_count"
    }
}

// MARK: - Entity Type Filter

enum EntityTypeFilter: String, CaseIterable, Sendable {
    case all = "All"
    case people = "People"
    case companies = "Companies"
    case projects = "Projects"

    var apiValue: String? {
        switch self {
        case .all: return nil
        case .people: return "person"
        case .companies: return "company"
        case .projects: return "project"
        }
    }
}

// MARK: - Search Result

struct SearchResult: Codable, Identifiable, Sendable {
    let id: Int
    let name: String
    let type: String
    let summary: String?
    let score: Double?
}
