//
//  ViewController.swift
//  MusicSuggestor
//
//  Created by maverick on 09/10/20.
//

import Cocoa
import AVFoundation
import AVKit
import Vision


class ViewController: NSViewController ,AVCaptureVideoDataOutputSampleBufferDelegate{
    
    
    @IBOutlet weak var player: AVPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading avkit")
        setupAVkit()
        print("avkit loaded")
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func AccessWebCam(_ sender: Any)
    {
       
        
    }
    func setupAVkit()
    {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (result) in
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
                let cameracaptureop=AVCaptureVideoDataOutput()
                cameracaptureop.setSampleBufferDelegate(self, queue: DispatchQueue(label: "outputstream"))
                session.addInput(camerainput!)
                session.addOutput(cameracaptureop)
                let layer=AVCaptureVideoPreviewLayer(session: session)
                DispatchQueue.main.async {
                    layer.videoGravity=AVLayerVideoGravity.resizeAspectFill
                    layer.frame=self.view.bounds
                    layer.connection?.videoOrientation=AVCaptureVideoOrientation.portrait
                    self.player.layer?.addSublayer(layer)
                    
                }
                session.startRunning()
            }
        }
        
    }
}

extension ViewController
{
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgimagebuff:CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else
        {
            return
        }
        do{
            print(sampleBuffer)
            let model:VNCoreMLModel = try VNCoreMLModel(for:YOLOv3TinyFP16().model )
            let request=VNCoreMLRequest(model: model) { (vnrequest, error) in
                if error != nil
                {
                    print(error)
                }
                else{
                    print(vnrequest)
                }

            }
            do
            {
                try VNImageRequestHandler(cvPixelBuffer: cgimagebuff, options: [:]).perform([request])
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            
        }
    }
}

