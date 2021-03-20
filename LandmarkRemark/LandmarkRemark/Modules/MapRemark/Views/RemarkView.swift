//
//  RemarkView.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import MapKit

class RemarkView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let remark = newValue as? Remark else {return}
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageName = remark.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = remark.bodyWithDate
            detailCalloutAccessoryView = detailLabel
        }
    }
}

