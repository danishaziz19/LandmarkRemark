//
//  FirebaseAPI.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import Foundation
import Firebase
import CoreLocation

protocol FirestoreProvider {
    func addRemark(remark: Remark, completion: @escaping (_ isSuccess: Bool, _ error: String?) -> Void)
    func getRemarks(completion: @escaping (_ remarks: [Remark], _ error: String?) -> Void)
    func signIn(email: String, password: String, completion: @escaping (_ isSucess: Bool,_ error: String?) -> Void)
    func signUp(userName: String, email: String, password: String, completion: @escaping (_ isSucess: Bool,_ error: String?) -> Void)
    func logout(completion: @escaping (_ isSucess: Bool,_ error: String?) -> Void)
}

class FirebaseAPI: NSObject, FirestoreProvider {
    
    enum CodingKeys: String {
        case username
        case note
        case address
        case location
        case modifiedDate
    }
    
    let firebaseClient :Firestore
    
    init(firebaseClient:Firestore = Firestore.firestore()) {
        self.firebaseClient = firebaseClient
    }
    
    // Add Remark into firebase
    func addRemark(remark: Remark, completion: @escaping (_ isSuccess: Bool, _ error: String?) -> Void) {
        let data: [String: Any] =  [CodingKeys.username.rawValue: remark.userName,
                                    CodingKeys.note.rawValue: remark.note,
                                    CodingKeys.address.rawValue: remark.address,
                                    CodingKeys.location.rawValue : GeoPoint(latitude: remark.coordinate.latitude, longitude: remark.coordinate.longitude),
                                    CodingKeys.modifiedDate.rawValue: remark.updatedAt]
        firebaseClient.collection(DBTables.remarks.rawValue).addDocument(data: data) { error in
            if error != nil {
                completion(false, error?.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    // get all Remark from firebase
    func getRemarks(completion: @escaping (_ remarks: [Remark], _ error: String?) -> Void) {
     
        let documentReference = firebaseClient.collection(DBTables.remarks.rawValue)
        
        documentReference.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            if let error = error {
                completion([], error.localizedDescription)
            } else {
                var remarks: [Remark] = []
                if let documents = querySnapshot?.documents {
                    for document in documents {
                     
                        let username: String = document.data()[CodingKeys.username.rawValue] as? String ?? ""
                        let message = document.data()[CodingKeys.note.rawValue] as? String ?? ""
                        let address = document.data()[CodingKeys.address.rawValue] as? String ?? ""
                        let location = document.data()[CodingKeys.location.rawValue] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
                        let timeStamp = document.data()[CodingKeys.modifiedDate.rawValue] as? Timestamp
                        let updatedAt = timeStamp?.dateValue() ?? Date()
                        let locationCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                        
                        remarks.append(Remark(userName: username, note: message, address: address, location: locationCoordinate, updatedAt: updatedAt))
                    }
                }
                completion(remarks, nil)
            }
        }
    }
    
    // Sign in using email and password
    func signIn(email: String, password: String, completion: @escaping (_ isSucess: Bool,_ error: String?) -> Void) {
    
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, error.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    // Sign up using email , password and username
    func signUp(userName: String, email: String, password: String, completion: @escaping (_ isSucess: Bool,_ error: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, (error.localizedDescription))
                return
            }
            let createProfileChangeRequest = authDataResult?.user.createProfileChangeRequest()
            createProfileChangeRequest?.displayName = userName
            createProfileChangeRequest?.commitChanges(completion: { error in
                completion(true, nil)
            })
        }
    }
    
    // logout
    func logout(completion: @escaping (_ isSucess: Bool,_ error: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true, nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            completion(false, signOutError.localizedDescription)
        }
    }
    
}
