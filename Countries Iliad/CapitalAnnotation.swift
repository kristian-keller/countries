//
//  CapitalAnnotation.swift
//  Countries Iliad
//
//  Created by Kristian Keller on 30/12/22.
//

import MapKit

/// A capital to show on the map, it conforms to `MKAnnotation`.
class CapitalAnnotation: NSObject, MKAnnotation {
    
    /// Title of the annotation.
    var title: String?
    
    /// Subtitle of the annotation.
    var subtitle: String?
    
    /// Coordinates of the annotation.
    var coordinate: CLLocationCoordinate2D
    
    /// Initializer for the annotation.
    /// - Parameter country: A `Country` that has a capital.
    init(country: Country) {
        title = country.capital
        subtitle = "Capital of \(country.name)"
        coordinate = CLLocationCoordinate2D(latitude: country.capitalCoordinate![0], longitude: country.capitalCoordinate![1])
    }
}
