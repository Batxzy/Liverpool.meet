//
//  MainDetailView.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI

struct ProductDetailsView: View {
    @Binding var product: Product?
    @Binding var showDetailsView: Bool
    var animation: Namespace.ID
    @State private var selectedColor = Color.clear
    @State private var selectedImageIndex = 0
    @State private var isShowingPromotions = false
    @State private var quantity = 1
    @State private var selectedOptions: [String: String] = [:]
    
    var body: some View {
        if let product = product {
            ZStack {
                // Main content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header with back button
                        HStack {
                            Button {
                                withAnimation(.smooth(duration: 0.3)) {
                                    showDetailsView.toggle()
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                            }
                            Spacer()
                            
                            Button {
                                // Cart action
                            } label: {
                                Image(systemName: "cart")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                        
                        // Maker name
                        Text(product.maker)
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .foregroundStyle(.white)
                        
                        // Product name and code
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            Text("Código: \(product.code)")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(.horizontal)
                        
                        // Image carousel
                        ProductImageCarousel(
                            images: product.images,
                            selectedImageIndex: $selectedImageIndex,
                            animation: animation
                        )
                        .padding(.vertical)
                        
                        // Info Panel Content
                        VStack(alignment: .leading, spacing: 20) {
                            // Price
                            Text(product.price)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            // Product options
                            ForEach(product.options) { option in
                                if option.selectionType == .tags {
                                    TagSelectionView(
                                        option: option,
                                        selectedOption: Binding(
                                            get: { selectedOptions[option.name] ?? "" },
                                            set: { selectedOptions[option.name] = $0 }
                                        )
                                    )
                                } else {
                                    DropdownSelectionView(
                                        option: option,
                                        selectedOption: Binding(
                                            get: { selectedOptions[option.name] ?? "" },
                                            set: { selectedOptions[option.name] = $0 }
                                        )
                                    )
                                }
                            }
                            
                            // Quantity picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Cantidad")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                
                                QuantityPicker(
                                    quantity: $quantity,
                                    minQuantity: 1,
                                    maxQuantity: 10
                                )
                            }
                            
                            // Promotions button
                            PromoButton(product: product, isShowingPromotions: $isShowingPromotions)
                            
                            // Store availability
                            StoreAvailabilityView(storeAvailability: product.storeAvailability)
                            
                            // Shipping info
                            ShippingInfoView(product: product)
                            
                            // Buy and add to bag buttons
                            PurchaseButtons(color: selectedColor)
                            
                            // Delivery options
                            DeliveryOptionsView(color: selectedColor)
                                .padding(.bottom, 40)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.background)
                        )
                        .offset(y: -30)
                    }
                }
                .scrollIndicators(.hidden)
                .background(
                    selectedColor
                        .ignoresSafeArea()
                )
                .onAppear {
                    selectedColor = Color(product.images.first ?? "")
                    
                    // Initialize selected options
                    for option in product.options {
                        if let firstAvailable = option.options.first(where: { $0.available }) {
                            selectedOptions[option.name] = firstAvailable.value
                        }
                    }
                }
                
                // Promotions overlay
                if isShowingPromotions {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.smooth) {
                                isShowingPromotions = false
                            }
                        }
                        .transition(.opacity)
                    
                    VStack {
                        Spacer()
                        ProductPromotionsView(
                            promotions: product.promotions,
                            isShowingPromotions: $isShowingPromotions
                        )
                    }
                    .ignoresSafeArea()
                }
            }
            .preferredColorScheme(.light)
        }
    }
}

struct PromoButton: View {
    let product: Product
    @Binding var isShowingPromotions: Bool
    
    var body: some View {
        Button {
            withAnimation(.smooth) {
                isShowingPromotions = true
            }
        } label: {
            HStack {
                Image(systemName: "tag.fill")
                    .foregroundStyle(.yellow)
                
                Text("Ver promociones")
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(product.promotions.count)")
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.yellow)
                    .clipShape(Capsule())
                    .foregroundStyle(.white)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

struct ShippingInfoView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "shippingbox.fill")
                .font(.title2)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.homeDeliveryAvailable ? "Disponible para envío a domicilio" : "No disponible para envío a domicilio")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                if product.freeShipping {
                    Text("Envío gratis")
                        .font(.caption)
                        .foregroundStyle(.green)
                        .fontWeight(.bold)
                }
                
                Text("Precio: \(product.price)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PurchaseButtons: View {
    var color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                // Add to bag action
            } label: {
                Text("Agregar a mi bolsa")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color, lineWidth: 1.5)
                    )
                    .foregroundStyle(color)
            }
            
            Button {
                // Buy now action
            } label: {
                Text("Comprar ahora")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
    }
}

struct DeliveryOptionsView: View {
    var color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Opciones de entrega")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 10) {
                DeliveryOptionButton(
                    title: "Click and Collect",
                    systemImage: "bag.fill",
                    color: color
                )
                
                DeliveryOptionButton(
                    title: "Click and Meet",
                    systemImage: "person.fill",
                    color: color
                )
                
                DeliveryOptionButton(
                    title: "Recibe a domicilio",
                    systemImage: "house.fill",
                    color: color
                )
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct DeliveryOptionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        Button {
            // Delivery option action
        } label: {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(color)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var demoProduct: Product? = Product.placeholders.first
        @State private var showDetails = true
        @Namespace private var animation
        
        var body: some View {
            ProductDetailsView(
                product: $demoProduct,
                showDetailsView: $showDetails,
                animation: animation
            )
        }
    }
    
    return PreviewWrapper()
}
