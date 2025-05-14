//
//  mainView.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI


struct MainAppView: View {
    @State private var activeTab: TabItem = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $activeTab) {
                // Home Tab 
                HomeTabWrapper()
                    .tag(TabItem.home)
                    .toolbar(.hidden, for: .tabBar)
                
                // Other tabs
                ClickAndMeetView()
                    .tag(TabItem.meet)
                    .toolbar(.hidden, for: .tabBar)
                
                UserAccountTab()
                    .tag(TabItem.user)
                    .toolbar(.hidden, for: .tabBar)
                
                ServicesTab()
                    .tag(TabItem.service)
                    .toolbar(.hidden, for: .tabBar)
            }
            
            // Custom Tab Bar
            InteractiveTabBar(activeTab: $activeTab)
        }
    }
}

struct HomeTabWrapper: View {
    var body: some View {
        ContentView()
    }
}

// Basic placeholders for other tabs
struct MeetTab: View {
    var body: some View {
        Text("Meet Tab")
            .font(.largeTitle.bold())
    }
}

struct UserAccountTab: View {
    var body: some View {
        Text("User Account")
            .font(.largeTitle.bold())
    }
}

struct ServicesTab: View {
    var body: some View {
        Text("Services")
            .font(.largeTitle.bold())
    }
}
#Preview {
    MainAppView()
        .environment(\.isDragging, false)
}
