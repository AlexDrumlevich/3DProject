//
//  ViewController.swift
//  3DProject
//
//  Created by Друмлевич on 15.12.2018.
//  Copyright © 2018 Alexey Drumlevich. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var hoopAdded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Detect vertical planes
        configuration.planeDetection = [.horizontal]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func addHoop(result: ARHitTestResult) {
        let hoopNode = SCNScene(named: "art.scnassets/Hoop.scn")!.rootNode.clone()
        
        hoopNode.eulerAngles.x = -.pi / 2
        
        let node = SCNNode()
        
        node.addChildNode(hoopNode)
        
        node.simdTransform = result.worldTransform
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func createBall() {
        guard let frame = sceneView.session.currentFrame else {return}
        let transform = SCNMatrix4(frame.camera.transform)
        let ball = SCNNode(geometry: SCNSphere(radius: 0.25))
        ball.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "basketballTexture")
        ball.transform = transform
        sceneView.scene.rootNode.addChildNode(ball)
    }
    func planeDetected (transform: SCNMatrix4) {
        let node = SCNNode()
        let geometry = SCNText(string: "Plane detected!", extrusionDepth: 0.09)
        geometry.font.withSize(14)
        geometry.firstMaterial?.diffuse.contents = UIColor.orange
        node.geometry = geometry
        node.transform = transform
        sceneView.scene.rootNode.addChildNode(node)
    }
   
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        
        if !hoopAdded {
            hoopAdded = !hoopAdded
        let location = sender.location(in: sceneView)
       // print(#function, location)
        
        let results = sceneView.hitTest(location, types: [.existingPlaneUsingExtent])
        
        if let result = results.first {
            print(#function, "Intersected vertical plane")
            addHoop(result: result)
        }
        } else {
            createBall()
        }
}
}
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        if !hoopAdded {
    planeDetected(transform: SCNMatrix4(anchor.transform))
        print(#function, anchor)
    }
    }
}
