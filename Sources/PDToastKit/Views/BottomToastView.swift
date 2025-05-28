//
//  BottomToastView.swift
//  PDToastKit
//
//  Created by lynnswap on 2025/05/28.
//

import SwiftUI
struct BottomToastView: View {
    public var item: ToastItem
    @State private var animate: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: item.type.iconName)
                .symbolEffect(.bounce.wholeSymbol, options: .nonRepeating, value: animate)
                .font(.system(size: 22))
                .foregroundColor(item.type.color)
                .padding(.leading, 6)
            VStack(alignment: .leading) {
                Text(item.message)
                    .foregroundStyle(.primary)
                    .font(.callout)
                    .padding(.leading, 6)
                if let additionalMessage = item.additionalMessage {
                    Text(additionalMessage)
                        .foregroundStyle(.primary)
                        .font(.caption)
                        .padding(.leading, 6)
                }
            }

            if let imageUrl = item.imageUrl {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 26, height: 26)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    case .failure(let error):
                        Text(error.localizedDescription)
                    default:
                        ProgressView()
                    }
                }
                .frame(width: 26, height: 26)
                .padding(.trailing, 6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(radius: 5)
        .animation(.default, value: animate)
        .task {
            try? await Task.sleep(for: .seconds(0.1))
            animate = true
        }
    }
}

