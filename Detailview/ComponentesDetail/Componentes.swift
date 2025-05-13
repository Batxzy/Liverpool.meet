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
    @State private var isZoomed = false
    
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
                                withAnimation(.smooth(duration: 0.3)) {
                                    isZoomed = true
                                }
                            }
                    }
                    .containerRelativeFrame(.horizontal)
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
            
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
        .fullScreenCover(isPresented: $isZoomed) {
            ZoomedImageView(
                image: images[selectedImageIndex],
                isZoomed: $isZoomed
            )
        }
    }
}

struct ZoomedImageView: View {
    let image: String
    @Binding var isZoomed: Bool
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            Image(image)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = lastScale * value
                        }
                        .onEnded { _ in
                            lastScale = scale
                        }
                )
                .onTapGesture(count: 2) {
                    withAnimation(.smooth) {
                        if scale > 1 {
                            scale = 1.0
                            offset = .zero
                            lastScale = 1.0
                            lastOffset = .zero
                        } else {
                            scale = 2.0
                            lastScale = 2.0
                        }
                    }
                }
                .transition(.opacity)
            
            VStack {
                HStack {
                    Spacer()
                    closeButton
                }
                Spacer()
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .statusBarHidden()
    }
    
    private var closeButton: some View {
        Button {
            withAnimation(.smooth) {
                isZoomed = false
            }
        } label: {
            Image(systemName: "xmark")
                .font(.title2)
                .foregroundStyle(.white)
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
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

struct PromotionsView: View {
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
