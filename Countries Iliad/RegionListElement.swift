//
//  RegionListElement.swift
//  Countries Iliad
//
//  Created by Kristian Keller on 28/12/22.
//

import SwiftUI

/// An element from the list of regions in the `FilterPopover`.
struct RegionListElement: View {
    
    /// The `Region`.
    var region: Region
    
    /// A checkmark is showed.
    var isSelected: Bool
    
    /// In `FilterPopover` handles the selection of a region.
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Image(systemName: region.sfSymbol)
                Text(region.name)
                    .foregroundColor(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
        .buttonStyle(.bordered)
        .padding(.horizontal)
    }
}

struct RegionListElement_Previews: PreviewProvider {
    static var previews: some View {
        RegionListElement(region: regions.first!, isSelected: true, action: {})
            .previewDisplayName("Selected")
        RegionListElement(region: regions.last!, isSelected: false, action: {})
            .previewDisplayName("Not selected")
    }
}
