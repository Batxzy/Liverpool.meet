//
//  HeaderExtensions.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI


struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func offset(coordinateSpace: CoordinateSpace, completion: @escaping (CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: coordinateSpace).minY
                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
                    .onPreferenceChange(OffsetKey.self) { value in
                        completion(value)
                    }
            }
        }
    }
}


import SwiftUI

class UniversalGestureManager: NSObject, UIGestureRecognizerDelegate, ObservableObject {
    let gestureID = UUID().uuidString
    @Published var isDragging: Bool = false
    
    override init() {
        super.init()
        addGesture()
    }
    
    func addGesture() {
        let panGesture = UIPanGestureRecognizer()
        panGesture.name = gestureID
        panGesture.delegate = self
        panGesture.addTarget(self, action: #selector(onGestureChange(gesture:)))
        rootWindow.rootViewController?.view.addGestureRecognizer(panGesture)
    }
    
    var rootWindow: UIWindow {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let window = windowScene.windows.first else {
            return .init()
        }
        
        return window
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc
    func onGestureChange(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed || gesture.state == .began {
            isDragging = true
        }
        if gesture.state == .ended || gesture.state == .cancelled {
            isDragging = false
        }
    }
}

struct UniversalGesture: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isDragging: Bool {
        get { self[UniversalGesture.self] }
        set { self[UniversalGesture.self] = newValue }
    }
}
