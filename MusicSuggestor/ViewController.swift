//
//  ViewController.swift
//  MusicSuggestor
//
//  Created by maverick on 09/10/20.
//

import Cocoa
import AVFoundation


class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func AccessWebCam(_ sender: Any)
    {
        let request=AVCaptureDevice.requestAccess(for: AVMediaType.video) { (result) in
            print(result)
            switch AVCaptureDevice.authorizationStatus(for: .video)
            {
            
            case .notDetermined:
                print("not determined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorized:
                
                let session=AVCaptureSession()
                session.sessionPreset=AVCaptureSession.Preset.high
                let device=AVCaptureDevice.default(for: AVMediaType.video)
                var camerainput:AVCaptureInput?
                do
                {
                     camerainput=try AVCaptureDeviceInput(device: device!)
                }
                catch{
                        print("error")
                }
                let cameracaptureop=AVCapturePhotoOutput()
                session.addInput(camerainput!)
                session.addOutput(cameracaptureop)
                let layer=AVCaptureVideoPreviewLayer(session: session)
                DispatchQueue.main.async {
                    layer.videoGravity=AVLayerVideoGravity.resizeAspectFill
                    layer.frame=self.view.bounds
                    layer.connection?.videoOrientation=AVCaptureVideoOrientation.portrait
                    self.view.layer?.addSublayer(layer)
                }
                session.startRunning()
        }
    }
    
}
}

