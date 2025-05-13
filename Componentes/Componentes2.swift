//
//  Componentes2.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI



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

