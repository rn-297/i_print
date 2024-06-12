import Flutter
import UIKit
import Photos
import PhotosUI
import FileProvider

public class SwiftAdstringoPlugin: NSObject, FlutterPlugin {
    var stopFetching = false
    
    var channel : FlutterMethodChannel!
    let imageManager = PHCachingImageManager()
    let imageRequestOptions = PHImageRequestOptions()
    let targetSize = CGSize(width: 100, height: 100)
    var fetchResult = PHFetchResult<PHAsset>()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "image_picker_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftAdstringoPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel:  channel)
    }
    
    func getAssetFromLocalIdentifier(localIdentifier: String) -> PHAsset? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeHiddenAssets = false
        self.clearImageCache()

        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: fetchOptions)
        if let asset = fetchResult.firstObject {
            return asset
        } else {
            return nil
        }
    }
    
    func deleteImage(atPath path: String) throws {
        let asset = getAssetFromLocalIdentifier(localIdentifier: path)
//        print(asset)
        respondsToTrashButton(asset: asset!)
    }
    
    func respondsToTrashButton(asset :PHAsset) -> Void {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        PHPhotoLibrary.shared().performChanges( {
            // Delete the asset without showing the confirmation dialog
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        } ) { (success, error) in
            if success {
//                print("Photo asset deleted successfully.")
                DispatchQueue.main.async {
                    self.channel.invokeMethod("imageDelete", arguments: true)
                }
            } else {
                //print("Error deleting photo asset: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    self.channel.invokeMethod("imageDelete", arguments: false)
                }
            }
        }
    }
    
    func clearImageCache() {
        
        imageManager.stopCachingImagesForAllAssets()
    }
    
    
    
    func getVideoData(batchSize: Int,timeStamp:String, completion: @escaping ([[String: Any]]) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        self.clearImageCache()
        let assets = PHAsset.fetchAssets(with: fetchOptions)
        let requestOptions = PHVideoRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.deliveryMode = .automatic
        var videos: [[String: Any]] = []
        var batch: [[String: Any]] = []
        var count = 0
        let targetSize = CGSize(width: 300, height: 300)
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.normalizedCropRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        let queue = DispatchQueue.global(qos: .background)
        
        assets.enumerateObjects { asset, index, stop in
            queue.async {
                
                guard !self.stopFetching else {
                                //print("Fetching stopped by user.")
                                completion([])  // Send an empty array to indicate fetching stopped
                                return
                            }
                
                var base64String : String = ""
                
                PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: imageRequestOptions) { image, info in
                    guard let image = image else {
                        //print("Error: Could not retrieve thumbnail image for video asset.")
                        return
                    }
                    guard let imageData = image.pngData() else {
                        //print("Error: Could not convert thumbnail image to PNG data.")
                        return
                    }
                    base64String = imageData.base64EncodedString()
                }
                
                PHImageManager.default().requestAVAsset(forVideo: asset, options: requestOptions) { asset1, _, _ in
                    guard let urlAsset = asset1 as? AVURLAsset else {
                        //print("Error")
                        return
                    }
                    
                    let videoData = ["videoID":asset.localIdentifier,"videoUrl":urlAsset.url.absoluteString,"videoThumbnail":base64String,"timeStamp":timeStamp]
                    batch.append(videoData)
                    
                    count += 1
                    //print(count)
                    if count == batchSize || index == assets.count - 1 {
                        videos.append(contentsOf: batch)
                        completion(batch)
                        batch.removeAll()
                        count = 0
                    } else if index < assets.count - 1 && count < batchSize {
                        // Fetch remaining videos if current index is less than total count of assets and count is less than batch size
                        if index == assets.count - 2 {
                            // If this is the second to last asset, add remaining videos to a final batch
                            videos.append(contentsOf: batch)
                            completion(batch)
                        }
                    }
                }
            }
        }
    }
    
    
    
    func getAlbumList(completion: @escaping ([[String: Any]]) -> Void, mediaType:String) {
        //        let phManager = PHImageManager.default()
        let fetchOptions = PHFetchOptions()
        let group = DispatchGroup() // Create dispatch group
        
        //        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary]
        //        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeCloudShared] // Add this line to include shared albums as well
        let recentFetchOptions = PHFetchOptions()
        recentFetchOptions.includeAllBurstAssets = false
        recentFetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.normalizedCropRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        var objects: [[String: Any]] = []
        
        fetchOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        
        
        let requestOptions = PHContentEditingInputRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        self.clearImageCache()

        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: recentFetchOptions)
        let count = fetchResult.count;
        // Check if any photos were found
        guard let latestPhoto = fetchResult.firstObject else {
            //print("No photos found.")
            return
        }
        
        
        
        
        let albumList = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        //        group.enter()
        var base64String : String = ""
        
        imageManager.requestImage(for: latestPhoto, targetSize: targetSize, contentMode: .aspectFill, options: imageRequestOptions) { image, info in
            
            
            guard let image = image else {
                //print("Error: Could not retrieve thumbnail image for video asset.")
                return
            }
            guard let imageData = image.pngData() else {
                //print("Error: Could not convert thumbnail image to PNG data.")
                return
            }
            base64String = imageData.base64EncodedString()
        }
        
        let albumData = ["albumName":  "Recent",
                         "albumID": "1234",
                         "albumThumbnail": base64String,
                         "count": count ] as [String : Any]
        objects.append(albumData)
        //            group.leave()
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        albumList.enumerateObjects { [self] (collection, _, _) in
            //print("Album name: \(collection.localizedTitle ?? "") \(collection.localIdentifier )")
            self.clearImageCache()

            let assets = PHAsset.fetchAssets(in: collection, options: options)
            guard let asset = assets.firstObject else {
                return
            }
            group.enter() // Enter dispatch group
            var base64String : String = ""
            
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: imageRequestOptions) { image, info in
                
                
                guard let image = image else {
                    //print("Error: Could not retrieve thumbnail image for video asset.")
                    return
                }
                guard let imageData = image.pngData() else {
                    //print("Error: Could not convert thumbnail image to PNG data.")
                    return
                }
                base64String = imageData.base64EncodedString()
            }
            
            let albumData = ["albumName":  collection.localizedTitle,
                             "albumID": collection.localIdentifier,
                             "albumThumbnail": base64String,
                             "count": assets.count ] as [String : Any]
            objects.append(albumData)
            
            group.leave() // Leave dispatch group
            
        }
        group.notify(queue: .main) {
            // All asynchronous calls have completed
            completion(objects)
        }
    }
    
    func fetchImagesInBatches(batchSize: Int, timeStamp: String, startIndex: Int, completion: @escaping ([[String: Any]]) -> Void) {
        var objects: [[String: Any]] = []
        
        if startIndex == 0 {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.clearImageCache()

            fetchResult = PHAsset.fetchAssets(with: .image, options: options)
        }
        let total = fetchResult.count
        let endIndex = min(startIndex + batchSize, total)
        
        let imageManager = PHImageManager.default()
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.normalizedCropRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let targetSize = CGSize(width: 100, height: 100)
        
        DispatchQueue.global(qos: .background).async {
            for index in stride(from: startIndex, to: endIndex, by: 1) {
                guard !self.stopFetching else {
                    completion([])  // Send an empty array to indicate fetching stopped
                    return
                }
                
                let asset = self.fetchResult.object(at: index)
                
                var base64String: String = ""
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: imageRequestOptions) { image, info in
                    guard let image = image, let imageData = image.pngData() else {
                        return
                    }
                    base64String = imageData.base64EncodedString()
                    
                }
                
                
                let requestOptions = PHContentEditingInputRequestOptions()
                requestOptions.isNetworkAccessAllowed = true
                
                asset.requestContentEditingInput(with: requestOptions) { (input, info) in
                    if let url = input?.fullSizeImageURL {
                        let imageData = ["albumId": "1234", "imageId": asset.localIdentifier, "imageUrl": url.absoluteString, "thumbnail": base64String, "timeStamp": timeStamp]
                        objects.append(imageData)
                    } else {
                        if let error = info[PHContentEditingInputErrorKey] as? NSError {
                            // Handle error
                        }
                    }
                }
            }
            
            DispatchQueue.global(qos: .background).sync {
                while objects.count < endIndex - startIndex {
                    Thread.sleep(forTimeInterval: 0.1)
                }
                completion(objects)
            }
            
//            DispatchQueue.main.async {
//                completion(objects)
//            }
        }
    }


    
   /* func fetchImagesInBatches(batchSize: Int,timeStamp:String, completion: @escaping ([[String: Any]]) -> Void) {
        
        var objects: [[String: Any]] = []
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.clearImageCache()
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: options)
        let total = fetchResult.count
        let imageManager = PHImageManager.default()
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.normalizedCropRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let targetSize = CGSize(width: 100, height: 100)
        
        DispatchQueue.global(qos: .background).async {
            for index in stride(from: 0, to: total, by: batchSize) {
                print("Call Here coming")
                guard !self.stopFetching else {
                                //print("Fetching stopped by user.")
                                completion([])  // Send an empty array to indicate fetching stopped
                                return
                            }
                
                let endIndex = min(index + batchSize, total)
                let assets = Array(fetchResult.objects(at: IndexSet(integersIn: index..<endIndex)))
                
                let requestOptions = PHContentEditingInputRequestOptions()
                requestOptions.isNetworkAccessAllowed = true
                
                let manager = PHImageManager.default()
                let size = CGSize(width: 500, height: 500)
                for asset in assets {
                    var base64String : String = ""
                    
                    imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: imageRequestOptions) { image, info in
                        
                        
                        guard let image = image else {
                            //print("Error: Could not retrieve thumbnail image for video asset.")
                            return
                        }
                        guard let imageData = image.pngData() else {
                            //print("Error: Could not convert thumbnail image to PNG data.")
                            return
                        }
                        base64String = imageData.base64EncodedString()
                    }
                    asset.requestContentEditingInput(with: requestOptions){(input,info)in
                        if let url = input?.fullSizeImageURL {
                            let imageData = ["albumId":"1234","imageId": asset.localIdentifier, "imageUrl": url.absoluteString,"thumbnail":base64String,"timeStamp":timeStamp]
                            objects.append(imageData)
                        } else {
                            if let error = info[PHContentEditingInputErrorKey] as? NSError {
                                //print("Error requesting content editing input for asset: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(objects)
                    objects = []
                }
                
            }
            
        }
    }*/
    
    
    
    
    /*
     
     
     func getImageListFromAlbum(batchCompletion: @escaping ([[String: Any]]) -> Void, albumId: String, batchSize: Int) -> Void {
     let collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumId], options: nil).firstObject
     var allObjects: [[String: Any]] = [] // array to store all batchObjectsArrays
     
     let requestOptions = PHContentEditingInputRequestOptions()
     requestOptions.isNetworkAccessAllowed = true
     
     let imageManager = PHImageManager.default()
     let imageRequestOptions = PHImageRequestOptions()
     imageRequestOptions.isNetworkAccessAllowed = true
     imageRequestOptions.normalizedCropRect = CGRect(x: 0, y: 0, width: 1, height: 1)
     let targetSize = CGSize(width: 100, height: 100)
     
     if let collection = collection {
     let assets = PHAsset.fetchAssets(in: collection, options: nil)
     let totalAssets = assets.count
     
     let batchCount = Int(ceil(Double(totalAssets) / Double(batchSize))) // calculate the number of batches
     
     let dispatchGroup = DispatchGroup()
     var completedRequestsCount = 0 // counter for completed requests
     
     DispatchQueue.global(qos: .background).async {
     for i in stride(from: 0, to: totalAssets, by: batchSize) {
     let end = min(i + batchSize, totalAssets)
     let assetsBatch = Array(assets.objects(at: IndexSet(integersIn: i..<end)))
     var batchObjects: [[String: Any]] = []
     
     for asset in assetsBatch {
     var base64String: String = ""
     
     dispatchGroup.enter() // enter the dispatch group
     
     imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: imageRequestOptions) { image, info in
     defer {
     dispatchGroup.leave() // ensure that dispatchGroup.leave() is called no matter what happens
     }
     guard let image = image else {
     print("Error: Could not retrieve thumbnail image for video asset.")
     dispatchGroup.leave() // leave the dispatch group on error
     return
     }
     
     guard let imageData = image.pngData() else {
     print("Error: Could not convert thumbnail image to PNG data.")
     dispatchGroup.leave() // leave the dispatch group on error
     return
     }
     
     base64String = imageData.base64EncodedString()
     //dispatchGroup.leave() // leave the dispatch group on success
     }
     
     asset.requestContentEditingInput(with: requestOptions) { (input, info) in
     if let url = input?.fullSizeImageURL {
     let imageData = ["albumId": albumId, "imageId": asset.localIdentifier, "imageUrl": url.absoluteString, "thumbnail": base64String]
     
     // Check if imageData already exists in batchObjects array
     if !batchObjects.contains(where: { $0["imageId"] as? String == imageData["imageId"] as? String }) {
     batchObjects.append(imageData)
     }
     } else {
     if let error = info[PHContentEditingInputErrorKey] as? NSError {
     print("Error requesting content editing input for asset: \(error.localizedDescription)")
     }
     }
     
     completedRequestsCount += 1 // increment the counter
     if completedRequestsCount == batchSize { // check if all requests in the batch are completed
     batchCompletion(batchObjects) // call the completion handler for the batch
     }
     }
     }
     
     allObjects.append(contentsOf: batchObjects) // store batch
     }
     }
     }
     }
     
     */
    
    
    
    
    // Fetches a list of all the albums in the user's photo library
    func getAlbumList(completion: @escaping ([[String: Any]]) -> Void) {
        let options = PHFetchOptions()
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        var albumList: [[String:Any]] = []
        userAlbums.enumerateObjects { (collection, _, _) in
            self.clearImageCache()
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            if assets.count > 0 {
                let albumData = ["albumId": collection.localIdentifier, "title": collection.localizedTitle ?? "", "count": assets.count]
                albumList.append(albumData)
            }
        }
        completion(albumList)
    }
    
    func getImageListFromAlbum(batchCompletion: @escaping ([[String: Any]]) -> Void, albumId: String, batchSize: Int,timeStamp:String) {
        let collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumId], options: nil).firstObject
        var allObjects: [[String: Any]] = [] // array to store all batchObjectsArrays
        
        let requestOptions = PHContentEditingInputRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        
        let imageManager = PHImageManager.default()
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.normalizedCropRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let targetSize = CGSize(width: 100, height: 100)
        
        if let collection = collection {
            self.clearImageCache()
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            let totalAssets = assets.count
            
            let batchCount = Int(ceil(Double(totalAssets) / Double(batchSize))) // calculate the number of batches
            
            DispatchQueue.global(qos: .background).async {
                var allImageAssets: [PHAsset] = [] // array to store all image assets
                
                // Get all image assets from the collection
                for i in 0..<totalAssets {
                    let asset = assets[i]
                    if asset.mediaType == .image {
                        allImageAssets.append(asset)
                    }
                }
                
                // Process images in batches
                for i in stride(from: 0, to: allImageAssets.count, by: batchSize) {
                    let end = min(i + batchSize, allImageAssets.count)
                    let assetsBatch = Array(allImageAssets[i..<end])
                    var batchObjects: [[String: Any]] = []
                    
                    // Get image metadata for each asset in the batch
                    for asset in assetsBatch {
                        
                        var base64String: String = ""
                        
                        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: imageRequestOptions) { image, info in
                            
                            guard let image = image else {
                                //print("Error: Could not retrieve thumbnail image for asset.")
                                return
                            }
                            guard let imageData = image.pngData() else {
                                //print("Error: Could not convert thumbnail image to PNG data.")
                                return
                            }
                            base64String = imageData.base64EncodedString()
                        }
                        
                        asset.requestContentEditingInput(with: requestOptions) { input, info in
                            if let url = input?.fullSizeImageURL {
                                let imageData = ["albumId": albumId, "imageId": asset.localIdentifier, "imageUrl": url.absoluteString, "thumbnail": base64String,"timeStamp":timeStamp]
                                batchObjects.append(imageData)
                            } else {
                                if let error = info[PHContentEditingInputErrorKey] as? NSError {
                                    //print("Error requesting content editing input for asset: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                    
                    // Wait for all metadata requests to complete before calling batchCompletion
                    DispatchQueue.global(qos: .background).sync {
                        while batchObjects.count < assetsBatch.count {
                            Thread.sleep(forTimeInterval: 0.1)
                        }
                        allObjects.append(contentsOf: batchObjects) // store batchObjects in allObjects array
                        batchCompletion(batchObjects)
                    }
                }
                
                //                // Call batchCompletion with allObjects array containing all batchObjectsArrays
                //                DispatchQueue.main.async {
                //                    batchCompletion(allObjects)
                //                }
            }
        }
    }
    
    
    
    
    //    func getImageListFromAlbum(batchCompletion: @escaping ([[String: Any]]) -> Void, albumId: String, batchSize: Int) -> Void {
    //        let collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumId], options: nil).firstObject
    //        var objects : [[String:Any]] = []
    //
    //        let requestOptions = PHContentEditingInputRequestOptions()
    //        requestOptions.isNetworkAccessAllowed = true
    //
    //        let imageManager = PHImageManager.default()
    //        let imageRequestOptions = PHImageRequestOptions()
    //        imageRequestOptions.isNetworkAccessAllowed = true
    //        imageRequestOptions.normalizedCropRect = CGRect(x: 0, y: 0, width: 1, height: 1)
    //        let targetSize = CGSize(width: 100, height: 100)
    //
    //        if let collection = collection {
    //            let assets = PHAsset.fetchAssets(in: collection, options: nil)
    //            let totalAssets = assets.count
    //            DispatchQueue.global(qos: .background).async {
    //
    //                for i in stride(from: 0, to: totalAssets, by: batchSize) {
    //                    let end = min(i + batchSize, totalAssets)
    //                    let assetsBatch = Array(assets.objects(at: IndexSet(integersIn: i..<end)))
    //                    var batchObjects: [[String:Any]] = []
    //
    //                    for asset in assetsBatch {
    //
    //                        var base64String : String = ""
    //
    //                        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: imageRequestOptions) { image, info in
    //
    //                            guard let image = image else {
    //                                print("Error: Could not retrieve thumbnail image for video asset.")
    //                                return
    //                            }
    //                            guard let imageData = image.pngData() else {
    //                                print("Error: Could not convert thumbnail image to PNG data.")
    //                                return
    //                            }
    //                            base64String = imageData.base64EncodedString()
    //                        }
    //
    //                        asset.requestContentEditingInput(with: requestOptions){(input,info)in
    //                            if let url = input?.fullSizeImageURL {
    //                                let imageData = ["albumId":albumId,"imageId": asset.localIdentifier, "imageUrl": url.absoluteString,"thumbnail":base64String]
    //                                batchObjects.append(imageData)
    //                            } else {
    //                                if let error = info[PHContentEditingInputErrorKey] as? NSError {
    //                                    print("Error requesting content editing input for asset: \(error.localizedDescription)")
    //                                }
    //                            }
    //                        }
    //                    }
    //
    //                    DispatchQueue.main.async {
    //                        batchCompletion(batchObjects)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized: break
                // Access granted, you can access the Photos library.
                //print(status)
            case .denied, .restricted: break
                // Access denied, show an error message or guide the user to enable access in Settings.
                //print(status)
            case .notDetermined: break
                // The user has not yet made a choice, you can request authorization again.
                ///print(status)
            case .limited: break
                //print(status)
            @unknown default:
                fatalError("Unexpected case when requesting Photos authorization.")
            }
        }
        
        
        if call.method == "getUniversalPath" {
            guard let path = call.arguments as? String else {
                result(FlutterError(code: "invalid_argument", message: "Invalid argument", details: nil))
                return
            }
            
        } else if call.method == "getPlatformVersion"{
            result("iOS " + UIDevice.current.systemVersion)
        }else if call.method == "stopFetchingFromNative"{
            stopFetching = true
                    //print("Stopping batch-wise fetching from native side.")
                    result(nil)
        } else if call.method == "getAlbumData"{
            guard let mediaType = call.arguments as? String else {
                result(FlutterError(code: "invalid_argument", message: "Invalid argument", details: nil))
                return
            }
            getAlbumList(completion:{
                obj in
                //                print(obj, "obj")
                do{
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    DispatchQueue.main.async {
                    self.channel.invokeMethod("albumData", arguments: jsonString)
                    }
                }catch{
                    //print(error.localizedDescription)
                }
            }, mediaType: mediaType)
            result("")
        } else if call.method == "getVideoData"{
            stopFetching = false
            guard let tiemStamp = call.arguments as? String else {
                result(FlutterError(code: "invalid_argument", message: "Invalid argument", details: nil))
                return
            }
            getVideoData(batchSize: 10,timeStamp: tiemStamp, completion:{
                obj in
                //                print(obj, "obj")
                do{
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    DispatchQueue.main.async {
                    self.channel.invokeMethod("videoData", arguments: jsonString)
                    }
                }catch{
                    //print(error.localizedDescription)
                }
            })
            result("")
        } else if call.method == "getImageData"{
            stopFetching=false
            guard let arguments = call.arguments as? NSArray else {
                result(FlutterError(code: "invalid_argument", message: "Invalid argument", details: nil))
                return
            }
            
            let albumId = arguments[0] as! String
            let timeStamp = arguments[1] as! String
            let startIndex = arguments[2] as! Int
            //print("albumId", albumId)
            if albumId == "1234"{
                fetchImagesInBatches(batchSize: 20,timeStamp:timeStamp,startIndex: startIndex, completion: {
                    objects in
                    do{
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: objects, options: .prettyPrinted)
                        let jsonString = String(data: jsonData, encoding: .utf8)
                        DispatchQueue.main.async {
                        self.channel.invokeMethod("imageData", arguments: jsonString)
                        }
                    }catch{
                        //print(error.localizedDescription)
                    }
                })
            }else{
                
                
                
                
                
                getImageListFromAlbum(batchCompletion: {
                    objects in
                    do{
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: objects, options: .prettyPrinted)
                        let jsonString = String(data: jsonData, encoding: .utf8)
                        DispatchQueue.main.async {
                        self.channel.invokeMethod("imageData", arguments: jsonString)
                        }
                    }catch{
                        //print(error.localizedDescription)
                    }
                }, albumId: albumId,batchSize: 10,timeStamp:timeStamp )}
            result("")
        } else if call.method == "deleteImage"{
            guard let assetId = call.arguments as? String else {
                result(FlutterError(code: "invalid_argument", message: "Invalid argument", details: nil))
                return
            }
            //print(assetId,"assetId")
            do{
                try deleteImage(atPath: assetId)
            }catch{
                //print(error.localizedDescription)
            }
        }else{
            result(FlutterMethodNotImplemented)
        }
    }
    
}
