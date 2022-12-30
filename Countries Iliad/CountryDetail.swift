//
//  CountryDetail.swift
//  Countries Iliad
//
//  Created by Kristian Keller on 28/12/22.
//

import SwiftUI

/// The Detail View showing a single `Country`.
struct CountryDetail: View {
    
    /// Environment property to understand if screen is small (iPhone, iPad splitview) or big (iPad fullscreen, Mac).
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    /// The `Country` to show, passed from the Master View.
    @Binding var country: Country?
    
    /// Describes a `LazyVGrid` layout.
    let twoColumnsGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            if let country {
                ScrollView {
                    MapView(country: $country)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: 300)
                    Text(country.name)
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    if let subregion = country.subregion {
                        Text("\(country.sovereignState ? "Country" : "Territory") in \(subregion)")
                            .font(.subheadline)
                    }
                    // Use the environment property to choose between HStack and VStack.
                    let layout = horizontalSizeClass == .regular ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
                    layout {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text("Total Area")
                                    .bold()
                                    .textCase(.uppercase)
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                HStack {
                                    Image(systemName: "rectangle.dashed")
                                        .foregroundColor(.secondary)
                                        .bold()
                                    Text(country.area, format: .number)
                                        .bold()
                                    Text("km²")
                                        .bold()
                                }
                            }
                            .padding()
                            if let capital = country.capital {
                                VStack(alignment: .leading) {
                                    Text("Capital")
                                        .bold()
                                        .textCase(.uppercase)
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                    HStack {
                                        Image(systemName: "mappin.square.fill")
                                            .foregroundColor(.secondary)
                                            .bold()
                                        Text(capital)
                                            .bold()
                                    }
                                }
                                .padding()
                            }
                            if let currency = country.currency {
                                VStack(alignment: .leading) {
                                    Text("Currency")
                                        .bold()
                                        .textCase(.uppercase)
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                    HStack {
                                        Image(systemName: "banknote")
                                            .foregroundColor(.secondary)
                                            .bold()
                                        Text(currency)
                                            .bold()
                                    }
                                }
                                .padding()
                            }
                            if !country.allLanguages.isEmpty {
                                VStack(alignment: .leading) {
                                    Text("Languages")
                                        .bold()
                                        .textCase(.uppercase)
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                    HStack {
                                        Image(systemName: "character.bubble")
                                            .foregroundColor(.secondary)
                                            .bold()
                                        Text(country.allLanguages)
                                            .bold()
                                    }
                                }
                                .padding()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        if !country.bordersCCA3.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Borders")
                                    .font(.title2)
                                    .bold()
                                    .padding()
                                LazyVGrid(columns: twoColumnsGrid) {
                                    ForEach(country.bordersCCA3, id: \.self) { border in
                                        Button {
                                            self.country = CountriesModel.shared.lookupBy(cca3: border)
                                        } label: {
                                            BorderCard(border: border)
                                        }
                                    }
                                }
                                .padding()
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                            .padding()
                        }
                    }
                }
                .ignoresSafeArea(.all)
            } else {
                // The View does not always have a country to show.
                VStack {
                    Image(systemName: "globe")
                        .font(.system(size: 50))
                        .padding()
                    Text("Select a Country")
                }
                .foregroundColor(.secondary)
            }
        }
    }
}

struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetail(country: .constant(CountriesModel.sampleCountries.first!))
            .previewDisplayName("Country Displayed")
        CountryDetail(country: .constant(nil))
            .previewDisplayName("Select a Country")
    }
}
