import Foundation

typealias CommentCollection = [Comment]

struct Comment {
    let id: ID
    let body: String
    let author: User
}

typealias ID = Int
