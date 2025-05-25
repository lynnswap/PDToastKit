#if DEBUG
import SwiftUI

struct StackedToastViewWrapper: View {
    @State private var toast = PDToastManager()
    private let thumbnailURL = "https://avatars.githubusercontent.com/u/65545348?s=400&u=58e545eff3a11cd6dce9fd1e5f4d8a108ac53247&v=4"
    var body: some View {
        List {
            RoundedRectangle(cornerRadius: 16).foregroundStyle(.indigo)
                .frame(height: 80)
            Button {
                toast.present(.top, .success("Copied"), additionalMessage: "https://aaaa.com\nhttps://aaaa.com\nhttps://aaaa.com")
            } label: {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.blue)
                    .frame(height: 80)
            }
            Button {
                toast.present(.top, .success("Copied"))
            } label: {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.cyan)
                    .frame(height: 80)
            }
            Button {
                toast.present(.bottom, .success("Copied"), additionalMessage: "https://aaaa.comhttps://aaaa.comhttps://aaaa.comhttps://aaaa.comhttps://aaaa.com")
            } label: {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.blue)
                    .frame(height: 80)
            }
            Button {
                toast.present(.top, .success("Copied"), additionalMessage: "https://aaaa.com\nhttps://aaaa.com\nhttps://aaaa.com", imageURLString: thumbnailURL)
            } label: {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.cyan)
                    .frame(height: 80)
            }
            Button {
                toast.present(.bottom, .success("Copied"), additionalMessage: "https://aaaa.com\nhttps://aaaa.com\nhttps://aaaa.com", imageURLString: thumbnailURL)
            } label: {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.cyan)
                    .frame(height: 80)
            }
        }
        .stackedToast(manager: toast)
    }
}

#Preview {
    StackedToastViewWrapper()
}
#endif
