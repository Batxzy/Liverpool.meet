//
//  ContentView.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: SwipeMenu = .handBag
    @Namespace private var animation
    @State private var selectedProduct: Product?
    @State private var offsetY: CGFloat = 0
    @State private var showSearchBar: Bool = false
    @State private var reset: Bool = false
    @Environment(\.isDragging) private var isDragging
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                GeometryReader { proxy in
                    let safeAreaTop = proxy.safeAreaInsets.top
                    
                    ScrollViewReader { scrollProxy in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 0) {
                                // Header
                                ReusableHeaderView(
                                    safeAreaTop: safeAreaTop,
                                    offsetY: $offsetY,
                                    showSearchBar: $showSearchBar,
                                    headerColor: .accent,
                                    searchBarPlaceholder: "Search products",
                                    onLocationTapped: {},
                                    onActionTapped: {},
                                    onSearchTapped: {},
                                    onLikeTapped: {},
                                    onWishlistTapped: {}
                                )
                                .offset(y: -offsetY)
                                .zIndex(1)
                                
                                // Main content from HomeContentView
                                HomeContentView(
                                    selectedTab: $selectedTab,
                                    animation: animation,
                                    selectedProduct: $selectedProduct
                                )
                                .padding(.bottom, 80) // For tab bar
                                .zIndex(0)
                            }
                            .id("SCROLLVIEW")
                            .offset(coordinateSpace: .named("SCROLL")) { offset in
                                offsetY = offset
                                
                                withAnimation(.none) {
                                    showSearchBar = (-offset > 80) && showSearchBar
                                }
                                
                                if !isDragging && -offsetY < 80 {
                                    if !reset {
                                        reset = true
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            scrollProxy.scrollTo("SCROLLVIEW", anchor: .top)
                                        }
                                    }
                                } else {
                                    reset = false
                                }
                            }
                        }
                        .onChange(of: isDragging) { newValue in
                            if !newValue && -offsetY < 80 {
                                reset = true
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    scrollProxy.scrollTo("SCROLLVIEW", anchor: .top)
                                }
                            }
                        }
                        .coordinateSpace(name: "SCROLL")
                        .ignoresSafeArea(edges: .top)
                    }
                }
            }
            .navigationDestination(item: $selectedProduct) { product in
                EnhancedProductDetailsView(
                    product: $selectedProduct,
                    animation: animation
                )
                .navigationBarBackButtonHidden(true)
                .navigationTransition(.zoom(sourceID: "productTransition", in: animation))
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
