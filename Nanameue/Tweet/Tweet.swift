//
//  Tweet.swift
//  Nanameue
//
//  Created by Stanley Lim on 29/10/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

struct Tweet {
    let id: String?
    var tweetId: String {
        return id ?? UUID().uuidString
    }
    let text: String?
    let date: Date
    var image: UIImage?
    var userId: String
    var downloadURL: URL?
    
    init(user: User? = Auth.auth().currentUser, text: String?, image: UIImage?) {
        self.userId = user?.uid ?? ""
        self.text = text
        self.date = Date()
        self.id = nil
        self.image = image
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard
            let sentDate = data["created"] as? Timestamp,
            let userID = data["userId"] as? String
        else {
            return nil
        }
        
        id = document.documentID

        self.date = sentDate.dateValue()
        self.userId = userID
        self.text = data["text"] as? String ?? nil
        if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
        } else {
            downloadURL = nil
        }
    }
    
}

// MARK: - DatabaseRepresentation
extension Tweet: DatabaseRepresentation {
    var representation: [String: Any] {
        var rep: [String: Any] = [
            "created": date,
            "userId": userId,
            
        ]
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        }
        
        if let text = text {
            rep["text"] = text
        }
        
        return rep
    }
}

// MARK: - Comparable
extension Tweet: Comparable {
  static func == (lhs: Tweet, rhs: Tweet) -> Bool {
    return lhs.id == rhs.id
  }

  static func < (lhs: Tweet, rhs: Tweet) -> Bool {
    return lhs.date < rhs.date
  }
}
