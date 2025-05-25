// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

extension ToastType {

    public static func success(localized key: LocalizedStringResource) -> Self {
        .success(String(localized: key))
    }
    public static func warning(localized key: LocalizedStringResource) -> Self {
        .warning(String(localized: key))
    }
    public static func error(localized key: LocalizedStringResource) -> Self {
        .error(String(localized: key))
    }
    public static func thanks(localized key: LocalizedStringResource) -> Self {
        .thanks(String(localized: key))
    }
}


extension View {
    public func stackedToast(
        manager: PDToastManager,
        paddingTop:CGFloat = 8,
        paddingBottom:CGFloat = 8
    ) -> some View {
        self.overlay(
            StackedToastView(
                manager: manager,
                paddingTop:paddingTop,
                paddingBottom:paddingBottom
            )
        )
    }
}

#if DEBUG
struct StackedToastViewWrapper: View {
    @State private var toast = PDToastManager()
    private let thumbnailURL = "https://avatars.githubusercontent.com/u/65545348?s=400&u=58e545eff3a11cd6dce9fd1e5f4d8a108ac53247&v=4"
    var body: some View {
        List{
            RoundedRectangle(cornerRadius: 16).foregroundStyle(.indigo)
                .frame(height:80)
            Button {
                toast.present(.top,.success("Copied"),additionalMessage: "https://aaaa.com\nhttps://aaaa.com\nhttps://aaaa.com")
            } label: {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.blue)
                    .frame(height:80)
            }
            Button {
                toast.present(.top,.success("Copied"))
            } label: {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.cyan)
                    .frame(height:80)
            }
            Button {
                toast.present(.bottom,.success("Copied"),additionalMessage: "https://aaaa.comhttps://aaaa.comhttps://aaaa.comhttps://aaaa.comhttps://aaaa.com"
                )
            } label: {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.blue)
                    .frame(height:80)
            }
            Button {
                toast.present(.top,.success("Copied"),additionalMessage: "https://aaaa.com\nhttps://aaaa.com\nhttps://aaaa.com",imageURLString: thumbnailURL)
            } label: {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.cyan)
                    .frame(height:80)
            }
            Button {
                toast.present(.bottom,.success("Copied"),additionalMessage: "https://aaaa.com\nhttps://aaaa.com\nhttps://aaaa.com",imageURLString: thumbnailURL)
            } label: {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.cyan)
                    .frame(height:80)
            }
        }
        .stackedToast(manager: toast)
    }
}
#Preview{
    StackedToastViewWrapper()
}
#endif



import SwiftUI
@MainActor
@Observable public class PDToastManager {
    var toasts : [ToastItem] = []
    
    public init() {}
    
    public func present(
        _ edge: Edge,
        _ type: ToastType,
        additionalMessage: String? = nil,
        imageURL: URL? = nil,
        imageURLString: String? = nil
        
    ) {
        if let imageURL{
            self.innerPresent(edge, type, additionalMessage: additionalMessage, imageUrl: imageURL)
        }else if let imageURLString{
            self.innerPresent(edge, type, additionalMessage: additionalMessage, imageUrl: URL(string:imageURLString))
        }else{
            self.innerPresent(edge, type, additionalMessage: additionalMessage, imageUrl: nil)
        }
    }

    private func innerPresent(
        _ edge: Edge,
        _ type: ToastType,
        additionalMessage: String?,
        imageUrl: URL?
    ) {
        Task {
            let item = ToastItem(
                type: type,
                message: type.message,
                additionalMessage: additionalMessage,
                imageUrl: imageUrl,
                edge: edge
            )
            toasts.append(item)
            try? await Task.sleep(for: .seconds(type.duration))
            self.removeToast(item: item)
        }
    }
    
    func removeToast(item: ToastItem) {
        toasts.removeAll(where: { $0.id == item.id })
    }
}

import SwiftUI
struct StackedToastView: View {
    var manager: PDToastManager
    var paddingTop:CGFloat
    var paddingBottom:CGFloat
    
    var body: some View {
        VStack {
            ForEach(manager.toasts.filter { $0.edge == .top }) { toast in
                ToastView(type: toast.type, message: toast.message, additionalMessage:toast.additionalMessage,imageUrl:toast.imageUrl,edge: .top)
                    .onTapGesture {
                        manager.removeToast(item: toast)
                    }
            }
            
            Spacer()
            ForEach(manager.toasts.filter { $0.edge == .bottom }) { toast in
                ToastView(type: toast.type, message: toast.message, additionalMessage:toast.additionalMessage,imageUrl:toast.imageUrl, edge: .bottom)
                    .onTapGesture {
                        manager.removeToast(item: toast)
                    }
            }
        }
        .frame(maxWidth:600)
        .transition(.opacity)
        .animation(.bouncy,value:manager.toasts.count)
        .padding(.top,paddingTop)
        .padding(.bottom,paddingBottom)
    }
}



import SwiftUI
public class ToastItem: Identifiable {
    public let id = UUID()
    let type: ToastType
    let message: String
    let additionalMessage: String?
    let imageUrl: URL?
    let edge: Edge

    init(
        type: ToastType,
        message: String,
        additionalMessage: String? = nil,
        imageUrl: URL? = nil,
        edge: Edge
    ) {
        self.type = type
        self.message = message
        self.additionalMessage = additionalMessage
        self.imageUrl = imageUrl
        self.edge = edge
    }
}
public enum ToastType {
    case success(String)
    case error(String)
    case warning(String)
    case thanks(String)

    var message: String {
        switch self {
        case .success(let message):
            return message
        case .warning(let message):
            return message
        case .error(let message):
            return message
        case .thanks(let message):
            return message
        }
    }


    var iconName: String {
        switch self {
        case .success: return "checkmark.circle"
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        case .thanks: return "heart.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return .green
        case .warning: return .yellow
        case .error: return .red
        case .thanks: return .pink
        }
    }

    var duration: Double {
        switch self {
        case .success: return 5.0
        case .warning: return 5.0
        case .error: return 5.0
        case .thanks: return 6.0
        }
    }
}


import SwiftUI
struct ToastView: View {
    @State private var animate :Bool = false
    
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
                        if let additionalMessage = additionalMessage {
                            Text(additionalMessage)
                                .foregroundStyle(.primary)
                                .font(.caption)
                                .padding(.leading, 6)
                        }
                    }
                    
                    if let imageUrl  {
                        AsyncImage(url: imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 26, height: 26)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            case .failure(let error):
                                Text(error.localizedDescription)
                            @unknown default:
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
                                if let additionalMessage = additionalMessage {
                                    Text(additionalMessage)
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                        .padding(.leading, 6)
                                }
                            }
                            Spacer()
                            if let imageUrl  {
                                AsyncImage(url: imageUrl) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 46, height: 46)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    case .failure(let error):
                                        Text(error.localizedDescription)
                                    @unknown default:
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
        .animation(.default,value:animate)
        .task() {
            try? await Task.sleep(for: .seconds(0.1))
            animate = true
        }
    }
    
}
