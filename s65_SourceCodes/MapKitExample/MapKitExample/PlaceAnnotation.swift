//
//  PlaceAnnotation.swift
//  MapKitExample
//
//  Created by Alex Blokker on 7/28/15.
//  Copyright (c) 2015 Harvard University. All rights reserved.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {

	var coordinate: CLLocationCoordinate2D
	var title: String!
	var subtitle: String!

	override init() {
		self.coordinate = CLLocationCoordinate2DMake(0, 0) // needs an initial default value
		super.init()
	}
}
