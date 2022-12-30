//
//  CountryListElement.swift
//  Countries Iliad
//
//  Created by Kristian Keller on 28/12/22.
//

import SwiftUI

/// An element from the list of countries in the `CountriesMaster`.
struct CountryListElement: View {
    
    /// The `Country`.
    var country: Country
    
    /// Show the languages of a country if a search is in progress.
    var showingLanguageFootnote: Bool
    
    var body: some View {
        HStack {
            Text(country.emojiFlag)
            VStack(alignment: .leading) {
                Text(country.name)
                if showingLanguageFootnote {
                    Text("Language is \(country.allLanguages)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct CountryListElement_Previews: PreviewProvider {
    static var previews: some View {
        CountryListElement(country: CountriesModel.sampleCountries.first!, showingLanguageFootnote: false)
            .previewDisplayName("Footnote hidden")
        CountryListElement(country: CountriesModel.sampleCountries.last!, showingLanguageFootnote: true)
            .previewDisplayName("Footnote showed")
    }
}
