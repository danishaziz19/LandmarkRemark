//
//  RemarkService.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import Foundation

protocol RemarkServiceProvider {
    func addRemark(remark: Remark, completion: @escaping (_ isSuccess: Bool, _ error: String?) -> Void)
    func getRemarks(completion: @escaping (_ remarks: [Remark], _ error: String?) -> Void)
}

class RemarkService: NSObject, RemarkServiceProvider {
 
    let firebaseAPI: FirestoreProvider
    
    init(firebaseAPI: FirestoreProvider) {
        self.firebaseAPI = firebaseAPI
    }
    
    func addRemark(remark: Remark, completion: @escaping (Bool, String?) -> Void) {
        firebaseAPI.addRemark(remark: remark) { (isAdded, error) in
            completion(isAdded, error)
        }
    }
    
    // if we have local database then we will redirect to local db else from api
    func getRemarks(completion: @escaping ([Remark], String?) -> Void) {
        firebaseAPI.getRemarks { (remarks, error) in
            completion(remarks, error)
        }
    }
}
