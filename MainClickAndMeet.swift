//
//  MainClickAndMeet+.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI
import Foundation
import CoreNFC

struct ClickAndMeetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingScanSheet = false
    @State private var scanComplete = false
    
    private let themeColor = Color(hex: "E81EA0")
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                VStack(spacing: 20) {
                    StoreCardView(
                        storeName: "Liverpool Galerías",
                        itemCount: 3,
                        onViewTapped: { print("Ver button tapped") },
                        onScanTapped: { showingScanSheet = true }
                    )
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingScanSheet) {
            ScanSheet(isShowing: $showingScanSheet, scanComplete: $scanComplete)
        }
    }
}


struct StoreCardView: View {
    let storeName: String
    let itemCount: Int
    let onViewTapped: () -> Void
    let onScanTapped: () -> Void
    
    private let themeColor = Color(hex: "E81EA0")
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image("Bag3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(storeName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("\(itemCount) artículos")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 10) {
                        Button(action: onViewTapped) {
                            Text("Ver")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundStyle(themeColor)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(themeColor, lineWidth: 1)
                                )
                        }
                        
                        Button(action: onScanTapped) {
                            Text("Escanear en Tienda")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundStyle(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(themeColor)
                                )
                        }
                    }
                }
            }
            .padding()
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
        )
    }
}

struct ScanSheet: View {
    @Binding var isShowing: Bool
    @Binding var scanComplete: Bool
    
    private let accentBlue = Color(red: 0.23, green: 0.51, blue: 0.96)
    private let magenta = Color(red: 0.91, green: 0.12, blue: 0.63)
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Click & Meet")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(magenta)
            
            // Split view content
            GeometryReader { geo in
                HStack(spacing: 0) {
                    // Left side - Scanning instructions
                    ScanReadyView(accentBlue: accentBlue)
                        .frame(width: geo.size.width/2)
                        .background(.white)
                    
                    // Right side - Success confirmation
                    ScanCompleteView(accentBlue: accentBlue)
                        .frame(width: geo.size.width/2)
                        .background(.black)
                }
            }
        }
        .presentationDetents([.height(280)])
        .presentationBackground(.clear)
    }
}

struct ScanReadyView: View {
    let accentBlue: Color
    
    var body: some View {
        VStack {
            Text("Listo para escanear")
                .font(.title3.weight(.bold))
                .padding(.top, 20)
            
            Spacer().frame(height: 30)
            
            ZStack {
                Circle()
                    .stroke(accentBlue, lineWidth: 3)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "iphone")
                    .font(.system(size: 32))
                    .foregroundStyle(accentBlue)
            }
            
            Spacer().frame(height: 20)
            
            Text("Coloca tu dispositivo cerca del tag NFC")
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct ScanCompleteView: View {
    let accentBlue: Color
    
    var body: some View {
        VStack {
            Text("¡Datos recibidos!")
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
                .padding(.top, 20)
            
            Spacer().frame(height: 30)
            
            ZStack {
                Circle()
                    .stroke(accentBlue, lineWidth: 3)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 32))
                    .foregroundStyle(accentBlue)
            }
            
            Spacer().frame(height: 20)
            
            Text("El vendedor te mostrará los productos")
                .font(.callout)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
