//
//  PointAnnotation.swift
//  weather
//
//  Created by Lauriane Haydari on 09/04/2020.
//  Copyright © 2020 Lauriane Haydari. All rights reserved.
//

import MapKit

class PointAnnotation: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            markerTintColor = .purple
            glyphText = "Paris"
        }
    }
}
