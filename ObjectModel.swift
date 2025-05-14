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
                    maker: "Elegancia",
                    title: "Bolso de Oficina",
                    code: "ELG-BO001",
                    price: "$234",
                    images: ["bag1", "bag1-detail", "bag1-alt"],
                    options: [
                        ProductOption(
                            name: "Color",
                            options: [
                                OptionItem(value: "Negro", available: true),
                                OptionItem(value: "Marrón", available: true),
                                OptionItem(value: "Azul", available: false)
                            ],
                            selectionType: .tags
                        ),
                        ProductOption(
                            name: "Tamaño",
                            options: [
                                OptionItem(value: "Pequeño", available: true),
                                OptionItem(value: "Mediano", available: true),
                                OptionItem(value: "Grande", available: true)
                            ],
                            selectionType: .dropdown
                        )
                    ],
                    promotions: [
                        ProductPromotion(
                            title: "Oferta de Verano",
                            description: "20% de descuento en todos los bolsos este verano",
                            validUntil: Calendar.current.date(byAdding: .month, value: 1, to: Date())!
                        ),
                        ProductPromotion(
                            title: "Cartera Gratis",
                            description: "Recibe una cartera gratis con la compra de cualquier bolso de lujo",
                            validUntil: Calendar.current.date(byAdding: .day, value: 7, to: Date())!
                        )
                    ],
                    storeAvailability: [
                        StoreAvailability(storeName: "Tienda Centro", availability: .inStock, distance: "2.5 km"),
                        StoreAvailability(storeName: "Plaza Comercial", availability: .limitedStock, distance: "4.8 km"),
                        StoreAvailability(storeName: "Distrito de Moda", availability: .outOfStock, distance: "7.3 km")
                    ],
                    freeShipping: true,
                    homeDeliveryAvailable: true
                ),
                
                Product(
                    maker: "Estilo Urbano",
                    title: "Bolso de Compras",
                    code: "EU-BC002",
                    price: "$199",
                    images: ["bag2", "bag2-detail", "bag2-alt"],
                    options: [
                        ProductOption(
                            name: "Color",
                            options: [
                                OptionItem(value: "Rojo", available: true),
                                OptionItem(value: "Blanco", available: true),
                                OptionItem(value: "Verde", available: true)
                            ],
                            selectionType: .tags
                        )
                    ],
                    promotions: [
                        ProductPromotion(
                            title: "Descuento de Fin de Semana",
                            description: "15% de descuento en compras de fin de semana",
                            validUntil: Calendar.current.date(byAdding: .day, value: 10, to: Date())!
                        )
                    ],
                    storeAvailability: [
                        StoreAvailability(storeName: "Centro Comercial", availability: .inStock, distance: "1.2 km"),
                        StoreAvailability(storeName: "Centro Ciudad", availability: .outOfStock, distance: "3.7 km")
                    ],
                    freeShipping: false,
                    homeDeliveryAvailable: true
                ),
                
                Product(
                    maker: "Glamour",
                    title: "Bolso Tote Diseñador",
                    code: "GLM-TD003",
                    price: "$329",
                    images: ["tote1", "tote1-detail", "tote1-alt"],
                    options: [
                        ProductOption(
                            name: "Color",
                            options: [
                                OptionItem(value: "Crema", available: true),
                                OptionItem(value: "Azul Marino", available: true),
                                OptionItem(value: "Burdeos", available: true)
                            ],
                            selectionType: .tags
                        ),
                        ProductOption(
                            name: "Material",
                            options: [
                                OptionItem(value: "Cuero", available: true),
                                OptionItem(value: "Lona", available: true)
                            ],
                            selectionType: .dropdown
                        )
                    ],
                    promotions: [
                        ProductPromotion(
                            title: "Acceso VIP",
                            description: "Acceso anticipado a nueva colección para miembros VIP",
                            validUntil: Calendar.current.date(byAdding: .month, value: 2, to: Date())!
                        )
                    ],
                    storeAvailability: [
                        StoreAvailability(storeName: "Avenida de Lujo", availability: .inStock, distance: "3.1 km"),
                        StoreAvailability(storeName: "Outlet de Diseñador", availability: .inStock, distance: "8.2 km")
                    ],
                    freeShipping: true,
                    homeDeliveryAvailable: true
                ),
                
                Product(
                    maker: "Moda Metropolitana",
                    title: "Mini Bolso Cruzado",
                    code: "MM-BC004",
                    price: "$149",
                    images: ["crossbody1", "crossbody1-detail", "crossbody1-alt"],
                    options: [
                        ProductOption(
                            name: "Color",
                            options: [
                                OptionItem(value: "Negro", available: true),
                                OptionItem(value: "Rosa", available: true),
                                OptionItem(value: "Tostado", available: true),
                                OptionItem(value: "Plateado", available: false)
                            ],
                            selectionType: .tags
                        )
                    ],
                    promotions: [
                        ProductPromotion(
                            title: "Oferta Combo",
                            description: "Compra cualquier bolso cruzado y obtén 50% de descuento en una cartera a juego",
                            validUntil: Calendar.current.date(byAdding: .day, value: 14, to: Date())!
                        )
                    ],
                    storeAvailability: [
                        StoreAvailability(storeName: "Centro de Moda", availability: .limitedStock, distance: "1.7 km"),
                        StoreAvailability(storeName: "Centro Metropolitano", availability: .inStock, distance: "5.3 km")
                    ],
                    freeShipping: true,
                    homeDeliveryAvailable: true
                ),
                
                Product(
                    maker: "Aventura Chic",
                    title: "Mochila Aventurera",
                    code: "AC-MA005",
                    price: "$179",
                    images: ["backpack1", "backpack1-detail", "backpack1-alt"],
                    options: [
                        ProductOption(
                            name: "Color",
                            options: [
                                OptionItem(value: "Verde Bosque", available: true),
                                OptionItem(value: "Caqui", available: true),
                                OptionItem(value: "Negro", available: true)
                            ],
                            selectionType: .tags
                        ),
                        ProductOption(
                            name: "Tamaño",
                            options: [
                                OptionItem(value: "20L", available: true),
                                OptionItem(value: "30L", available: true),
                                OptionItem(value: "40L", available: false)
                            ],
                            selectionType: .dropdown
                        )
                    ],
                    promotions: [
                        ProductPromotion(
                            title: "Temporada Outdoor",
                            description: "Botella de agua gratis con cualquier compra de mochila",
                            validUntil: Calendar.current.date(byAdding: .month, value: 1, to: Date())!
                        )
                    ],
                    storeAvailability: [
                        StoreAvailability(storeName: "Mundo Outdoor", availability: .inStock, distance: "4.2 km"),
                        StoreAvailability(storeName: "Equipo Aventura", availability: .limitedStock, distance: "7.1 km")
                    ],
                    freeShipping: false,
                    homeDeliveryAvailable: true
                ),
                
                Product(
                    maker: "Diamante",
                    title: "Clutch de Cristales",
                    code: "DI-CC008",
                    price: "$159",
                    images: ["clutch1", "clutch1-detail", "clutch1-alt"],
                    options: [
                        ProductOption(
                            name: "Color",
                            options: [
                                OptionItem(value: "Plateado", available: true),
                                OptionItem(value: "Dorado", available: true),
                                OptionItem(value: "Negro", available: true),
                                OptionItem(value: "Oro Rosa", available: false)
                            ],
                            selectionType: .tags
                        )
                    ],
                    promotions: [
                        ProductPromotion(
                            title: "Colección Nocturna",
                            description: "Compra cualquier bolso de noche y obtén 30% en accesorios a juego",
                            validUntil: Calendar.current.date(byAdding: .day, value: 3, to: Date())!
                        )
                    ],
                    storeAvailability: [
                        StoreAvailability(storeName: "Boutique Formal", availability: .inStock, distance: "3.5 km"),
                        StoreAvailability(storeName: "Centro Comercial de Lujo", availability: .inStock, distance: "7.8 km")
                    ],
                    freeShipping: true,
                    homeDeliveryAvailable: true
                ),
                
                Product(
                    maker: "Vacaciones",
                    title: "Bolsa de Playa",
                    code: "VAC-BP010",
                    price: "$79",
                    images: ["beachbag1", "beachbag1-detail", "beachbag1-alt"],
                    options: [
                        ProductOption(
                            name: "Patrón",
                            options: [
                                OptionItem(value: "Rayas", available: true),
                                OptionItem(value: "Floral", available: true),
                                OptionItem(value: "Sólido", available: true)
                            ],
                            selectionType: .tags
                        )
                    ],
                    promotions: [
                        ProductPromotion(
                            title: "Especial de Verano",
                            description: "Compra una bolsa de playa y obtén 20% de descuento en un sombrero",
                            validUntil: Calendar.current.date(byAdding: .month, value: 2, to: Date())!
                        )
                    ],
                    storeAvailability: [
                        StoreAvailability(storeName: "Boutique de Playa", availability: .inStock, distance: "2.2 km"),
                        StoreAvailability(storeName: "Tienda de Verano", availability: .inStock, distance: "4.5 km")
                    ],
                    freeShipping: true,
                    homeDeliveryAvailable: true
                ),
                
                Product(
                    maker: "Clásica",
                    title: "Bolso Bandolera",
                    code: "CLA-BB011",
                    price: "$189",
                    images: ["shoulder1", "shoulder1-detail", "shoulder1-alt"],
                    options: [
                        ProductOption(
                            name: "Color",
                            options: [
                                OptionItem(value: "Camel", available: true),
                                OptionItem(value: "Negro", available: true),
                                OptionItem(value: "Gris", available: true)
                            ],
                            selectionType: .tags
                        ),
                        ProductOption(
                            name: "Tamaño",
                            options: [
                                OptionItem(value: "Pequeño", available: true),
                                OptionItem(value: "Mediano", available: true)
                            ],
                            selectionType: .dropdown
                        )
                    ],
                    promotions: [
                        ProductPromotion(
                            title: "Colección Otoño",
                            description: "15% de descuento en accesorios de la colección de otoño",
                            validUntil: Calendar.current.date(byAdding: .month, value: 2, to: Date())!
                        )
                    ],
                    storeAvailability: [
                        StoreAvailability(storeName: "Galerías Moda", availability: .inStock, distance: "2.8 km"),
                        StoreAvailability(storeName: "Bulevar Compras", availability: .limitedStock, distance: "5.5 km")
                    ],
                    freeShipping: true,
                    homeDeliveryAvailable: true
                )
            ]
    }
}


