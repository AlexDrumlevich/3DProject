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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    //var nodeEarth = SCNNode()
   var nodeSun = SCNNode()
    var nodeEarth = SCNNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
      //  let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene = SCNScene()
        let node = SCNNode()
        let nodeForSun = SCNNode()
        
        let lightForSun = SCNLight()
       let sunLightExEarthMoon = SCNLight()
        let sunLightForEarthMoon = SCNLight()
       
        lightForSun.intensity = 2000
        sunLightExEarthMoon.intensity = 1500
        sunLightForEarthMoon.intensity = 1500
        
        lightForSun.categoryBitMask = 4
        sunLightExEarthMoon.categoryBitMask = 8
       sunLightForEarthMoon.categoryBitMask = 2
        
       sunLightForEarthMoon.castsShadow = true
        sunLightForEarthMoon.shadowMode = .forward
        
        // sun
       nodeSun = sun()
        let nodeSunLightEarthMoon = sunLightNodeForEarthMoon()
        nodeForSun.addChildNode(nodeSunLightEarthMoon)
        nodeForSun.addChildNode(nodeSun)
        node.addChildNode(nodeForSun)
      //  node.addChildNode(nodeSun)
        
        //mercury
        let nodeLikeNodeSunForMercury = likeSun()
        nodeLikeNodeSunForMercury.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 10)))
        let nodeMercury = mercury()
        nodeLikeNodeSunForMercury.addChildNode(nodeMercury)
        node.addChildNode(nodeLikeNodeSunForMercury)
        
        //venus
        let nodeLikeNodeSunForVenus = likeSun()
        nodeLikeNodeSunForVenus.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 15)))
        let nodeVenus = venus()
        nodeLikeNodeSunForVenus.addChildNode(nodeVenus)
        node.addChildNode(nodeLikeNodeSunForVenus)
        
        // earth & moon
        let nodeLikeNodeSunForEarth = likeSun()
        nodeLikeNodeSunForEarth.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 20)))
        nodeEarth = earth()
       
        let nodeLikeNodeEarthForMoon = likeEarth()
        nodeLikeNodeEarthForMoon.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 2.5)))
        //let nodeEarth = earth()
        let nodeMoon = moon()
       // nodeEarth.addChildNode(nodeMoon)
        nodeLikeNodeEarthForMoon.addChildNode(nodeMoon)
        nodeLikeNodeSunForEarth.addChildNode(nodeEarth)
         nodeLikeNodeSunForEarth.addChildNode(nodeLikeNodeEarthForMoon)
        node.addChildNode(nodeLikeNodeSunForEarth)
       
        
        //mars
        let nodeLikeNodeSunForMars = likeSun()
        nodeLikeNodeSunForMars.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 25)))
        let nodeMars = mars()
        nodeLikeNodeSunForMars.addChildNode(nodeMars)
        node.addChildNode(nodeLikeNodeSunForMars)
        
        //jupiter
        let nodeLikeNodeSunForJupiter = likeSun()
        nodeLikeNodeSunForJupiter.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 30)))
        let nodeJupiter = jupiter()
        nodeLikeNodeSunForJupiter.addChildNode(nodeJupiter)
        node.addChildNode(nodeLikeNodeSunForJupiter)
       
        //saturn
        let nodeLikeNodeSunForSaturn = likeSun()
        nodeLikeNodeSunForSaturn.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 35)))
        let nodeSaturnRing = saturnsRing()
        let nodeSaturn = saturn()
        nodeSaturn.addChildNode(nodeSaturnRing)
        nodeLikeNodeSunForSaturn.addChildNode(nodeSaturn)
        node.addChildNode(nodeLikeNodeSunForSaturn)
        
        //uranus
        let nodeLikeNodeSunForUranus = likeSun()
        nodeLikeNodeSunForUranus.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 40)))
        let nodeUranus = uranus()
        nodeLikeNodeSunForUranus.addChildNode(nodeUranus)
        node.addChildNode(nodeLikeNodeSunForUranus)
        
        //neptune
        let nodeLikeNodeSunForNeptune = likeSun()
        nodeLikeNodeSunForNeptune.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 45)))
        let nodeNeptune = neptune()
        nodeLikeNodeSunForNeptune.addChildNode(nodeNeptune)
        node.addChildNode(nodeLikeNodeSunForNeptune)
        
        //light
        nodeForSun.light = lightForSun
        nodeSun.light = sunLightExEarthMoon
       nodeSunLightEarthMoon.light = sunLightForEarthMoon
        
        scene.rootNode.addChildNode(node)
//
        // Set the scene to the view
      sceneView.scene = scene
        
    }
    func sun() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: 1.5)
        let material = SCNMaterial()
        var runAction = SCNAction()
        runAction = .repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 3))
        material.diffuse.contents = UIImage(named: "sun")
        geometry.materials = [material]
        node.geometry = geometry
        node.position.z = -8
        node.runAction(runAction)
        node.categoryBitMask = 4
        return node
    }
    func likeSun() -> SCNNode {
        let node = SCNNode()
        let position = nodeSun.position
        node.position = position
        return node
    }
    func sunLightNodeForEarthMoon() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: 1.4)
        node.geometry = geometry
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "sun")
        geometry.materials = [material]
        node.position = nodeSun.position
        node.categoryBitMask = 9
        return node
    }
    
    func mercury() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.1)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "mercury")
        geometry.materials = [material]
        node.geometry = geometry
        node.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 3.5)))
        node.position.z = 2
        node.categoryBitMask = 8
        return node
    }
    
    func venus() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.25)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "venus")
        geometry.materials = [material]
        node.geometry = geometry
        node.position.z = 3
        node.runAction(.repeatForever(.rotateBy(x: 0, y: -.pi, z: 0, duration: 3)))
        node.categoryBitMask = 8
        return node
    }
    
    func earth() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.3)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "earthOne")
        geometry.materials = [material]
        node.geometry = geometry
        node.position.z = 4.5
        node.categoryBitMask = 3
        //let vector = SCNVector3(x: 0, y: .pi, z: 0)
        
       // node.runAction(.repeatForever(.rotate(by: 5, around: vector, duration: 3)))
        
        node.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 3)))
       // node.eulerAngles.x = 0.4
        
    //let vectorCordinate = nodeSun.position
        // let vector = SCNVector3(0, 3, 0)
      // node.runAction(.repeatForever(.rotate(by: 0, around: vectorCordinate, duration: 1)))
      // node.runAction(.move(to: vector, duration: 4))
        return node
    }
    
    func likeEarth() -> SCNNode {
        let node = SCNNode()
        let position = nodeEarth.position
        node.position = position
        return node
    }
    
    func moon() -> SCNNode {
        let node = SCNNode()
        let geametry = SCNSphere(radius: 0.09)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "moon")
        geametry.materials = [material]
        node.geometry = geametry
        node.position.z = 0.45
        node.runAction(.repeatForever(.rotateBy(x: 0, y: .pi, z: 0, duration: 2)))
        node.categoryBitMask = 3
        return node
    }
    
    func mars() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.25)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "marsFirst")
        geometry.materials = [material]
        node.geometry = geometry
        node.position.z = 6
        node.runAction(.repeatForever(.rotateBy(x: 0, y: -.pi, z: 0, duration: 4)))
        node.categoryBitMask = 8
        return node
    }
    
    func jupiter() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.7)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "jupiter")
        geometry.materials = [material]
        node.geometry = geometry
        node.position.z = 7.5
        node.runAction(.repeatForever(.rotateBy(x: 0, y: -.pi, z: 0, duration: 2)))
        node.categoryBitMask = 8
        return node
    }
    
  
    func saturn() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.6)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "saturn")
        geometry.materials = [material]
        node.geometry = geometry
        node.position.z = 9
        node.runAction(.repeatForever(.rotateBy(x: 0, y: -.pi, z: 0, duration: 5)))
        node.categoryBitMask = 8
        return node
    }
    
    func saturnsRing() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNTube(innerRadius: 0.8, outerRadius: 1.2, height: 0.01)
        let materianl = SCNMaterial()
        materianl.diffuse.contents = UIImage(named: "saturnRing")
        node.geometry = geometry
        node.categoryBitMask = 8
        return node
    }
    
    func uranus() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.5)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "uranus")
        geometry.materials = [material]
        node.geometry = geometry
        node.position.z = 10.5
        node.runAction(.repeatForever(.rotateBy(x: 0, y: -.pi, z: 0, duration: 2)))
        node.categoryBitMask = 8
        return node
    }
    
    func neptune() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.5)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "neptune")
        geometry.materials = [material]
        node.geometry = geometry
        node.position.z = 12
        node.runAction(.repeatForever(.rotateBy(x: 0, y: -.pi, z: 0, duration: 2.5)))
        node.categoryBitMask = 8
        return node
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
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
}
