import Foundation

// MARK: - AgentTask

struct AgentTask: Codable, Identifiable, Sendable {
    let id: Int
    let name: String
    let description: String?
    let status: String
    let priority: String?
    let assignedTo: String?
    let linkedEntities: [String]?
    let parentTaskId: Int?
    let createdAt: String?
    let updatedAt: String?
    let completedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, status, priority
        case assignedTo = "assigned_to"
        case linkedEntities = "linked_entities"
        case parentTaskId = "parent_task_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case completedAt = "completed_at"
    }

    var statusIcon: String {
        switch status.lowercased() {
        case "in_progress": return "🔄"
        case "pending": return "⏳"
        case "completed": return "✅"
        case "blocked": return "🚫"
        case "planned": return "📝"
        default: return "📋"
        }
    }

    var statusColor: String {
        switch status.lowercased() {
        case "in_progress": return "inProgress"
        case "pending": return "pending"
        case "completed": return "completed"
        case "blocked": return "blocked"
        case "planned": return "planned"
        default: return "pending"
        }
    }

    var priorityLevel: Int {
        switch (priority ?? "medium").lowercased() {
        case "critical": return 4
        case "high": return 3
        case "medium": return 2
        case "low": return 1
        default: return 0
        }
    }

    var linkedEntityCount: Int {
        linkedEntities?.count ?? 0
    }
}

// MARK: - Task Filter

enum TaskFilter: String, CaseIterable, Sendable {
    case all = "All"
    case inProgress = "In Progress"
    case pending = "Pending"
    case completed = "Completed"

    var apiValue: String? {
        switch self {
        case .all: return nil
        case .inProgress: return "in_progress"
        case .pending: return "pending"
        case .completed: return "completed"
        }
    }
}
