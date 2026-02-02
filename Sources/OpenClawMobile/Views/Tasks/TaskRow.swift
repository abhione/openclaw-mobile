import SwiftUI

struct TaskRow: View {
    let task: AgentTask

    var body: some View {
        HStack(spacing: 12) {
            // Status Icon
            Text(task.statusIcon)
                .font(.system(size: 24))

            // Task Info
            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineLimit(2)

                if let description = task.description, !description.isEmpty {
                    Text(description)
                        .font(AppTheme.captionFont)
                        .foregroundStyle(AppTheme.textSecondary)
                        .lineLimit(1)
                }

                HStack(spacing: 8) {
                    // Priority Badge
                    if let priority = task.priority {
                        StatusBadge(
                            text: priority.capitalized,
                            color: priorityColor(priority)
                        )
                    }

                    // Linked Entities
                    if task.linkedEntityCount > 0 {
                        HStack(spacing: 3) {
                            Image(systemName: "link")
                                .font(.system(size: 10))
                            Text("\(task.linkedEntityCount)")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundStyle(AppTheme.textTertiary)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppTheme.textTertiary)
        }
        .padding(AppTheme.cardPadding)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }

    private func priorityColor(_ priority: String) -> Color {
        switch priority.lowercased() {
        case "critical": return AppTheme.priorityCritical
        case "high": return AppTheme.priorityHigh
        case "medium": return AppTheme.priorityMedium
        case "low": return AppTheme.priorityLow
        default: return AppTheme.textTertiary
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        TaskRow(task: AgentTask(
            id: 1,
            name: "Implement authentication flow",
            description: "Add OAuth2 support for the mobile app",
            status: "in_progress",
            priority: "high",
            assignedTo: "Enigma",
            linkedEntities: ["OpenClaw", "Auth Service"],
            parentTaskId: nil,
            createdAt: nil,
            updatedAt: nil,
            completedAt: nil
        ))
        TaskRow(task: AgentTask(
            id: 2,
            name: "Review PR #42",
            description: nil,
            status: "pending",
            priority: "medium",
            assignedTo: nil,
            linkedEntities: nil,
            parentTaskId: nil,
            createdAt: nil,
            updatedAt: nil,
            completedAt: nil
        ))
    }
    .padding()
    .background(AppTheme.background)
}
