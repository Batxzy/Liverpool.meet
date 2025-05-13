//
//  Componentes.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI

struct ProductImageCarousel: View {
    let images: [String]
    @Binding var selectedImageIndex: Int
    var animation: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedImageIndex) {
                ForEach(images.indices, id: \.self) { index in
                    ZStack {
                        Color(images[index])
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        Image(images[index])
                            .resizable()
                            .scaledToFit()
                            .padding(20)
                            .matchedGeometryEffect(id: images[index], in: animation)
                            .onTapGesture {
                                // Could trigger detailed image view here
                            }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
            
            // Custom indicators
            HStack(spacing: 8) {
                ForEach(images.indices, id: \.self) { index in
                    Circle()
                        .fill(selectedImageIndex == index ? Color.primary : Color.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(selectedImageIndex == index ? 1.2 : 1)
                        .animation(.smooth, value: selectedImageIndex)
                        .onTapGesture {
                            selectedImageIndex = index
                        }
                }
            }
            .padding(.bottom, 8)
        }
    }
}

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
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(selectedOption == item.value ? Color.accentColor : Color.secondary.opacity(0.3), lineWidth: 1)
                                        )
                                )
                                .foregroundStyle(selectedOption == item.value ? .white : (item.available ? .primary : .secondary.opacity(0.5)))
                                .opacity(item.available ? 1 : 0.5)
                        }
                        .disabled(!item.available)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

