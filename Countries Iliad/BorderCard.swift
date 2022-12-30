//
//  BorderCard.swift
//  Countries Iliad
//
//  Created by Kristian Keller on 29/12/22.
//

import SwiftUI

/// A View showing a country that shares a border with the displayed country in the Detail View.
struct BorderCard: View {
    
    /// The CCA3 code passed from the parent.
    var border: String
    
    var body: some View {
        // In a real evironment `lookupBy(cca3:)` always returns a country, in a test environment it returns `nil`, so a sample country is picked.
        let country = CountriesModel.shared.lookupBy(cca3: border) ?? CountriesModel.sampleCountries.first!
        return HStack {
            Text(country.emojiFlag)
                .scaledToFill()
            // GeometryReader here is used to understand if the name of the country fits or not, it updates when the window is resized (Mac, iPad splitview).
            GeometryReader { geometry in
                if geometry.size.width > 50 {
                    Text(country.name)
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemFill))
        .cornerRadius(10)
    }
}

struct BorderCard_Previews: PreviewProvider {
    static var previews: some View {
        BorderCard(border: "ITA")
    }
}
