//
//  Componentes3.swift
//  Liverpool.meet
//
//  Created by Jose julian Lopez on 13/05/25.
//

import SwiftUI

struct DropdownSelectionView: View {
    let option: ProductOption
    @Binding var selectedOption: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(option.name)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            DropdownContainer(
                isExpanded: $isExpanded,
                selectedOption: $selectedOption,
                option: option
            )
        }
    }
}

struct DropdownContainer: View {
    @Binding var isExpanded: Bool
    @Binding var selectedOption: String
    let option: ProductOption
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: { DropdownContent(option: option, selectedOption: $selectedOption, isExpanded: $isExpanded) },
            label: { DropdownLabel(option: option, selectedOption: selectedOption, isExpanded: isExpanded) }
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.1))
        )
    }
}

struct DropdownContent: View {
    let option: ProductOption
    @Binding var selectedOption: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(option.options) { item in
                DropdownItem(
                    item: item,
                    isSelected: selectedOption == item.value,
                    action: {
                        selectedOption = item.value
                        isExpanded = false
                    }
                )
            }
        }
        .padding(.top, 8)
    }
}

struct DropdownItem: View {
    let item: OptionItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(item.value)
                    .foregroundStyle(item.available ? .primary : .secondary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                    .symbolEffect(.bounce, options: .speed(1.5), value: isSelected)
                }
            }
        }
        .disabled(!item.available)
        .opacity(item.available ? 1 : 0.5)
        .padding(.vertical, 4)
    }
}

struct DropdownLabel: View {
    let option: ProductOption
    let selectedOption: String
    let isExpanded: Bool
    
    var body: some View {
        HStack {
            Text(selectedOption.isEmpty ? "Select \(option.name)" : selectedOption)
                .foregroundStyle(selectedOption.isEmpty ? .secondary : .primary)
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .foregroundStyle(.secondary)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                .animation(.smooth, value: isExpanded)
        }
    }
}
