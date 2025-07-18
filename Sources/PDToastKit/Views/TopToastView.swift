//
//  TopToastView.swift
//  PDToastKit
//
//  Created by lynnswap on 2025/05/28.
//

import SwiftUI


struct TopToastView: View {
    public var item: ToastItem
    @State private var animate: Bool = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                HStack(spacing: 8) {
                    Image(systemName: item.type.iconName)
                        .symbolEffect(.bounce.wholeSymbol, options: .nonRepeating, value: animate)
                        .font(.system(size: 22))
                        .foregroundColor(item.type.color)
                        .padding(.leading, 6)
                    VStack(alignment: .leading) {
                        Text(item.message)
                            .foregroundColor(.primary)
                            .font(.callout)
                            .padding(.leading, 6)
                        if let detail = item.detail{
                            Text(detail)
                                .foregroundColor(.secondary)
                                .font(.caption)
                                .padding(.leading, 6)
                        }
                    }
                    Spacer()
                    if let imageUrl = item.imageUrl {
                        AsyncImage(url: imageUrl) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 46, height: 46)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            case .failure(let error):
                                Text(error.localizedDescription)
                            default:
                                ProgressView()
                            }
                        }
                        .frame(width: 46, height: 46)
                        .padding(.trailing, 6)
                    }

                }
                .frame(minHeight: 30)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(.thinMaterial)
                .cornerRadius(20)
                .shadow(radius: 5)
                Spacer()
            }
        }
        .animation(.default, value: animate)
        .task {
            try? await Task.sleep(for: .seconds(0.1))
            animate = true
        }
    }
}

#if DEBUG
#Preview("TopToastView") {
    TopToastView(
        item: ToastItem(
            type: .success,
            message: "Copied",
            edge: .top
        )
    )
}
#endif

