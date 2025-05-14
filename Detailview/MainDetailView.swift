//
//  MainDetailView.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

extension View {
    func debugStroke(_ color: Color = .red) -> some View {
        self.overlay(Rectangle().stroke(color, lineWidth: 1))
    }
}

import SwiftUI


struct EnhancedProductDetailsView: View {
    @Binding var product: Product?
    var animation: Namespace.ID
    @State private var selectedColor = Color.clear
    @State private var selectedImageIndex = 0
    @State private var isShowingPromotions = false
    @State private var quantity = 1
    @State private var selectedOptions: [String: String] = [:]
    @State private var animateContent = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if let product = product {
            ZStack {
                // Background layer
                Color.accentColor
                    .ignoresSafeArea()
                
                // Main content
                ScrollView {
                    HeaderView()

                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 10) {
                            ProductHeaderInfo(
                                product: product,
                                animateContent: animateContent
                            )
                            
                            // Image with zoom transition
                            ZStack {
                                Image(product.images[selectedImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .padding(20)
                            }
                            .frame(height: 300)
                            .frame(width: .infinity)
                            .clipped()
                        }
                        
                       
                        
                        // Info Panel Content
                        ProductInfoPanel(
                            product: product,
                            selectedColor: $selectedColor,
                            quantity: $quantity,
                            selectedOptions: $selectedOptions,
                            isShowingPromotions: $isShowingPromotions,
                            animateContent: animateContent
                        )
                    }
                }
                .scrollIndicators(.hidden)
                .onAppear {
                    selectedColor = Color(product.images.first ?? "")
                    
                    // Initialize selected options
                    for option in product.options {
                        if let firstAvailable = option.options.first(where: { $0.available }) {
                            selectedOptions[option.name] = firstAvailable.value
                        }
                    }
                    
                    // Animate content after a slight delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.snappy(duration: 0.4)) {
                            animateContent = true
                        }
                    }
                }
            }
            .preferredColorScheme(.light)
            .sheet(isPresented: $isShowingPromotions) {
                PromotionsSheet(
                    promotions: product.promotions,
                    isShowingPromotions: $isShowingPromotions
                )
                .presentationDetents([.medium, .large])
                .presentationCornerRadius(30)
                .presentationDragIndicator(.visible)
            }
        }
    }
}


#Preview("Product Details") {
    struct DetailsPreview: View {
        @State private var product: Product? = Product.placeholders.first
        @Namespace private var animation
        
        var body: some View {
            EnhancedProductDetailsView(
                product: $product,
                animation: animation
            )
        }
    }
    
    return DetailsPreview()
}
