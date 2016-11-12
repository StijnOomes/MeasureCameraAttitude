//
//  ViewController.swift
//  MeasureCameraAttitude
//
//  Created by Stijn Oomes on 02/11/2016.
//  Copyright © 2016 Oomes Vision Systems. All rights reserved.
//

import UIKit
import CoreMotion
import SceneKit

class ViewController: UIViewController, SCNSceneRendererDelegate {

    let motionManager = CMMotionManager()
    var deviceQuaternion: CMQuaternion?
//    var rotationMatrix: CMRotationMatrix?
//    var eulerAngles: CMAttitude?
    
//    @IBOutlet weak var boxView: SCNView!

    @IBOutlet weak var boxView: SCNView!
    var boxNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sensorQueue = OperationQueue()
        sensorQueue.name = "SensorData"
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1/30.0
            motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: OperationQueue(), withHandler: { (deviceMotion, error) in
                guard let data = deviceMotion else { return }
                self.deviceQuaternion = data.attitude.quaternion
//                self.rotationMatrix = data.attitude.rotationMatrix
//                self.eulerAngles = data.attitude
            })
        }
        
        let graphicsScene = SCNScene()
        boxView.scene = graphicsScene
        boxView.backgroundColor = UIColor.gray
        boxView.autoenablesDefaultLighting = true
        
        boxNode = SCNNode()
        if let box = boxNode {
            box.geometry = SCNBox(width: 4.0, height: 2.0, length: 1.0, chamferRadius: 0.0)
            box.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            graphicsScene.rootNode.addChildNode(box)
        }
        
        boxView.delegate = self
        boxView.isPlaying = true
    }

    
    func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        
        if let q = self.deviceQuaternion {
            let quaternion = SCNQuaternion(q.y, -q.x, -q.z, q.w)
            boxNode?.orientation = quaternion
        }
        
//        if let r = self.rotationMatrix {
//            let matrix = SCNMatrix4(
//                m11: Float(r.m22), m12: Float(r.m21), m13: Float(r.m23), m14: 0.0,
//                m21: Float(r.m12), m22: Float(r.m11), m23: Float(r.m31), m24: 0.0,
//                m31: Float(r.m32), m32: Float(r.m13), m33: Float(r.m33), m34: 0.0,
//                m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0)
//            boxNode?.transform = matrix
//        }
        
//        if let a = self.eulerAngles {
//            let angles = SCNVector3(a.roll, -a.pitch, -a.yaw)
//            boxNode?.eulerAngles = angles
//        }
    }
    
}

