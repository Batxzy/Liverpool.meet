//
//  DiscoverView.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI


struct HomeContentView: View {
    @Binding var selectedTab: SwipeMenu
    var animation: Namespace.ID
    @Binding var selectedProduct: Product?
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                VStack {
                    SectionTitle()
                        .padding()
                    
                    SwipeMenuView(selectedTab: $selectedTab, animation: animation)
                    
                    EnhancedProductGridView(
                        selectedProduct: $selectedProduct,
                        animation: animation
                    )
                    .padding()
                }
            }
            .scrollIndicators(.hidden)
        }
        .background(Color.black.opacity(0.05).ignoresSafeArea())
        .frame(height: .infinity)
    }
}


struct SectionTitle: View {
    var body: some View {
        HStack {
            Text("Women")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundStyle(.primary)
            Spacer()
        }
    }
}

struct SwipeMenuView: View {
    @Binding var selectedTab: SwipeMenu
    var animation: Namespace.ID
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(SwipeMenu.allCases, id: \.self) { tab in
                    TabButton(tabItem: tab, selectedTab: $selectedTab, animation: animation)
                }
            }
            .padding(.horizontal)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

struct TabButton: View {
    let tabItem: SwipeMenu
    @Binding var selectedTab: SwipeMenu
    var animation: Namespace.ID

    var body: some View {
        Button {
            withAnimation(.bouncy()) {
                selectedTab = tabItem
            }
        } label: {
            VStack(spacing: 6) {
                Text(tabItem.description)
                    .fontWeight(.heavy)
                    .foregroundStyle(tabItem == selectedTab ? .primary : .secondary)
                
                if tabItem == selectedTab {
                    Capsule()
                        .fill(Color.primary)
                        .frame(width: 40, height: 4)
                        .matchedGeometryEffect(id: "TAB", in: animation)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct EnhancedProductGridView: View {
    @Binding var selectedProduct: Product?
    var animation: Namespace.ID
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 15)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(Product.placeholders) { product in
                Button {
                    selectedProduct = product
                } label: {
                    EnhancedProductGridItem(product: product, animation: animation)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct EnhancedProductGridItem: View {
    let product: Product
    var animation: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                Color(product.images.first ?? "")
                    .opacity(0.8)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Image(product.images.first ?? "")
                    .resizable()
                    .scaledToFit()
                    .padding(20)
                    .matchedTransitionSource(id: "productTransition", in: animation)
            }
            .aspectRatio(1, contentMode: .fit)
            
            Text(product.maker)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Text(product.title)
                .fontWeight(.bold)
                .lineLimit(1)
                .foregroundStyle(.primary)
            
            Text(product.price)
                .fontWeight(.heavy)
                .foregroundStyle(.primary)
        }
        .padding(8)
        .background(.background.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

enum SwipeMenu: String, CaseIterable {
    case handBag, jewelry, footwear, dresses, beauty
    
    var description: String {
        switch self {
        case .handBag: return "Hand Bag"
        case .jewelry: return "Jewelry"
        case .footwear: return "Footwear"
        case .dresses: return "Dresses"
        case .beauty: return "Beauty"
        }
    }
}

// MARK: - Preview
