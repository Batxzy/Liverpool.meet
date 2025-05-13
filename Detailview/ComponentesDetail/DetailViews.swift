//
//  DetailViews.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI


struct ProductPromotionsView: View {
    let promotions: [ProductPromotion]
    @Binding var isShowingPromotions: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Promociones")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    withAnimation(.smooth) {
                        isShowingPromotions = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            
            Divider()
            
            if promotions.isEmpty {
                VStack {
                    Spacer()
                    Text("No hay promociones disponibles")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .frame(height: 200)
            } else {
                List {
                    ForEach(promotions) { promotion in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(promotion.title)
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text(promotion.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text("Válido hasta: \(formatDate(promotion.validUntil))")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .frame(maxWidth: .infinity, maxHeight: 400)
        .padding()
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct StoreAvailabilityView: View {
    let storeAvailability: [StoreAvailability]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Disponibilidad en tienda")
                .font(.headline)
                .foregroundStyle(.primary)
            
            ForEach(storeAvailability) { store in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(store.storeName)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                        
                        Text(store.availability.rawValue)
                            .font(.caption)
                            .foregroundStyle(store.availability.color)
                    }
                    
                    Spacer()
                    
                    Text(store.distance)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.secondary.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
