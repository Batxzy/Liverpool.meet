//
//  HeaderView.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI

struct ReusableHeaderView: View {
    var safeAreaTop: CGFloat
    @Binding var offsetY: CGFloat
    @Binding var showSearchBar: Bool
    
    var headerColor: Color = .red
    var searchBarPlaceholder: String = "Search"
    
    var onLocationTapped: () -> Void
    var onActionTapped: () -> Void
    var onSearchTapped: () -> Void
    var onLikeTapped: () -> Void
    var onWishlistTapped: () -> Void
    
    var body: some View {
        let progress = -(offsetY / 80) > 1 ? -1 : (offsetY > 0 ? 0 : (offsetY / 80))
        
        VStack(spacing: 15) {
            HeaderTopSection(
                progress: progress,
                showSearchBar: $showSearchBar,
                searchBarPlaceholder: searchBarPlaceholder,
                onLikeTapped: onLikeTapped,
                onWishlistTapped: onWishlistTapped
            )
            
            HeaderButtonsSection(
                progress: progress,
                offsetY: offsetY,
                showSearchBar: showSearchBar,
                headerColor: headerColor,
                onLocationTapped: onLocationTapped,
                onActionTapped: onActionTapped
            )
        }
        .overlay(alignment: .topLeading) {
            SearchToggleButton(
                progress: progress,
                showSearchBar: $showSearchBar,
                onSearchTapped: onSearchTapped
            )
        }
        .animation(.easeInOut(duration: 0.2), value: showSearchBar)
        .environment(\.colorScheme, .dark)
        .padding([.horizontal, .bottom], 15)
        .padding(.top, safeAreaTop + 10)
        .background {
            Rectangle()
                .fill(headerColor.gradient)
                .padding(.bottom, -progress * 85)
        }
    }
}

struct HeaderTopSection: View {
    var progress: CGFloat
    @Binding var showSearchBar: Bool
    var searchBarPlaceholder: String
    var onLikeTapped: () -> Void
    var onWishlistTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Search field
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .offset(x: progress * 5)
                
                TextField(searchBarPlaceholder, text: .constant(""))
                    .tint(.white)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.black)
                    .opacity(0.15)
            }
            .opacity(showSearchBar ? 1 : 1 + progress)
            
            if !showSearchBar {
                // Like button
                Button(action: onLikeTapped) {
                    Image(systemName: "heart")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .opacity(1 + progress)
                
                // Wishlist button
                Button(action: onWishlistTapped) {
                    Image(systemName: "cart")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .opacity(1 + progress)
            } else {
                // Close search button
                Button {
                    showSearchBar = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct HeaderButtonsSection: View {
    var progress: CGFloat
    var offsetY: CGFloat
    var showSearchBar: Bool
    var headerColor: Color
    var onLocationTapped: () -> Void
    var onActionTapped: () -> Void
    
    var body: some View {
        let buttonsOpacity = offsetY < -20 ? max(0, 1 + (offsetY + 20) / 40) : 1
        
        HStack(spacing: 0) {
            // Location picker button
            HeaderActionButton(
                symbolImage: "location.fill",
                title: "Location",
                progress: progress,
                headerColor: headerColor,
                action: onLocationTapped
            )
            
            // General action button
            HeaderActionButton(
                symbolImage: "square.grid.2x2",
                title: "Browse",
                progress: progress,
                headerColor: headerColor,
                action: onActionTapped
            )
        }
        .padding(.horizontal, -progress * 50)
        .padding(.top, 10)
        .offset(y: progress * 65)
        .opacity(showSearchBar ? 0 : 1)
        .opacity(buttonsOpacity)
    }
}

struct HeaderActionButton: View {
    var symbolImage: String
    var title: String
    var progress: CGFloat
    var headerColor: Color
    var action: () -> Void
    
    var body: some View {
        let buttonProgress = -(progress / 40) > 1 ? -1 : (progress > 0 ? 0 : (progress / 40))
        
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: symbolImage)
                    .fontWeight(.semibold)
                    .foregroundColor(headerColor)
                    .frame(width: 35, height: 35)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.white)
                    }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .opacity(1 + buttonProgress)
            .overlay {
                Image(systemName: symbolImage)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(-buttonProgress)
                    .offset(y: -10)
            }
        }
    }
}

struct SearchToggleButton: View {
    var progress: CGFloat
    @Binding var showSearchBar: Bool
    var onSearchTapped: () -> Void
    
    var body: some View {
        Button {
            showSearchBar = true
            onSearchTapped()
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .offset(x: 13, y: 10)
        .opacity(showSearchBar ? 0 : -progress)
        .offset(x: progress * 5)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        ReusableHeaderView(
            safeAreaTop: 47,
            offsetY: .constant(0),
            showSearchBar: .constant(false),
            headerColor: .red,
            searchBarPlaceholder: "Search",
            onLocationTapped: {},
            onActionTapped: {},
            onSearchTapped: {},
            onLikeTapped: {},
            onWishlistTapped: {}
        )
    }
}
