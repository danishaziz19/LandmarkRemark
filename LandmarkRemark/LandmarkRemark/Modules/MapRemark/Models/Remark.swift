//
//  Remark.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import Foundation
import MapKit

class Remark: NSObject, MKAnnotation {
  
    var coordinate: CLLocationCoordinate2D
    let userName: String
    let note: String
    let address: String
    let updatedAt : Date
    var title: String?
    
    init(userName: String, note: String, address: String, location: CLLocationCoordinate2D, updatedAt: Date) {
        self.userName = userName
        self.note = note
        self.updatedAt = updatedAt
        self.coordinate = location
        self.title = userName
        self.address = address
        super.init()
    }
    
    var imageName: String? {
        return "Flag"
    }
    
    var bodyWithDate: String {
        var message: String = ""
        if !self.address.isEmpty {
            message += "\(self.address) \n\n"
        }
        message += "\(self.note) \n\n"
        message += dateToString
        return message
    }
    
    var body: String {
        var message: String = ""
        if !self.address.isEmpty {
            message += "\(self.address) \n\n"
        }
        message += "\(self.note)"
        return message
    }
    
    var dateToString: String {
        var message: String = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm a"
        message = "\(formatter.string(from: self.updatedAt))"
        return message
    }
}

