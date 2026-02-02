import Foundation

// MARK: - Entity

struct Entity: Codable, Identifiable, Sendable {
    let id: Int
    let type: String
    let name: String
    let aliases: String?
    let summary: String?
    let metadata: String?
    let createdAt: String?
    let updatedAt: String?
    var facts: [Fact]?
    var relationships: [Relationship]?
    var events: [Event]?
    var tasks: [AgentTask]?

    enum CodingKeys: String, CodingKey {
        case id, type, name, aliases, summary, metadata
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case facts, relationships, events, tasks
    }

    var typeIcon: String {
        switch type.lowercased() {
        case "person": return "person.fill"
        case "company", "organization": return "building.2.fill"
        case "project": return "folder.fill"
        case "concept": return "lightbulb.fill"
        case "location": return "mappin.circle.fill"
        case "technology": return "cpu.fill"
        default: return "circle.fill"
        }
    }

    var factCount: Int {
        facts?.count ?? 0
    }
}

// MARK: - Fact

struct Fact: Codable, Identifiable, Sendable {
    let id: Int
    let entityId: Int?
    let key: String
    let value: String
    let confidence: Double?
    let source: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case entityId = "entity_id"
        case key, value, confidence, source
        case createdAt = "created_at"
    }
}

// MARK: - Relationship

struct Relationship: Codable, Identifiable, Sendable {
    let id: Int
    let sourceEntityId: Int?
    let targetEntityId: Int?
    let relationType: String
    let details: String?
    let strength: Double?
    let createdAt: String?
    var sourceEntity: String?
    var targetEntity: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sourceEntityId = "source_entity_id"
        case targetEntityId = "target_entity_id"
        case relationType = "relation_type"
        case details, strength
        case createdAt = "created_at"
        case sourceEntity = "source_entity"
        case targetEntity = "target_entity"
    }
}

// MARK: - Event

struct Event: Codable, Identifiable, Sendable {
    let id: Int
    let entityId: Int?
    let eventType: String
    let description: String
    let date: String?
    let source: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case entityId = "entity_id"
        case eventType = "event_type"
        case description, date, source
        case createdAt = "created_at"
    }
}
