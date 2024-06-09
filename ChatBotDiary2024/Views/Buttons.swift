//
//  Buttons.swift
//  ChatBotDiary2024
//
//  Created by Gomi Kouki on 2024/06/09.
//

import SwiftUI

var normalButton: some View {
    Image(systemName: "arrow.right.circle")
        .resizable()
        .frame(width: 70, height: 70)
        .foregroundColor(.gray)
        .padding(.top, 50)
}

var loadingButton: some View {
    ZStack {
        Circle()
            .stroke(Color.gray, style: StrokeStyle(lineWidth: 6))
            .frame(width: 60, height: 60)
        ProgressView()
            .scaleEffect(x: 2, y: 2)
    }
    .padding(.top, 50)
}

var completedButton: some View {
    Image(systemName: "checkmark.circle")
        .resizable()
        .frame(width: 70, height: 70)
        .foregroundColor(.green)
        .padding(.top, 50)
}

var errorButton: some View {
    Image(systemName: "xmark.circle")
        .resizable()
        .frame(width: 70, height: 70)
        .foregroundColor(.red)
        .padding(.top, 50)
}

#Preview {
    normalButton
}
