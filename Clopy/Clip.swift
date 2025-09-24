import Foundation

/// Represents a clipboard text entry
struct Clip: Identifiable, Equatable {
    let id: UUID
    let content: String
    let createdAt: Date
    
    init(content: String) {
        self.id = UUID()
        self.content = content
        self.createdAt = Date()
    }
    
    /// Returns a display-friendly version of the content
    /// Truncates to show first 30 chars + ... + last 20 chars if needed
    /// Collapses newlines to spaces
    var displayText: String {
        let cleanContent = content.replacingOccurrences(of: "\n", with: " ")
                                 .replacingOccurrences(of: "\r", with: " ")
                                 .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanContent.count <= 53 { // 30 + 3 (ellipsis) + 20
            return cleanContent
        }
        
        let startIndex = cleanContent.startIndex
        let endIndex = cleanContent.endIndex
        
        let firstPart = String(cleanContent[startIndex..<cleanContent.index(startIndex, offsetBy: 30)])
        let lastPartStartIndex = cleanContent.index(endIndex, offsetBy: -20)
        let lastPart = String(cleanContent[lastPartStartIndex..<endIndex])
        
        return "\(firstPart)…\(lastPart)"
    }
    
    static func == (lhs: Clip, rhs: Clip) -> Bool {
        return lhs.content == rhs.content
    }
}
