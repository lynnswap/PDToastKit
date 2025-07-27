//
//  BottomToastView.swift
//  PDToastKit
//
//  Created by lynnswap on 2025/05/28.
//

import SwiftUI
struct BottomToastView: View {
    public var item: ToastItem
    var manager: PDToastManager
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
                if let detail = item.detail {
                    Text(detail)
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
        .toastStyle()
        .animation(.default, value: animate)
        .task {
            try? await Task.sleep(for: .seconds(0.1))
            animate = true
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in manager.pause(item.id) }
                .onEnded { _ in manager.resume(item.id) }
        )
    }
}
private extension View{
    func toastStyle() -> some View{
#if swift(>=6.2)
        if #available(iOS 26.0, macOS 26.0, *) {
            return self.glassEffect(.regular.interactive(),in:RoundedRectangle(cornerRadius: 10))
        } else {
            return self
                .background(.thinMaterial)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
#else
        return self
            .background(.thinMaterial)
            .cornerRadius(10)
            .shadow(radius: 5)
#endif
    }
}

#if DEBUG
#Preview("BottomToastView") {
    BottomToastView(
        item: ToastItem(
            type: .thanks,
            message: "Thanks",
            imageUrl: URL(string: "https://avatars.githubusercontent.com/u/65545348?s=64"),
            edge: .bottom
        ),
        manager: PDToastManager()
    )
}
#endif

