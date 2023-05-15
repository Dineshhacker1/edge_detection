import Flutter
import UIKit
import WeScan
import Vision
import VisionKit

public class SwiftEdgeDetectionPlugin: NSObject, FlutterPlugin, UIApplicationDelegate {
    var _result:FlutterResult?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "edge_detection", binaryMessenger: registrar.messenger())
        let instance = SwiftEdgeDetectionPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
         let args = call.arguments as! Dictionary<String, Any>
            let saveTo = args["save_to"] as! String
            let canUseGallery = args["can_use_gallery"] as? Bool ?? false
        if (call.method == "edge_detect")
        {
           
            if let viewController = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController {
                self._result = result
                if #available(iOS 13.0, *) {
                    let vision = VNDocumentCameraViewController()
                    vision.delegate = self
                    viewController.present(vision, animated: true)
                } else {
                     
                }
              
            }
        }
        if (call.method == "edge_detect_gallery")
        {
                let args = call.arguments as! Dictionary<String, Any>
                let saveTo = args["save_to"] as! String
            if let viewController = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController {
                let destinationViewController = HomeViewController()
                destinationViewController.setParams(saveTo: saveTo, canUseGallery: true)
                destinationViewController._result = result
                destinationViewController.setParams(saveTo: saveTo, canUseGallery: canUseGallery)
                destinationViewController.selectPhoto();
            }
        }
    }
}
extension SwiftEdgeDetectionPlugin: VNDocumentCameraViewControllerDelegate {
    
    @available(iOS 13.0, *)
    public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        
       
        self._result!([])
        controller.dismiss(animated: true)
    }
    
    @available(iOS 13.0, *)
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        var image = [Data]()
        
        for test in 0...scan.pageCount - 1 {
            image.append(scan.imageOfPage(at: test).jpegData(compressionQuality: 1.0)!)
        }
       
        self._result!(image)
        controller.dismiss(animated: true,completion: nil)
        
        
    }
    
    

}
