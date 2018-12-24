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

class ViewController: UIViewController,  SCNPhysicsContactDelegate {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    var count = 0
    
    var hoopAdded = false
  //  var textCountNode: SCNNode?
    
    var ball = SCNNode()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLabel.text = String(count)
        countLabel.textColor = .orange
    
        view.backgroundColor = .black
        
        // Set the view's delegate
        sceneView.delegate = self
        
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
       // sceneView.scene.rootNode.addChildNode(textTest())
        sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Detect vertical planes
        configuration.planeDetection = [.vertical]
        
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
        hoopNode.enumerateChildNodes { (node, _) in
            node.enumerateChildNodes({ (subNode, _) in
                subNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: subNode , options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron, SCNPhysicsShape.Option.collisionMargin: 0.01]))
            })
        }
        
        
        //inside ring node first
        let insideRingNode = SCNNode(geometry: SCNTube(innerRadius: 0, outerRadius: 0.1, height: 0.001))
        if let transform = SCNScene(named: "art.scnassets/Hoop.scn")?.rootNode.childNode(withName: "ring", recursively: true)?.transform {
            insideRingNode.transform = transform
            
        }
        insideRingNode.opacity = 0
        insideRingNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: insideRingNode))
        insideRingNode.physicsBody?.collisionBitMask = 100
        //insideRingNode.categoryBitMask = 1
        insideRingNode.physicsBody?.contactTestBitMask = 1
        insideRingNode.name = "firstBarrier"
        hoopNode.addChildNode(insideRingNode)
        
        
        //inside ring node second
        let insideRingNodeSecond = SCNNode(geometry: SCNTube(innerRadius: 0, outerRadius: 0.2, height: 0.001))
        if let transform = SCNScene(named: "art.scnassets/Hoop.scn")?.rootNode.childNode(withName: "ring", recursively: true)?.transform {
            insideRingNodeSecond.transform = transform
        }
        insideRingNodeSecond.position.y = insideRingNodeSecond.position.y - 0.2
        insideRingNodeSecond.opacity = 0
        //  insideRingNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        insideRingNodeSecond.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: insideRingNodeSecond))
        insideRingNodeSecond.physicsBody?.collisionBitMask = 100
        //  insideRingNodeSecond.categoryBitMask = 1
        insideRingNodeSecond.physicsBody?.contactTestBitMask = 1
        insideRingNodeSecond.name = "secondBarrier"
        hoopNode.addChildNode(insideRingNodeSecond)
        
        
//        // textCountNode
//        let textCountNode = SCNNode()
//        let geomerty = SCNText(string: String(count), extrusionDepth: 0.02)
//        geomerty.firstMaterial?.diffuse.contents = UIColor.orange
//        geomerty.containerFrame =  CGRect(x: 0, y: 0, width: 0.3, height: 0.4)
//        geomerty.isWrapped = true
//        textCountNode.geometry = geomerty
//        hoopNode.addChildNode(textCountNode)
        
        let node = SCNNode()
        node.addChildNode(hoopNode)
        node.simdTransform = result.worldTransform
        sceneView.scene.rootNode.addChildNode(node)
        
    }
    
    
    
//    func textTest () -> SCNNode {
//        // let node = SCNNode()
//        let textNode = SCNNode()
//        let text: NSString = "Plane detected!"
//        let geometry = SCNText(string: text, extrusionDepth: 0.05)
//        let rect = CGRect(x: CGFloat(textNode.position.x), y: CGFloat(textNode.position.y), width: CGFloat(10), height: CGFloat(10))
//        // let rec = CGRect(
//        // geometry.font.withSize(10)
//
//        geometry.containerFrame = rect
//
//        geometry.firstMaterial?.diffuse.contents = UIColor.orange
//        textNode.geometry = geometry
//        textNode.position.z = -3
//        //node.transform = transform
//        //  node.addChildNode(textNode)
//        //        sceneView.scene.rootNode.addChildNode(node)
//        //        sceneView.scene.rootNode.addChildNode(textNode)
//        return textNode
//    }
    func createBall() {
        guard let frame = sceneView.session.currentFrame else {return}
        let transform = SCNMatrix4(frame.camera.transform)
        let ball = SCNNode(geometry: SCNSphere(radius: 0.25))
        ball.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "basketballTexture")
        ball.transform = transform
        ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball, options: [SCNPhysicsShape.Option.collisionMargin: 0.01]))
        let power = Float(10)
        let force = SCNVector3(
            -power * transform.m31,
            -power * transform.m32,
            -power * transform.m33
        )
        ball.physicsBody?.applyForce(force, asImpulse: true)
        ball.categoryBitMask = 1
        ball.physicsBody?.contactTestBitMask = 1
        ball.name = "ball"
        sceneView.scene.rootNode.addChildNode(ball)
    }
    
    
//    func planeDetected () -> SCNNode{
//
//        let textNode = SCNNode(geometry: SCNText(string: "Plane detected!", extrusionDepth: 0.05))
//
//
//        textNode.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
//
//        // textNode.transform = transform
//
//        return textNode
//
//    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        if contact.nodeA.name == "firstBarrier" || contact.nodeB.name == "firstBarrier"{
            if contact.nodeA.name == "firstBarrier" {
                ball = contact.nodeB
                if  ball.physicsBody?.contactTestBitMask != 5 {
                    ball.physicsBody?.contactTestBitMask = 3
                }
                //                print ("\(contact.nodeA.name!): \(contact.nodeA.physicsBody!.contactTestBitMask)")
                //                print ("\(contact.nodeB.name!): \(contact.nodeB.physicsBody!.contactTestBitMask)")
            } else {
                ball = contact.nodeB
                if  ball.physicsBody?.contactTestBitMask != 5 {
                    ball.physicsBody?.contactTestBitMask = 3
                }
    
                //                print ("\(contact.nodeA.name!): \(contact.nodeA.physicsBody!.contactTestBitMask)")
                //                print ("\(contact.nodeB.name!): \(contact.nodeB.physicsBody!.contactTestBitMask)")
            }
        }
        
        if contact.nodeA.name == "secondBarrier" || contact.nodeB.name == "secondBarrier" {
            if contact.nodeA.name == "secondBarrier" {
                ball = contact.nodeB
            } else {
                ball = contact.nodeA
            }
            if ball.physicsBody?.contactTestBitMask == 3 {
                count += 1
                countLabel.text = String(count)
                ball.physicsBody?.contactTestBitMask = 5
                print(count)
            } else {
                ball.physicsBody?.contactTestBitMask = 5
            }
        }
    }
    
    //        print ("\(contact.nodeA.name!): \(contact.nodeA.physicsBody!.contactTestBitMask)")
    //        print ("\(contact.nodeB.name!): \(contact.nodeB.physicsBody!.contactTestBitMask)")
    //    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
    //        if contact.nodeA.name == "secondBarrier" || contact.nodeB.name == "secondBarrier" {
    //            count += 1
    //            print(count)
    //            print ("\(contact.nodeA.name!): \(contact.nodeA.physicsBody!.contactTestBitMask)")
    //            print ("\(contact.nodeB.name!): \(contact.nodeB.physicsBody!.contactTestBitMask)")
    //        }
    //    }
   
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        // print(#function)
        if !hoopAdded {
            
            let location = sender.location(in: sceneView)
            // print(#function, location)
            
            let results = sceneView.hitTest(location, types: [.existingPlaneUsingExtent])
            
            if let result = results.first {
                hoopAdded = !hoopAdded
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
        guard let _ = anchor as? ARPlaneAnchor else { return }
        if !hoopAdded {
           // node.addChildNode(planeDetected())
            print(#function, anchor)
        }
    }
}
