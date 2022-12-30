//
//  FilterPopover.swift
//  Countries Iliad
//
//  Created by Kristian Keller on 28/12/22.
//

import SwiftUI

/// A View that is showed when the filter button is tapped.
///
/// Shows a list of continents that can be selected. Multiple continents can be selected.
struct FilterPopover: View {
    
    /// The collection of selected regions, passed back to the parent.
    @Binding var selectedRegions: [Region]
    
    /// Show or hide the Popover.
    @Binding var showingPopover: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Filter by continent")
                        .bold()
                    Spacer()
                    Button("Done") {
                        showingPopover.toggle()
                    }
                }
                .padding()
            }
            ForEach(regions) { region in
                RegionListElement(region: region, isSelected: selectedRegions.contains(region)) {
                    if selectedRegions.contains(region) {
                        selectedRegions.removeAll { $0 == region }
                    } else {
                        selectedRegions.append(region)
                    }
                }
            }
        }
        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
    }
}

struct FilterPopover_Previews: PreviewProvider {
    static var previews: some View {
        FilterPopover(selectedRegions: .constant([]), showingPopover: .constant(true))
            .previewDisplayName("No selection")
        FilterPopover(selectedRegions: .constant([regions.first!, regions.last!]), showingPopover: .constant(true))
            .previewDisplayName("Two selected")
    }
}
