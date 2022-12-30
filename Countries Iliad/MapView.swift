//
//  MapView.swift
//  Countries Iliad
//
//  Created by Kristian Keller on 29/12/22.
//

import SwiftUI
import MapKit

/// A View showing a map, it conforms to `UIViewRepresentable`.
struct MapView: UIViewRepresentable {
    
    /// The `Country` that is passed from the parent view.
    @Binding var country: Country?
    
    /// The instance of the `MKMapView`.
    @State var mapView = MKMapView()
    
    /// Annotations added to the map.
    var annotations: [MKAnnotation] = []
    
    /// Returns the instance of the `MKMapView`.
    func makeUIView(context: Context) -> some UIView {
        return mapView
    }
    
    /// Update the `MKMapView` to show a country.
    ///
    /// Takes the country name and sends a query to Apple Maps. A bounding region containing the country is returned and is used to set the region of the map. Remove previous annotations from the map and if the country has a capital, it creates an annotation and adds it to the map.
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = country?.name
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response else {
                return
            }
            mapView.setRegion(response.boundingRegion, animated: true)
            mapView.removeAnnotations(mapView.annotations)
            if country?.capital != nil && country?.capitalCoordinate?.count == 2 {
                let capitalAnnotation = CapitalAnnotation(country: country!)
                mapView.addAnnotation(capitalAnnotation)
            }
        }
    }
}
