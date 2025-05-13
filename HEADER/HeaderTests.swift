//
//  HeaderTests.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI

struct HeaderTestView: View {
    @State private var offsetY: CGFloat = 0
    @State private var showSearchBar: Bool = false
    @State private var activeTab: TabItem = .home
    @State private var reset: Bool = false
    @Environment(\.isDragging) private var isDragging
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { proxy in
                let safeAreaTop = proxy.safeAreaInsets.top
                
                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ReusableHeaderView(
                                safeAreaTop: safeAreaTop,
                                offsetY: $offsetY,
                                showSearchBar: $showSearchBar,
                                headerColor: .indigo,
                                searchBarPlaceholder: "Search",
                                onLocationTapped: {},
                                onActionTapped: {},
                                onSearchTapped: {},
                                onLikeTapped: {},
                                onWishlistTapped: {}
                            )
                            .offset(y: -offsetY)
                            .zIndex(1)
                            
                            // Content cards
                            LazyVStack(spacing: 16) {
                                ForEach(0..<20) { index in
                                    ContentCard(index: index, selectedTab: activeTab.index)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 100) // Extra padding for tab bar
                            .padding(.top, 15)
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
            
            // Tab bar overlay
            InteractiveTabBar(activeTab: $activeTab)
        }
    }
}

struct ContentCard: View {
    let index: Int
    let selectedTab: Int
    
    var body: some View {
        let colors: [Color] = [.blue, .green, .orange, .purple]
        let tabNames = ["Home", "Search", "Notifications", "Settings"]
        
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Item #\(index + 1)")
                    .font(.headline)
                
                Spacer()
                
                Text(Date.now, format: .dateTime.hour().minute())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("This is sample content for the \(tabNames[min(selectedTab, tabNames.count-1)]) section.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if index % 3 == 0 {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(colors[min(selectedTab, colors.count-1)].opacity(0.1))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(colors[min(selectedTab, colors.count-1)].opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    HeaderTestView()
        .environment(\.isDragging, false)
}

