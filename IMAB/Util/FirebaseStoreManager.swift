//
//  FirebaseStoreManager.swift
//  IMAB
//
//  Created by Vijay Rathore on 06/05/23.
//

import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import Messages
import FirebaseMessaging

struct FirebaseStoreManager {
    static let db = Firestore.firestore()
    static let auth = Auth.auth()
    static let storage = Storage.storage()
    static let message = Messaging.messaging()
}

