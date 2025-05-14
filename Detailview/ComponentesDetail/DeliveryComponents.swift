//
//  DeliveryComponents.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI

struct PurchaseButtons: View {
    var color: Color
    
    var body: some View {
        VStack(spacing: 15) {
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
    @State private var selectedOption: DeliveryOption? = nil
    
    enum DeliveryOption: String, Identifiable {
        case delivery = "Recibe a domicilio"
        case meet = "Click & Meet"
        case collect = "Click & Collect"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            DeliveryCardView(
                icon: "house.fill",
                title: "Recibe a domicilio",
                subtitle: "Envío gratis",
                detail: product.price,
                isSelected: selectedOption == .delivery,
                color: color
            ) {
                toggleSelection(.delivery)
            } buttons: {
                if selectedOption == .delivery {
                    PurchaseButtons(color: color)
                }
            }
            
            DeliveryCardView(
                icon: "person.fill",
                title: "Click & Meet",
                subtitle: "Conócelo en tienda",
                detail: "Disponible en: Liverpool Galerías",
                isSelected: selectedOption == .meet,
                hasStatusDot: true,
                hasSwitchStore: true,
                color: color
            ) {
                toggleSelection(.meet)
            } buttons: {
                if selectedOption == .meet {
                    MeetButton(color: color)
                }
            }
            
            DeliveryCardView(
                icon: "bag.fill",
                title: "Click & Collect",
                subtitle: "Recoge en tienda",
                detail: "Liverpool Galerías",
                isSelected: selectedOption == .collect,
                hasWarning: true,
                color: color
            ) {
                toggleSelection(.collect)
            } buttons: {
                if selectedOption == .collect {
                    PurchaseButtons(color: color)
                }
            }
            
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
            
            RecommendedArticlesView()
                .padding(.top, 20)
        }
        .padding(.top, 15)
    }
    
    private func toggleSelection(_ option: DeliveryOption) {
        withAnimation(.bouncy) {
            selectedOption = selectedOption == option ? nil : option
        }
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

struct DeliveryCardView<ButtonContent: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let detail: String
    let isSelected: Bool
    var hasStatusDot: Bool = false
    var hasWarning: Bool = false
    var hasSwitchStore: Bool = false
    let color: Color
    let onTap: () -> Void
    @ViewBuilder let buttons: ButtonContent
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
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
                        .foregroundStyle(title.contains("domicilio") ? .green : .secondary)
                    
                    HStack(spacing: 4) {
                        if hasWarning {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.yellow)
                                .font(.caption)
                            Text("Bajas existencias:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else if hasStatusDot {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 10, height: 10)
                        }
                        
                        Text(detail)
                            .font(title.contains("domicilio") ? .headline : .caption)
                            .fontWeight(title.contains("domicilio") ? .bold : .regular)
                        
                        if hasSwitchStore {
                            Spacer()
                            Button("Cambiar tienda") {
                                // Switch store action
                            }
                            .font(.caption)
                            .foregroundStyle(.blue)
                        }
                    }
                    .padding(.top, title.contains("domicilio") ? 4 : 2)
                }
                
                Spacer()
            }
            
            buttons
                .transition(.push(from: .bottom))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? color : Color.secondary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

struct MeetButton: View {
    var color: Color
    
    var body: some View {
        Button {
            // Add to meetlist action
        } label: {
            Text("Agregar a mi Meetlist")
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

struct ActionButtons: View {
    let option: DeliveryOptionsView.DeliveryOption
    let accentColor: Color
    let isEnabled: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                // Primary action - buy now
            } label: {
                Text("Comprar ahora")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isEnabled ? accentColor : Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .disabled(!isEnabled)
            
            Button {
                // Secondary action - add to bag or meetlist
            } label: {
                Text(option == .meet ? "Agregar a mi Meetlist" : "Agregar a mi bolsa")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isEnabled ? accentColor : Color.gray, lineWidth: 1.5)
                    )
                    .foregroundStyle(isEnabled ? accentColor : Color.gray)
            }
            .buttonStyle(.plain)
            .disabled(!isEnabled)
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
}

struct WishlistButton: View {
    let color: Color
    
    var body: some View {
        Button {
            // Add to wishlist action
        } label: {
            Text("Agregar a mi Wishlist")
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color, lineWidth: 1.5)
                )
                .foregroundStyle(Color.primary)
        }
        .buttonStyle(.plain)
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
