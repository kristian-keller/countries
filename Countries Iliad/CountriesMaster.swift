//
//  CountriesMaster.swift
//  Countries Iliad
//
//  Created by Kristian Keller on 28/12/22.
//

import SwiftUI

/// The Master View of the App.
struct CountriesMaster: View {
    
    /// The Model as StateObject.
    @StateObject private var countriesModel = CountriesModel.shared
    
    /// The currently selected `Country`.
    @State var selectedCountry: Country?
    
    /// Always show the sidebar on iPad.
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    /// Text from the search bar.
    @State private var searchBarText = ""
    
    /// Show or hide the `FilterPopover`.
    @State private var showingFilterPopover = false
    
    /// Regions selected from the `FilterPopover`.
    @State private var selectedRegions: [Region] = []
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(countriesModel.countries, selection: $selectedCountry) { country in
                // Filter by name and language (search bar).
                if country.name(contains: searchBarText) || country.hasLanguage(called: searchBarText) || searchBarText.isEmpty {
                    // Filter by continent (popover).
                    if (!selectedRegions.isEmpty && country.hasRegion(from: selectedRegions)) || selectedRegions.isEmpty {
                        NavigationLink(value: country) {
                            CountryListElement(country: country, showingLanguageFootnote: country.hasLanguage(called: searchBarText))
                        }
                    }
                }
            }
            // Custom ViewModifier checks if list is empty or not.
            .emptyPlaceholder(countriesModel.countries) {
                Text("No countries to show")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Countries")
            .searchable(text: $searchBarText, prompt: "Search country or language")
            .toolbar {
                Button {
                    showingFilterPopover.toggle()
                } label: {
                    if selectedRegions.isEmpty {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    } else {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    }
                }
                .popover(isPresented: $showingFilterPopover) {
                    FilterPopover(selectedRegions: $selectedRegions, showingPopover: $showingFilterPopover)
                }
            }
        } detail: {
            CountryDetail(country: $selectedCountry)
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            countriesModel.retriveCountries()
        }
    }
}

struct CountriesMaster_Previews: PreviewProvider {
    static var previews: some View {
        CountriesMaster(selectedCountry: nil)
    }
}
