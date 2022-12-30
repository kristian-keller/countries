//
//  EmptyPlaceholderModifier.swift
//  Countries Iliad
//
//  Created by Kristian Keller on 28/12/22.
//

import SwiftUI

/// A SwiftUI `ViewModifier` to be used with `List`.
///
/// `List` does not provide a way to indicate that the list is empty, a ViewModifier is needed to add this behavior.
struct EmptyPlaceholderModifier<Items: Collection>: ViewModifier {
    
    let items: Items
    let placeholder: AnyView

    @ViewBuilder func body(content: Content) -> some View {
        if !items.isEmpty {
            content
        } else {
            placeholder
        }
    }
}

extension View {
    func emptyPlaceholder<Items: Collection, PlaceholderView: View>(_ items: Items, _ placeholder: @escaping () -> PlaceholderView) -> some View {
        modifier(EmptyPlaceholderModifier(items: items, placeholder: AnyView(placeholder())))
    }
}
