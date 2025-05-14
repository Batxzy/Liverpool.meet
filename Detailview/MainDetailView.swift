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

struct ProductHeaderInfo: View {
    let product: Product
    let animateContent: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Maker name
            Text(product.maker)
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 8)
                .foregroundStyle(.white)
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 20)
            
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
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 20)
        }
    }
}

struct ProductInfoPanel: View {
    let product: Product
    @Binding var selectedColor: Color
    @Binding var quantity: Int
    @Binding var selectedOptions: [String: String]
    @Binding var isShowingPromotions: Bool
    let animateContent: Bool
    
    var body: some View {
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
                    SimpleDropdownView(
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
        .opacity(animateContent ? 1 : 0)
        .offset(y: animateContent ? 0 : 60)
    }
}

struct HeaderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button {
                dismiss()
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
    }
}

struct PromoButton: View {
    let product: Product
    @Binding var isShowingPromotions: Bool
    
    var body: some View {
        Button {
            isShowingPromotions = true
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

struct DropdownLabelView: View {
    let optionName: String
    let selectedValue: String
    let isExpanded: Bool
    
    var body: some View {
        HStack {
            Text(selectedValue.isEmpty ? "Select \(optionName)" : selectedValue)
                .foregroundStyle(selectedValue.isEmpty ? .secondary : .primary)
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .foregroundStyle(.secondary)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                .animation(.smooth, value: isExpanded)
        }
    }
}

struct PromotionsSheet: View {
    let promotions: [ProductPromotion]
    @Binding var isShowingPromotions: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Promociones disponibles")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    isShowingPromotions = false
                } label: {
                    Image(systemName: "xmark")
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal,25)
            .padding(.vertical,15)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(promotions) { promotion in
                        PromotionCard(promotion: promotion)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }
}

struct PromotionCard: View {
    let promotion: ProductPromotion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Image(systemName: "tag.fill")
                    .foregroundStyle(.yellow)
                    .font(.headline)
                
                Text(promotion.title)
                    .font(.headline)
                
                Spacer()
                
                // Format date to show day and month
                Text(promotion.validUntil.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(promotion.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// DropdownItemView - Represents a single selectable item
struct DropdownItemView: View {
    let item: OptionItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(item.value)
                    .foregroundStyle(item.available ? .primary : .secondary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
        .disabled(!item.available)
        .opacity(item.available ? 1 : 0.5)
        .padding(.vertical, 4)
    }
}

// DropdownContentView - Contains all the selectable items
struct DropdownContentView: View {
    let options: [OptionItem]
    let selectedOption: String
    let selectionAction: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(options) { item in
                DropdownItemView(
                    item: item,
                    isSelected: selectedOption == item.value
                ) {
                    selectionAction(item.value)
                }
            }
        }
        .padding(.top, 8)
    }
}

// SimpleDropdownView - Main component that ties everything together
struct SimpleDropdownView: View {
    let option: ProductOption
    @Binding var selectedOption: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            Text(option.name)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            // Dropdown container
            disclosureGroup
        }
    }
    
    private var disclosureGroup: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: { dropdownContent },
            label: { dropdownLabel }
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.1))
        )
    }
    
    private var dropdownContent: some View {
        DropdownContentView(
            options: option.options,
            selectedOption: selectedOption
        ) { newValue in
            selectedOption = newValue
            isExpanded = false
        }
    }
    
    private var dropdownLabel: some View {
        DropdownLabelView(
            optionName: option.name,
            selectedValue: selectedOption,
            isExpanded: isExpanded
        )
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
