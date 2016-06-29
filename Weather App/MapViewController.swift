//
//  MapViewController.swift
//  Weather App
//
//  Created by Boguslaw Dawidow on 28.06.2016.
//  Copyright © 2016 Szymon Dawidow. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol WeatherMapViewDelegate: MKMapViewDelegate {
    
    func didSelectedCoordinates(latitude: Double, longitude: Double)
}

class MapViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var chosenPoint: CLLocationCoordinate2D?
    weak var delegate: WeatherMapViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
        
        let mapSingleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapFunc))
        mapSingleTapRecognizer.numberOfTapsRequired = 1
        self.mapView.addGestureRecognizer(mapSingleTapRecognizer)
    }

    
    //MARK: - IBActions
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectButtonTapped(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: {
            if let pointCoordinate = self.chosenPoint {
                self.delegate?.didSelectedCoordinates(pointCoordinate.latitude, longitude: pointCoordinate.longitude)
            }
        })
    }
    
    func tapFunc(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(self.mapView)
        let tapPoint:CLLocationCoordinate2D = self.mapView.convertPoint(point, toCoordinateFromView: self.mapView)
        addAnnotationWithCoordinate(tapPoint)
        print("tap   \(chosenPoint)")
    }
    
    
    //MARK: - Annotations Managing Methods
    
    func addAnnotationWithCoordinate(coordinate: CLLocationCoordinate2D) {
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.chosenPoint = coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.chosenPoint!
        self.mapView.addAnnotation(annotation)
    }
    
    
    //MARK: - Map Kit Delegate
    
   
}
