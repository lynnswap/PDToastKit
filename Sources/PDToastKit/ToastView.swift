import SwiftUI

struct ToastView: View {
    @State private var animate: Bool = false

    var type: ToastType
    var message: String
    var additionalMessage: String?
    var imageUrl: URL?
    var edge: Edge

    var body: some View {
        ZStack {
            switch edge {
            case .bottom:
                HStack(spacing: 8) {
                    Image(systemName: type.iconName)
                        .symbolEffect(.bounce.wholeSymbol, options: .nonRepeating, value: animate)
                        .font(.system(size: 22))
                        .foregroundColor(type.color)
                        .padding(.leading, 6)
                    VStack(alignment: .leading) {
                        Text(message)
                            .foregroundStyle(.primary)
                            .font(.callout)
                            .padding(.leading, 6)
                        if let additionalMessage {
                            Text(additionalMessage)
                                .foregroundStyle(.primary)
                                .font(.caption)
                                .padding(.leading, 6)
                        }
                    }

                    if let imageUrl {
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
            default:
                VStack {
                    HStack {
                        Spacer()
                        HStack(spacing: 8) {
                            Image(systemName: type.iconName)
                                .symbolEffect(.bounce.wholeSymbol, options: .nonRepeating, value: animate)
                                .font(.system(size: 22))
                                .foregroundColor(type.color)
                                .padding(.leading, 6)
                            VStack(alignment: .leading) {
                                Text(message)
                                    .foregroundColor(.primary)
                                    .font(.callout)
                                    .padding(.leading, 6)
                                if let additionalMessage {
                                    Text(additionalMessage)
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                        .padding(.leading, 6)
                                }
                            }
                            Spacer()
                            if let imageUrl {
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
            }
        }
        .animation(.default, value: animate)
        .task {
            try? await Task.sleep(for: .seconds(0.1))
            animate = true
        }
    }
}
