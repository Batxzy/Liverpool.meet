//
//  ObjectModel.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI

struct ProductOption: Identifiable {
    let id = UUID()
    let name: String
    let options: [OptionItem]
    let selectionType: SelectionType
    
    enum SelectionType {
        case dropdown
        case tags
    }
}

struct OptionItem: Identifiable {
    let id = UUID()
    let value: String
    let available: Bool
}

struct StoreAvailability: Identifiable {
    let id = UUID()
    let storeName: String
    let availability: AvailabilityStatus
    let distance: String
    
    enum AvailabilityStatus: String {
        case inStock = "En existencia"
        case limitedStock = "Pocas unidades"
        case outOfStock = "Agotado"
        
        var color: Color {
            switch self {
            case .inStock: return .green
            case .limitedStock: return .yellow
            case .outOfStock: return .red
            }
        }
    }
}

struct ProductPromotion: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let validUntil: Date
}

struct Product: Identifiable, Hashable {
    let id = UUID()
    let maker: String
    let title: String
    let code: String
    let price: String
    let images: [String]
    let options: [ProductOption]
    let promotions: [ProductPromotion]
    let storeAvailability: [StoreAvailability]
    let freeShipping: Bool
    let homeDeliveryAvailable: Bool
    
    // Required for Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    static var placeholders: [Product] {
        [
            Product(
                maker: "Luxury Brand",
                title: "Office Bag",
                code: "LB-OB001",
                price: "$234",
                images: ["ada", "ada", "ada"],
                options: [
                    ProductOption(
                        name: "Color",
                        options: [
                            OptionItem(value: "Black", available: true),
                            OptionItem(value: "Brown", available: true),
                            OptionItem(value: "Blue", available: false)
                        ],
                        selectionType: .tags
                    ),
                    ProductOption(
                        name: "Size",
                        options: [
                            OptionItem(value: "Small", available: true),
                            OptionItem(value: "Medium", available: true),
                            OptionItem(value: "Large", available: true)
                        ],
                        selectionType: .dropdown
                    )
                ],
                promotions: [
                    ProductPromotion(
                        title: "Summer Sale",
                        description: "Get 20% off on all bags this summer",
                        validUntil: Calendar.current.date(byAdding: .month, value: 1, to: Date())!
                    ),
                    ProductPromotion(
                        title: "Free Wallet",
                        description: "Get a free wallet with purchase of any luxury bag",
                        validUntil: Calendar.current.date(byAdding: .day, value: 7, to: Date())!
                    )
                ],
                storeAvailability: [
                    StoreAvailability(storeName: "Downtown Store", availability: .inStock, distance: "2.5 km"),
                    StoreAvailability(storeName: "Mall Plaza", availability: .limitedStock, distance: "4.8 km"),
                    StoreAvailability(storeName: "Fashion District", availability: .outOfStock, distance: "7.3 km")
                ],
                freeShipping: true,
                homeDeliveryAvailable: true
            ),

            Product(
                maker: "Urban Style",
                title: "Shopping Bag",
                code: "US-SB002",
                price: "$199",
                images: ["bag2", "bag2-alt1", "bag2-alt2"],
                options: [
                    ProductOption(
                        name: "Color",
                        options: [
                            OptionItem(value: "Red", available: true),
                            OptionItem(value: "White", available: true),
                            OptionItem(value: "Green", available: true)
                        ],
                        selectionType: .tags
                    )
                ],
                promotions: [
                    ProductPromotion(
                        title: "Weekend Discount",
                        description: "15% off on weekend purchases",
                        validUntil: Calendar.current.date(byAdding: .day, value: 10, to: Date())!
                    )
                ],
                storeAvailability: [
                    StoreAvailability(storeName: "Central Mall", availability: .inStock, distance: "1.2 km"),
                    StoreAvailability(storeName: "City Center", availability: .outOfStock, distance: "3.7 km")
                ],
                freeShipping: false,
                homeDeliveryAvailable: true
            )
        ]
    }
}


