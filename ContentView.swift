//
//  ContentView.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: SwipeMenu = .handBag
    @Namespace private var animation
    @State private var selectedProduct: Product?
    
    var body: some View {
        NavigationStack {
            HomeContentView(
                selectedTab: $selectedTab,
                animation: animation,
                selectedProduct: $selectedProduct
            )
            .navigationDestination(item: $selectedProduct) { product in
                EnhancedProductDetailsView(
                    product: $selectedProduct,
                    animation: animation
                )
                .navigationTransition(.zoom(sourceID: "productTransition", in: animation))
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
