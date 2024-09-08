//
//  CustomToggleStyle.swift
//  Todo ListApp
//
//  Created by Roman Kondrashov on 08.09.24.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Button {
                configuration.isOn.toggle()
            } label: {
                Image(systemName: configuration.isOn ? "circle" : "checkmark.circle.fill")
            }
            .padding(5)
            .font(.title3)
            .tint(configuration.isOn ? .gray.opacity(0.25) : .blue)
        }
    }
}

