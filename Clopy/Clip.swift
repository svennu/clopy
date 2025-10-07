import Foundation

/// Represents a clipboard text entry
struct Clip: Identifiable, Equatable {
    let id: UUID
    let content: String
    let createdAt: Date
    var isStarred: Bool

    init(content: String, isStarred: Bool = false) {
        self.id = UUID()
        self.content = content
        self.createdAt = Date()
        self.isStarred = isStarred
    }
    
    /// Returns a display-friendly version of the content
    /// Truncates to show first 30 chars + ... + last 20 chars if needed
    /// Collapses newlines to spaces and adds star prefix if starred
    var displayText: String {
        let cleanContent = content.replacingOccurrences(of: "\n", with: " ")
                                 .replacingOccurrences(of: "\r", with: " ")
                                 .trimmingCharacters(in: .whitespacesAndNewlines)

        let truncatedContent: String
        if cleanContent.count <= 53 { // 30 + 3 (ellipsis) + 20
            truncatedContent = cleanContent
        } else {
            let startIndex = cleanContent.startIndex
            let endIndex = cleanContent.endIndex

            let firstPart = String(cleanContent[startIndex..<cleanContent.index(startIndex, offsetBy: 30)])
            let lastPartStartIndex = cleanContent.index(endIndex, offsetBy: -20)
            let lastPart = String(cleanContent[lastPartStartIndex..<endIndex])

            truncatedContent = "\(firstPart)…\(lastPart)"
        }

        return isStarred ? "⭐ \(truncatedContent)" : truncatedContent
    }
    
    static func == (lhs: Clip, rhs: Clip) -> Bool {
        return lhs.content == rhs.content
    }
}
