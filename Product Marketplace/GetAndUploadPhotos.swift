import SwiftUI
import Photos
import Amplify

struct GetAndUploadPhotos: View {
    
    @State var count = 0
    @State var images = [String:Data]()
    
    var body: some View {
        Button("start"){Task {
            
            getImages()
            if count == 5 {
//                await uploadToS3()
                print("Finished All uploads")
            }
        }}
    }
    
    func getImages() {
        
        let fetchOptions = PHFetchOptions()
        //        a.fetchLimit = 3
        //        a.includeHiddenAssets = true
        
        let fetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        var imagesAssets = [PHAsset]()
        fetchResults.enumerateObjects({ (object, count, stop) in
            imagesAssets.append(object)
        })
        
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        for imageAsset in imagesAssets {
            let imageId = UUID()
            let options = PHContentEditingInputRequestOptions()
            let fileStringPrefix = "file:///Users/stahis/workplace/Meta/\(imageId)"
            imageAsset.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput, info) -> Void in
                
                // get metadata
                guard let imageUrl = contentEditingInput!.fullSizeImageURL else {return}
                guard let fullImage = CIImage(contentsOf: imageUrl) else {return}
                guard let fileUrl = URL(string: "\(fileStringPrefix).txt") else {return}
                let metadata = fullImage.properties.description
                do {
                    try metadata.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    print(error)
                }
            })
            
            imageManager.requestImageDataAndOrientation(for: imageAsset, options: requestOptions, resultHandler: {(imageData, dataUTI, orientation, info) -> Void in
                if let imageData {
                    guard let jpegImage = UIImage(data: imageData)?.jpegData(compressionQuality: 1) else {return}
                    guard let fileUrl = URL(string: "\(fileStringPrefix).jpeg") else {return}
                    do {
                        try jpegImage.write(to: fileUrl)
                    } catch {
                        print(error)
                    }
                    var name : String = "\(imageId).jpeg"
                    images[name] = jpegImage
                }
                count += 1
            })
        }
        
        //In order to get latest image first, we just reverse the array
        imagesAssets.reverse()
        
    }
    
    func uploadToS3() async {
        for (key, image) in images {
            do {
                let imageKey = try await Amplify.Storage.uploadData(
                    key: key,
                    data: image
                ).value
                print("Finished uploading:", imageKey)
            } catch {
                print(error)
            }
        }
        
    }
    
}
