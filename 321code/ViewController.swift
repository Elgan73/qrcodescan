//
//  ViewController.swift
//  321code
//
//  Created by Dev Apps4Selling on 22/01/2019.
//  Copyright © 2019 Dev Apps4Selling. All rights reserved.
//
import UIKit
import AVFoundation
class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    static func storyboardInstance() -> ViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
    }
    
    static var scanCode = String()
    var video = AVCaptureVideoPreviewLayer()
    let output = AVCaptureMetadataOutput()
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            print("ERROR")
        }
        
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.aztec,
                                      .code128,
                                      .code39,
                                      .code39Mod43,
                                      .code93,
                                      .ean13,
                                      .ean8,
                                      .face,
                                      .dataMatrix,
                                      .interleaved2of5,
                                      .itf14,
                                      .pdf417,
                                      .qr,
                                      .upce]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
        video.connection?.videoOrientation = self.videoOrientationFromCurrentDeviceOrientation()
        view.layer.addSublayer(video)
        session.startRunning()
        setScanZone()
        let scanAreaView = UIView()
        scanAreaView.layer.borderColor = UIColor.red.cgColor
        scanAreaView.layer.borderWidth = 4
        view.addSubview(scanAreaView)
        scanAreaView.translatesAutoresizingMaskIntoConstraints = false
        scanAreaView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scanAreaView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scanAreaView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        scanAreaView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setScanZone() {
        let midX = self.view.bounds.midX
        let midY = self.view.bounds.midY
        let scanZone = CGRect(x: midX - 150, y: midY - 150, width: 300, height: 300)
        let visibleRect = video.metadataOutputRectConverted(fromLayerRect: scanZone)
        output.rectOfInterest = visibleRect
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in },
                            completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
                                self.video.connection?.videoOrientation = self.videoOrientationFromCurrentDeviceOrientation()
                                self.video.frame = self.view.layer.bounds
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    //TODO: Video Orientation
    func videoOrientationFromCurrentDeviceOrientation() -> AVCaptureVideoOrientation {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            return AVCaptureVideoOrientation.portrait
        case .landscapeLeft:
            return AVCaptureVideoOrientation.landscapeLeft
        case .landscapeRight:
            return AVCaptureVideoOrientation.landscapeRight
        case .portraitUpsideDown:
            return AVCaptureVideoOrientation.portraitUpsideDown
        default:
            return AVCaptureVideoOrientation.portrait
        }
    }
    //TODO: Output scan barcode data
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count > 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                ViewController.scanCode = object.stringValue!
                
                _ = navigationController?.popViewController(animated: true)
//                                    let alert = UIAlertController(title: "", message: object.stringValue, preferredStyle: .alert)
//                                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
//                                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
//                                        UIPasteboard.general.string = object.stringValue}))
//                                    present(alert, animated: true, completion: nil)
            }
        }
    }
}







