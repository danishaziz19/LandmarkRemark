//
//  MapViewController.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import UIKit
import MapKit

protocol MapViewPresenter {
    func setRemarks(remarks: [Remark])
    func showsUserLocation()
    func setRegion(coordinateRegion: MKCoordinateRegion)
    func showErrorMessage(error: String)
    func showSuccessMessage(message: String)
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    lazy var viewModel: MapViewModel = MapViewModel(locationManager: CLLocationManager(), mapViewPresenter: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // setup mapview
    func setup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(RemarkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        viewModel.setup()
    }
    
    @IBAction func currentLocaionPress(_ sender: UIButton) {
        viewModel.setCurrentLocaion()
    }
    
    @IBAction func addNotePress(_ sender: UIButton) {
        addNote()
    }

    // Add new note
    func addNote() {
        let alert = UIAlertController(title: "Add Note", message: nil, preferredStyle: UIAlertController.Style.alert )
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if let text = textField.text, !text.isEmpty {
                self.viewModel.addNote(note: text)
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "note..."
        }
        
        alert.addAction(save)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })
        
        self.present(alert, animated:true, completion: nil)
    }
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchRemarkViewController" {
        }
    }

}


// MARK: - MapViewPresenter

extension MapViewController: MapViewPresenter {
    func setRegion(coordinateRegion: MKCoordinateRegion) {
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func showsUserLocation() {
        mapView.showsUserLocation = true
    }
    
    func setRemarks(remarks: [Remark]) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(remarks)
    }
    
    func showErrorMessage(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { (alertAction) in })
        self.present(alert, animated:true, completion: nil)
    }
    
    func showSuccessMessage(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { (alertAction) in })
        self.present(alert, animated:true, completion: nil)
    }
}

 

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        viewModel.setLastKnonwLocation(location: userLocation.coordinate)
    }
    
    // Click on information icon on NoteMapView if there are more maps in
    // same place it will sent to the Search screen and show all notes on that location
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let remark = view.annotation as! Remark
        let remarks = viewModel.getFilterRemark(remark: remark)

        if remarks.count  > 1 {
            let alert = UIAlertController(title: nil, message: "There are more notes in this location. You want to see ?", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Cancel".uppercased(), style: .cancel, handler: nil))

            alert.addAction(UIAlertAction(title: "Yes".uppercased(), style: .default, handler: { (action: UIAlertAction!) in
                if let navigate = self.navigationController {
                    let searchCoordinator: SearchCoordinator = SearchCoordinator(navigation: navigate)
                    searchCoordinator.start()
                }
            }))

            self.present(alert, animated: true, completion: nil)
        }
    }
}
