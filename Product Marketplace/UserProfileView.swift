import SwiftUI
import Amplify

struct UserProfileView: View {
    
    // 1
    @State var isImagePickerVisible: Bool = false
    // 2
    @State var newAvatarImage: UIImage?
    // 3
    var avatarState: AvatarState {
        newAvatarImage.flatMap({ AvatarState.local(image: $0) })
        ?? .remote(avatarKey: userState.userAvatarKey)
    }
    // 1
    @EnvironmentObject var userState: UserState
    // 2
    let columns = Array(repeating: GridItem(.flexible(minimum: 150)), count: 2)
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: { isImagePickerVisible = true }) {
                    AvatarView(
                        state: avatarState,
                        fromMemoryCache: true
                    )
                    .frame(width: 75, height: 75)
                }.onChange(of: avatarState) { _ in
                    Task {
                        await uploadNewAvatar()
                    }
                }

                Text(userState.username)
                    .font(.headline)

                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(0..<10) { i in
                            Color.red
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                }
            }
            .navigationTitle("My Account")
            // 3
            .toolbar {
                ToolbarItem {
                    Button(
                        action: {
                            Task {
                                await signOut()
                            }
                        },
                        label: { Image(systemName: "rectangle.portrait.and.arrow.right") }
                    )
                }
            }
            .sheet(isPresented: $isImagePickerVisible) {
                ImagePickerView(image: $newAvatarImage)
            }
        }
    }

    func signOut() async {
        do {
            // 1
            _ = await Amplify.Auth.signOut()
            print("Signed out")
            // 2
            _ = try await Amplify.DataStore.clear()
        } catch {
            print(error)
        }
    }
    
    func uploadNewAvatar() async {
        // 1
        guard let avatarData = newAvatarImage?.jpegData(compressionQuality: 1) else {return}
        do {
            // 2
            let avatarKey = try await Amplify.Storage.uploadData(
                key: userState.userAvatarKey,
                data: avatarData
            ).value
            print("Finished uploading:", avatarKey)
        } catch {
            print(error)
        }
    }


}
