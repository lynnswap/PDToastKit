//
//  TopToastView.swift
//  PDToastKit
//
//  Created by lynnswap on 2025/05/28.
//

#if canImport(SwiftUI)
import SwiftUI


struct TopToastView: View {
    var manager: PDToastManager
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
                .toastStyle()
                Spacer()
            }
        }
        .animation(.default, value: animate)
        .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
            if pressing {
                manager.hold(item)
            } else {
                manager.resume(item)
            }
        }, perform: {})
        .task {
            try? await Task.sleep(for: .seconds(0.1))
            animate = true
        }
    }
}
private extension View{
    func toastStyle() -> some View{
#if swift(>=6.2)
        if #available(iOS 26.0, macOS 26.0, *) {
            return self.glassEffect(.regular.interactive(),in:RoundedRectangle(cornerRadius: 20))
        } else {
            return self
                .background(.thinMaterial)
                .cornerRadius(20)
                .shadow(radius: 5)
        }
#else
        return self
            .background(.thinMaterial)
            .cornerRadius(20)
            .shadow(radius: 5)
#endif

#endif

#endif
    }
}

#if DEBUG
#Preview("TopToastView") {
    TopToastView(
        manager: PDToastManager(),
        item: ToastItem(
            type: .success,
            message: "Copied",
            edge: .top
        )
    )
}
#endif

#endif
