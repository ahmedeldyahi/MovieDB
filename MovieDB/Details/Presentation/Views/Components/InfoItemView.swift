//
//  InfoItemView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import SwiftUI

struct InfoItemView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
