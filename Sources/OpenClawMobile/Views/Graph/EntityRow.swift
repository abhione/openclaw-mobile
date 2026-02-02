import SwiftUI

struct EntityRow: View {
    let entity: Entity

    var body: some View {
        HStack(spacing: 12) {
            // Type Icon
            Image(systemName: entity.typeIcon)
                .font(.system(size: 20))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 36, height: 36)
                .background(AppTheme.accent.opacity(0.15))
                .clipShape(Circle())

            // Entity Info
            VStack(alignment: .leading, spacing: 4) {
                Text(entity.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)

                HStack(spacing: 8) {
                    Text(entity.type.capitalized)
                        .font(AppTheme.captionFont)
                        .foregroundStyle(AppTheme.textTertiary)

                    if entity.factCount > 0 {
                        HStack(spacing: 3) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 10))
                            Text("\(entity.factCount) facts")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundStyle(AppTheme.textTertiary)
                    }
                }

                if let summary = entity.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.system(size: 13))
                        .foregroundStyle(AppTheme.textSecondary)
                        .lineLimit(1)
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
}

#Preview {
    VStack(spacing: 8) {
        EntityRow(entity: Entity(
            id: 1,
            type: "person",
            name: "Abhi",
            aliases: nil,
            summary: "Creator of OpenClaw",
            metadata: nil,
            createdAt: nil,
            updatedAt: nil,
            facts: [
                Fact(id: 1, entityId: 1, key: "role", value: "Developer", confidence: nil, source: nil, createdAt: nil),
                Fact(id: 2, entityId: 1, key: "location", value: "San Francisco", confidence: nil, source: nil, createdAt: nil)
            ],
            relationships: nil,
            events: nil,
            tasks: nil
        ))
        EntityRow(entity: Entity(
            id: 2,
            type: "company",
            name: "OpenClaw Inc",
            aliases: nil,
            summary: "AI agent platform",
            metadata: nil,
            createdAt: nil,
            updatedAt: nil,
            facts: nil,
            relationships: nil,
            events: nil,
            tasks: nil
        ))
    }
    .padding()
    .background(AppTheme.background)
}
