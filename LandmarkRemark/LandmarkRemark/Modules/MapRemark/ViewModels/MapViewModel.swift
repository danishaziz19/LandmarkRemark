//
//  MapViewModel.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import CoreLocation
import FirebaseAuth
import MapKit

class MapViewModel: NSObject {
    
    let regionRadius: CLLocationDistance = 1000
    let locationManager: CLLocationManager!
    var lastKnonwLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    let remarkService: RemarkServiceProvider = RemarkService(firebaseAPI: FirebaseAPI())
    var remarks: [Remark] = []
    private let mapViewPresenter: MapViewPresenter
    
    init(locationManager: CLLocationManager, mapViewPresenter: MapViewPresenter) {
        self.locationManager = locationManager
        self.mapViewPresenter = mapViewPresenter
    }
    
    func setup() {
        self.checkLocationAuthorizationStatus()
        self.getRemarks()
    }
    
    func getFilterRemark(remark: Remark) -> [Remark] {
        return remarks.filter( { $0.coordinate.latitude == remark.coordinate.latitude &&  $0.coordinate.longitude == remark.coordinate.longitude })
    }
    
    // get remarks
    func getRemarks() {
        MBLoader.show()
        remarkService.getRemarks(completion: { [weak self] (remarks, error) in
            MBLoader.hide()
            if let error = error {
                self?.mapViewPresenter.showErrorMessage(error: error)
                return
            }
            self?.mapViewPresenter.setRemarks(remarks: remarks)
            self?.remarks = remarks
        })
    }
    
    func setLastKnonwLocation(location: CLLocationCoordinate2D) {
        lastKnonwLocation = location
    }
    
    // add note
    func addNote(note: String) {
        MBLoader.show()
        self.getAddressFromLocation(note: note)
    }
    
    // get Address from currrent location when we are saving note.
    func getAddressFromLocation(note: String) {
        let clgeocoder: CLGeocoder = CLGeocoder()
        let location: CLLocation = CLLocation(latitude:self.lastKnonwLocation.latitude, longitude: self.lastKnonwLocation.longitude)
        
        clgeocoder.reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                
            var addressString : String = ""
            
            if let error = error {
                print("reverse geodcode fail: \(error.localizedDescription)")
                self.mapViewPresenter.showErrorMessage(error: error.localizedDescription)
                MBLoader.hide()
            } else {
                let placeMark = placemarks! as [CLPlacemark]
                
                    if placeMark.count > 0 {
                        let pm = placemarks![0]
                        
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                    }
                }
                
                let remark = Remark(userName: Auth.auth().currentUser?.displayName ?? "Unknown", note: note, address: addressString, location: self.lastKnonwLocation, updatedAt: Date())
                self.remarkService.addRemark(remark: remark) { (isAdded, error) in
                    MBLoader.hide()
                    if let error = error {
                        self.mapViewPresenter.showErrorMessage(error: error)
                        return
                    }
                    
                    if isAdded {
                        self.mapViewPresenter.showSuccessMessage(message: "Note added Successfully")
                    } else {
                        self.mapViewPresenter.showErrorMessage(error: "Note not added")
                    }
                }
        })
    }
}

// MARK: - CLLocationManager

extension MapViewModel: CLLocationManagerDelegate {
  
   // location authoriza status
   func checkLocationAuthorizationStatus() {
    
       if locationManager.authorizationStatus == .authorizedAlways {
            self.mapViewPresenter.showsUserLocation()
       } else {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
       }

       self.locationManager.delegate = self
       self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
       self.locationManager.startUpdatingLocation()
   }
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let location = locations.last {
           let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
           let coordinateRegion = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
           self.lastKnonwLocation = center
           self.mapViewPresenter.setRegion(coordinateRegion: coordinateRegion)
           self.locationManager.stopUpdatingLocation()
       }
   }
   
   // set current location into the map
   func setCurrentLocaion() {
       self.locationManager.stopUpdatingLocation()
       self.locationManager.startUpdatingLocation()
   }
}
