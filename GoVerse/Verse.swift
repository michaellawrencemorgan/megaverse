import Foundation

/// Represents a Bible verse with a topic header and translation.
struct Verse {
    let book: String
    let chapter: Int
    let verse: Int
    let text: String
    let topic: String
    let translation: String
}
