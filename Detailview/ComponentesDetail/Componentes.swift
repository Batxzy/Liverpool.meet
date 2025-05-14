//
//  Componentes.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI

struct TagSelectionView: View {
    let option: ProductOption
    @Binding var selectedOption: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(option.name)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(option.options) { item in
                        Button {
                            if item.available {
                                selectedOption = item.value
                            }
                        } label: {
                            Text(item.value)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedOption == item.value ? Color.accentColor : Color.secondary.opacity(0.1))
                                )
                                .foregroundStyle(selectedOption == item.value ? .white : (item.available ? .primary : .secondary.opacity(0.5)))
                                .opacity(item.available ? 1 : 0.5)
                        }
                        .disabled(!item.available)
                        .buttonStyle(.plain)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

struct QuantityPicker: View {
    @Binding var quantity: Int
    let minQuantity: Int
    let maxQuantity: Int
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                if quantity > minQuantity {
                    quantity -= 1
                }
            } label: {
                Image(systemName: "minus")
                    .font(.title3)
                    .foregroundStyle(quantity > minQuantity ? .primary : .secondary)
                    .frame(width: 35, height: 35)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            }
            .disabled(quantity <= minQuantity)
            
            Text("\(quantity)")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .frame(minWidth: 40)
            
            Button {
                if quantity < maxQuantity {
                    quantity += 1
                }
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .foregroundStyle(quantity < maxQuantity ? .primary : .secondary)
                    .frame(width: 35, height: 35)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            }
            .disabled(quantity >= maxQuantity)
        }
    }
}

struct DropdownContent: View {
    let option: ProductOption
    @Binding var selectedOption: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(option.options) { item in
                DropdownItem(
                    item: item,
                    isSelected: selectedOption == item.value,
                    action: {
                        selectedOption = item.value
                        isExpanded = false
                    }
                )
            }
        }
        .padding(.top, 8)
    }
}

struct DropdownItem: View {
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
                    .symbolEffect(.bounce, options: .speed(1.5), value: isSelected)
                }
            }
        }
        .disabled(!item.available)
        .opacity(item.available ? 1 : 0.5)
        .padding(.vertical, 4)
    }
}

struct DropdownLabel: View {
    let option: ProductOption
    let selectedOption: String
    let isExpanded: Bool
    
    var body: some View {
        HStack {
            Text(selectedOption.isEmpty ? "Select \(option.name)" : selectedOption)
                .foregroundStyle(selectedOption.isEmpty ? .secondary : .primary)
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .foregroundStyle(.secondary)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                .animation(.smooth, value: isExpanded)
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
            
           
            
            // Delivery options and recommended articles
            DeliveryOptionsView(product: product, color: selectedColor)
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
    let product: Product
    let color: Color
    @State private var activeTab: DeliveryOption = .delivery
    
    enum DeliveryOption: String, CaseIterable {
        case delivery = "Recibe a domicilio"
        case meet = "Click & Meet"
        case collect = "Click & Collect"
    }
    
    var body: some View {
        VStack(spacing: 15) {
            // Delivery option cards
            DeliveryCard(
                title: "Recibe a domicilio",
                subtitle: "Envío gratis",
                price: product.price,
                color: .accent,
                primaryButtonLabel: "Comprar ahora",
                secondaryButtonLabel: "Agregar a mi bolsa"
            )
            
            ClickMeetCard(
                color: .accent,
                storeName: "Liverpool Galerías",
                hasAvailability: true
            )
            
            ClickCollectCard(
                storeName: "Liverpool Galerías",
                hasLowStock: true,
                color: .gray
            )
            
            // Add to wishlist button
            Button {
                // Add to wishlist action
            } label: {
                Text("Agregar a mi Wishlist")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1.5)
                    )
                    .foregroundStyle(Color.primary)
            }
            .buttonStyle(.plain)
            .padding(.top, 5)
            
            // Recommended Articles
            RecommendedArticlesView()
                .padding(.top, 20)
        }
        .padding(.top, 15)
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
            Text(option.name)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            // Custom disclosure group without duplicate chevron
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: { dropdownContent },
                label: { customLabel }
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.secondary.opacity(0.1)))
            .buttonStyle(.plain)
        }
    }
    
    private var customLabel: some View {
        HStack {
            Text(selectedOption.isEmpty ? "Select \(option.name)" : selectedOption)
                .foregroundStyle(selectedOption.isEmpty ? .secondary : .primary)
        }
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
}



struct DeliveryCard: View {
    let title: String
    let subtitle: String
    let price: String
    let color: Color
    let primaryButtonLabel: String
    let secondaryButtonLabel: String
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.green)
                    
                    Text(price)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 4)
                }
                
                Spacer()
            }
            
            // Buttons
            Button {
                // Primary action
            } label: {
                Text(primaryButtonLabel)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            
            Button {
                // Secondary action
            } label: {
                Text(secondaryButtonLabel)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(color, lineWidth: 1.5)
                    )
                    .foregroundStyle(color)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct ClickMeetCard: View {
    let color: Color
    let storeName: String
    let hasAvailability: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Click & Meet")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("Conócelo en tienda")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(hasAvailability ? Color.green : Color.red)
                            .frame(width: 10, height: 10)
                        
                        Text("Disponible en: \(storeName)")
                            .font(.caption)
                        
                        Spacer()
                        
                        Button("Cambiar tienda") {
                            // Change store action
                        }
                        .font(.caption)
                        .foregroundStyle(.blue)
                    }
                    .padding(.top, 4)
                }
            }
            
            // Meetlist button
            Button {
                // Add to meetlist action
            } label: {
                Text("Agregar a mi Meetlist")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct ClickCollectCard: View {
    let storeName: String
    let hasLowStock: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "bag.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Click & Collect")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("Recoge en tienda")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 4) {
                        if hasLowStock {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.yellow)
                                .font(.caption)
                            
                            Text("Bajas existencias:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text(storeName)
                            .font(.caption)
                    }
                    .padding(.top, 4)
                }
            }
            
            // Buttons
            Button {
                // Primary action
            } label: {
                Text("Comprar ahora")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .foregroundStyle(.primary)
            }
            .buttonStyle(.plain)
            
            Button {
                // Secondary action
            } label: {
                Text("Agregar a mi bolsa")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.5), lineWidth: 1.5)
                    )
                    .foregroundStyle(.primary)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct RecommendedArticlesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Artículos similares")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(0..<6, id: \.self) { _ in
                    RecommendedProductItem()
                }
            }
        }
    }
}

struct RecommendedProductItem: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Rectangle()
                .fill(Color.secondary.opacity(0.2))
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
