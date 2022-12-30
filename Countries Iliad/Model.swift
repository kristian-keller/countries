//
//  Model.swift
//  Countries Iliad
//
//  Created by Kristian Keller on 28/12/22.
//

import Foundation

/// The Endpoint of REST Countries.
let restCountriesUrl = URL(string: "https://restcountries.com/v3.1/all")!

/// Represent a single Country.
struct Country: Hashable, Identifiable {
    
    /// Required for conformance to Identifiable.
    var id = UUID()
    
    /// Name of the `Country`.
    var name: String
    
    /// Flag of the `Country` as an Emoji.
    var emojiFlag: String
    
    /// The continent where the `Country` is.
    var region: String
    
    /// A `Country` can have a sub-region that describe where it is in the continent.
    var subregion: String?
    
    /// This code is used for looking up a `Country` and is unique.
    var cca3: String
    
    /// A collection of the neighbours of a `Country` as CCA3 codes.
    var bordersCCA3: [String]
    
    /// Currency used in the `Country`, only the first is stored for simplicity.
    var currency: String?
    
    /// The coordinates of the capital of the `Country`, stored as Latitude (0) and Longitude (1) in a collection.
    var capitalCoordinate: [Double]?
    
    /// Capital of the `Country`, only the first is stored for simplicity.
    var capital: String?
    
    /// Area in square metres of the `Country`.
    var area: Double
    
    /// A collection of the languages spoken in the `Country`.
    var languages: [String]?
    
    /// ISO 3166-1 independence status (denotes the country is considered a sovereign state).
    var sovereignState: Bool
    
    /// Returns a `String` with all the spoken languages in the `Country`, separated by commas.
    var allLanguages: String {
        get {
            if let languages {
                return String(languages.reduce("", {$0.appending("\($1), ")}).dropLast(2))
            }
            return ""
        }
    }
    
    /// Checks that the `Country` has at least a language that contains the `String` from the search bar.
    /// - Parameter searchString: `String` coming from the search bar.
    /// - Returns: `True` if a matching language is present, `False` otherwise.
    func hasLanguage(called searchString: String) -> Bool {
        if let languages {
            let uppercasedLanguages = languages.map {$0.uppercased()}
            return !uppercasedLanguages.filter({$0.contains(searchString.uppercased())}).isEmpty
        }
        return false
    }
    
    /// Checks that the `Country` is in one of the selected regions.
    /// - Parameter regions: A collection of regions.
    /// - Returns: `True` if the `Country` is in one of the regions, `False` otherwise.
    func hasRegion(from regions: [Region]) -> Bool {
        return regions.contains(where: {$0.name == region})
    }
    
    /// Checks that the name of the `Country` contains a portion of the `String`.
    /// - Parameter searchString: `String` coming from the search bar.
    /// - Returns: `True` if the name matches, `False` otherwise.
    func name(contains searchString: String) -> Bool {
        return self.name.uppercased().contains(searchString.uppercased())
    }
}

/// Model shared accross the App, it conforms to `ObservableObject`.
class CountriesModel: ObservableObject {
    
    /// A collection of countries.
    @Published var countries: [Country] = []
    
    /// Static instance of the Model.
    static let shared: CountriesModel = CountriesModel()
    
    /// A collection of sample countries used when it is necessary to test the App without downloading the data from the APIs.
    static let sampleCountries = [
        Country(name: "Italy", emojiFlag: "🇮🇹", region: "Europe", subregion: "Southern Europe", cca3: "ITA", bordersCCA3: ["AUT","FRA","SMR","SVN","CHE","VAT"], currency: "EUR", capital: "Rome", area: 301336, languages: ["Italian"], sovereignState: true),
        Country(name: "United States", emojiFlag: "🇺🇸", region: "Americas", cca3: "USA", bordersCCA3: ["CAN","MEX"], area: 9372610, languages: ["English"], sovereignState: true)
    ]
    
    /// Takes a CCA3 code and returns a `Country`.
    /// - Parameter cca3: A `String` containing the CCA3 code of the `Country` to return.
    /// - Returns: A `Country`.
    func lookupBy(cca3: String) -> Country? {
        return countries.first { country in
            country.cca3 == cca3
        }
    }
    
    /// Starts the `URLSession` to download the countries from the APIs.
    func retriveCountries() {        
        let session = URLSession.shared
        let task = session.dataTask(with: restCountriesUrl) { (data, response, error) in
            if let error {
                print("Handle Network Error: \(error)")
            } else if let data {
                DispatchQueue.main.async {
                    self.deserializeCountries(from: data)
                }
            } else {
                print("Handle other error")
            }
        }
        task.resume()
    }
    
    /// Parse the downloaded `Data` and insert countries in the Model.
    ///
    /// First it is checked that the `Data` is a JSON Object, then for every country in the JSON the relevant information is extracted and a `Country` instance is created. The `Country` is added to the Model, then the countries are sorted alphabetically.
    ///
    /// - Parameter data: The `Data` downloaded from the APIs.
    private func deserializeCountries(from data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else {
            return
        }
        
        for country in json {
            let nameObject = country["name"] as? [String:Any]
            let commonName = nameObject!["common"]! as! String
            let flag = country["flag"] as! String
            let region = country["region"] as! String
            let subregion = country["subregion"] as? String
            let cca3 = country["cca3"] as! String
            let borders = country["borders"] as? [String]
            let unwrappedBorders = borders != nil ? borders! : []
            let currenciesObject = country["currencies"] as? [String:Any]
            let firstCurrency = currenciesObject?.keys.first
            let capitalInfoObject = country["capitalInfo"] as? [String:Any]
            let capitalCoordinate = capitalInfoObject!["latlng"] as? [Double]
            let capitals = country["capital"] as? [String]
            let capital = capitals?.first
            let languagesObject = country["languages"] as? [String:Any]
            let languagesValues = languagesObject?.map {$0.value as! String}
            let area = country["area"] as! Double
            let positiveArea = area > 0 ? area : -area
            let sovereignState = country["independent"] as? Bool ?? false
            
            let newCountry = Country(
                name: commonName,
                emojiFlag: flag,
                region: region,
                subregion: subregion,
                cca3: cca3,
                bordersCCA3: unwrappedBorders,
                currency: firstCurrency,
                capitalCoordinate: capitalCoordinate,
                capital: capital,
                area: positiveArea,
                languages: languagesValues,
                sovereignState: sovereignState
            )
            countries.append(newCountry)
        }
        countries = countries.sorted {$0.name.uppercased() < $1.name.uppercased()}
    }
}

/// A region is a continent.
struct Region: Hashable, Identifiable {
    
    /// Required for conformance to Identifiable.
    var id = UUID()
    
    /// Name of the `Region`.
    var name: String
    
    /// A `String` with the name of the SF Symbol that matches the `Region`.
    var sfSymbol: String
}

/// A collection of regions, shared accross the App.
///
/// I don't think new continents will be discovered soon, so they are hard-coded in the App instead of being generated from the APIs.
let regions = [
    Region(name: "Americas", sfSymbol: "globe.americas.fill"),
    Region(name: "Europe", sfSymbol: "globe.europe.africa.fill"),
    Region(name: "Africa", sfSymbol: "globe.europe.africa.fill"),
    Region(name: "Asia", sfSymbol: "globe.central.south.asia.fill"),
    Region(name: "Oceania", sfSymbol: "globe.asia.australia.fill"),
    Region(name: "Antarctic", sfSymbol: "globe")
]
