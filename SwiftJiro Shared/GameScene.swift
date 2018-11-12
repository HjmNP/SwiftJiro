//
//  GameScene.swift
//  SwiftJiro Shared
//
//  Created by 한지민 on 2018. 6. 26..
//  Copyright © 2018년 HjmNP. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    fileprivate var label : SKLabelNode?
    fileprivate var spinnyNode : SKShapeNode?
    fileprivate var rednoteNode : SKShapeNode?
    fileprivate var bluenoteNode : SKShapeNode?
    fileprivate var measure : Double? = 4/4
    fileprivate var scroll : Double? = 1
    fileprivate var bpm : Double?
    fileprivate var nowbeat : Int!
    fileprivate var nowbar : Double!
    fileprivate var nowmetre : Double!
    fileprivate var genTime : [Double] = []
    fileprivate var noteType : [String] = []
    fileprivate var startTime : DispatchTime = DispatchTime.now()
    let queue = DispatchQueue(label: "gen", attributes: .concurrent)
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        startTime = DispatchTime.now()
        nowbeat = 1
        let beatmap = Beatmap(filePath: "Gargoyle Full Song") // 이렇게 선언해서
        bpm = beatmap.bpm
        //ReadBeatMap.readFile(filepath: "Got more raves?")
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//songNameLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
            label.text = beatmap.title // 이렇게 써먹을 수 있다.
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 4.0
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
            
            #if os(watchOS)
            // For watch we just periodically create one of these and let it spin
            // For other platforms we let user touch/mouse events create these
            spinnyNode.position = CGPoint(x: 0.0, y: 0.0)
            spinnyNode.strokeColor = SKColor.red
            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 2.0),
                                                               SKAction.run({
                                                                let n = spinnyNode.copy() as! SKShapeNode
                                                                self.addChild(n)
                                                               })])))
            #endif
        }
        
        self.rednoteNode = SKShapeNode.init(circleOfRadius: w)
        self.bluenoteNode = SKShapeNode.init(circleOfRadius: w)
        
        if let rednoteNode = self.rednoteNode {
            rednoteNode.lineWidth = 2.0
            rednoteNode.fillColor = SKColor.red
        }
        if let bluenoteNode = self.bluenoteNode {
            bluenoteNode.lineWidth = 2.0
            bluenoteNode.fillColor = SKColor.blue
        }
        
        queue.async(qos: .userInteractive) {
            self.genNote(noteData: beatmap.noteData)
        }
    }
    
    #if os(watchOS)
    override func sceneDidLoad() {
        self.setUpScene()
    }
    #else
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    #endif

    func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos
            spinny.strokeColor = color
            self.addChild(spinny)
        }
    }
    
    func makeRednote(at pos: CGPoint, speed: Double){
        if let rednote = self.rednoteNode?.copy() as! SKShapeNode? {
            rednote.position = pos
            rednote.run(SKAction.moveBy(x: -CGFloat((bpm!*24*speed)), y: 0.0, duration: 10))
            self.addChild(rednote)
        }
    }
    func makeBluenote(at pos: CGPoint, speed: Double){
        if let bluenote = self.bluenoteNode?.copy() as! SKShapeNode? {
            bluenote.position = pos
            bluenote.run(SKAction.moveBy(x: -CGFloat((bpm!*24*speed)), y: 0.0, duration: 10))
            self.addChild(bluenote)
        }
    }
    
    @objc func redNoteGen() {
        
    }
    
    func genNote(noteData: [String]){
        for i in 0..<noteData.count {
            if noteData[i] == ""{
            }
            else if noteData[i] == "#START"{
                
            }
            else if noteData[i] == "#END"{
                break
            }
            else if noteData[i].split(separator: " ")[0] == "#MEASURE"{
                measure = Double(noteData[i].components(separatedBy: " ")[1].split(separator: "/")[0])!/Double(noteData[i].components(separatedBy: " ")[1].split(separator: "/")[1])!
            }
            else if noteData[i].split(separator: " ")[0] == "#SCROLL"{
                scroll = Double(noteData[i].components(separatedBy: " ")[1])!
            }
            else if noteData[i].split(separator: " ")[0] == "#BPMCHANGE"{
                bpm = Double(noteData[i].components(separatedBy: " ")[1])!
            }
            else {
                nowbeat! = nowbeat + 1
                let nowline = noteData[i].split(separator: ",")[0].map { String($0) }
                nowmetre = 300 / bpm!
                for j in 0..<nowline.count {
                    nowbar = nowmetre * measure! * Double(j+1) / Double(nowline.count)
                    genTime.append(nowbar + nowmetre * measure! * Double(nowbeat))
                    noteType.append(nowline[j])
                }
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if (!(genTime == [])){
        if (DispatchTime.now() >= startTime + genTime[0]){
            genTime.remove(at: 0)
            if (noteType[0] == "1" || noteType[0] == "3"){
                makeRednote(at: CGPoint(x: 0, y: 0), speed: 1)
            }
            else if (noteType[0] == "2" || noteType[0] == "4"){
                makeBluenote(at: CGPoint(x: 0, y: 0), speed: 1)
            }
            noteType.remove(at: 0)
        }
        }
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 3{
            print("left red")
        }//detect F
        if event.keyCode == 38{
            print("right red")
        }//detect j
        if event.keyCode == 2{
            print("left blue")
        }//detect D
        if event.keyCode == 40{
            print("right blue")
        }//detect K
    }
    override func mouseDown(with event: NSEvent) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

