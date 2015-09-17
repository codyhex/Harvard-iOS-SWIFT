//
//  ViewController.swift
//  MapKitExample
//
//  Created by Alex Blokker on 7/28/15.
//  Copyright (c) 2015 Harvard University. All rights reserved.
//

import UIKit
import MapKit

let reuseId = "pin"

class ViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

	var searchBar: UISearchBar?
	var localSearch: MKLocalSearch?
	var locationManager : CLLocationManager? {
		didSet {
			locationManager?.delegate = self
		}
	}

	@IBOutlet weak var mapView: MKMapView? {
		didSet {
			let initialRegion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(42.3144, -70.9701), span: MKCoordinateSpanMake(2.5, 2.0))
			mapView!.setRegion(initialRegion, animated: false)
		}
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		searchBar = UISearchBar()
		searchBar!.delegate = self
		locationManager = CLLocationManager()
		locationManager?.delegate = self
		self.navigationItem.titleView = searchBar
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		locationManager?.requestWhenInUseAuthorization()
	}

	func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedWhenInUse {
			mapView?.showsUserLocation = true
		}
	}

	func searchBarSearchButtonClicked(searchBar: UISearchBar) {

		if let search = self.localSearch {
			search.cancel()
		}

		var request = MKLocalSearchRequest()
		request.naturalLanguageQuery = searchBar.text

		localSearch = MKLocalSearch(request: request)
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true

		localSearch!.startWithCompletionHandler {
			(response: MKLocalSearchResponse!, error: NSError!) -> Void in
			
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			if error != nil {
				// TODO: handle error
				
			} else if let locations = response.mapItems {
				if let item = locations.first as? MKMapItem {
					self.updateMapWithItem(item, region: response.boundingRegion)
				}
			}
		}
	}

	func updateMapWithItem(item: MKMapItem, region: MKCoordinateRegion) {
		var annotation = PlaceAnnotation()
		annotation.coordinate = item.placemark.location.coordinate
		annotation.title = item.name
		annotation.subtitle = "\(item.placemark.location.coordinate.latitude), \(item.placemark.location.coordinate.longitude)"
		self.mapView?.addAnnotation(annotation)
		
		//self.mapView?.setRegion(region, animated: false)
		if self.mapView?.annotations.count > 1 {
			self.snapMapUsingAnnotations()
		} else {
			self.mapView?.setRegion(region, animated: false)
		}
	}

	func mapView(mapView: MKMapView!, regionWillChangeAnimated animated: Bool) {
		self.searchBar?.resignFirstResponder()

		if let selectedPins = mapView.selectedAnnotations {
			for item in selectedPins {
				if let annotation : MKAnnotation = item as? MKAnnotation {
					mapView.deselectAnnotation(annotation, animated: false)
				}
			}
		}
	}
	
	func snapMapUsingAnnotations() {
		var minLat = 1000.0
		var maxLat = -1000.0
		var minLng = 1000.0
		var maxLng = -1000.0
		
		for item in (self.mapView!.annotations ){
			minLat = min(minLat, item.coordinate.latitude)
			maxLat = max(maxLat, item.coordinate.latitude)
			minLng = min(minLng, item.coordinate.longitude)
			maxLng = max(maxLng, item.coordinate.longitude)
		}
		
		// this increases the span so that the point fit into the new region
		minLat -= 0.1
		maxLat += 0.1
		minLng -= 0.1
		maxLng += 0.1
		
		let span = MKCoordinateSpanMake(abs(maxLat - minLat), abs(maxLng - minLng))

		let center = CLLocationCoordinate2DMake(minLat + span.latitudeDelta/2.0, minLng + span.longitudeDelta/2.0)

		self.mapView?.setRegion(MKCoordinateRegionMake(center, span), animated: true)
	}

	// this can be a way to return custom views
	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		if annotation is MKUserLocation {
			//return nil so map view draws "blue dot" for standard user location
			return nil
		}

		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			pinView?.animatesDrop = true
			pinView?.pinColor = .Purple
		}
		else {
			pinView!.annotation = annotation
		}
		return pinView
	}
}

