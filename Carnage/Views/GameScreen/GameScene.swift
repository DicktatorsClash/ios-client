import SpriteKit
import AVFoundation


enum AttackType {
    case china
    case ukraine
}

protocol GameSceneViewInteractable {
    func attack(_ type: AttackType)
}

class GameScene: SKScene, GameSceneViewInteractable {
    var russia: SKSpriteNode!
    var china: SKSpriteNode!
    var ukraine: SKSpriteNode!
    var chinaRussiaRocketGif: SKSpriteNode?
    var ukraineRussiaRocketGif: SKSpriteNode?
    var backgroundMusic: SKAudioNode?
    
    let gifFrameSpeed = 0.1

    private var contentNode = SKNode()
    private var previousTouchLocation: CGPoint?
    
    private lazy var initialScrollPosition = CGPoint(x: -size.width, y: -size.height + 50)
    private lazy var pointChinaRussiaBomb = CGPoint(x: self.size.width + 60, y: self.size.height - 70)
    private lazy var ponitUkraineRussiaBomb = CGPoint(x: self.size.width / 1.35 + 40, y: self.size.height / 1.4 + 12)
    let boom = SKAction.playSoundFileNamed("boom", waitForCompletion: false)

    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        backgroundColor = SKColor.gray
        setupContent()
        
        contentNode.position = initialScrollPosition
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            previousTouchLocation = touch.location(in: self)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let previousTouchLocation = previousTouchLocation {
            let location = touch.location(in: self)
            let deltaX = location.x - previousTouchLocation.x
            let deltaY = location.y - previousTouchLocation.y
            
            contentNode.position.x += deltaX
            contentNode.position.y += deltaY
            
            self.previousTouchLocation = location

            let minX = min(0, self.size.width - contentNode.calculateAccumulatedFrame().width)
            let minY = min(0, self.size.height - contentNode.calculateAccumulatedFrame().height)
            let maxX: CGFloat = 0
            let maxY: CGFloat = 0
            
            contentNode.position.x = min(max(contentNode.position.x, minX), maxX)
            contentNode.position.y = min(max(contentNode.position.y, minY), maxY)
        }
    }
    
    func attack(_ type: AttackType) {
        playSoundEffect()

        if case .china = type {
            addChinaRussiaBombGIFToScene(named: "rocket", at: pointChinaRussiaBomb, rotation: 0)
        }
        
        if case .ukraine = type {
            addUkraineRussiaBombScene(named: "rocket", at: ponitUkraineRussiaBomb, rotation: -3.14 / 4)
        }
    }
    
    private func setupContent() {
        let contentSize = CGSize(width: self.size.width * 2, height: self.size.height * 2)
        contentNode = SKNode()
        addChild(contentNode)
        
        let background = SKSpriteNode(color: .gray, size: contentSize)
        background.position = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
        contentNode.addChild(background)
        
        let russia = setupRussia()
        contentNode.addChild(russia)
        
        let china = setupChina()
        contentNode.addChild(china)
        
        let ukraine = setupUkraine()
        contentNode.addChild(ukraine)
    }
    
    private func addUkraineRussiaBombScene(named gifName: String, at position: CGPoint, rotation: CGFloat) {
        guard let gifURL = Bundle.main.url(forResource: gifName, withExtension: "gif"),
              let imageData = try? Data(contentsOf: gifURL),
              let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            print("Failed to load gif file.")
            return
        }
        
        var frames = [SKTexture]()
        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let texture = SKTexture(cgImage: cgImage)
                frames.append(texture)
            }
        }
        
        guard !frames.isEmpty else {
            print("Failed to load frames from GIF.")
            return
        }
        
        ukraineRussiaRocketGif = SKSpriteNode(texture: frames[0])
        ukraineRussiaRocketGif?.position = position
        ukraineRussiaRocketGif?.setScale(0.15)
        ukraineRussiaRocketGif?.zRotation = rotation
        
        
        contentNode.addChild(ukraineRussiaRocketGif!)
        let animateAction = SKAction.animate(with: frames, timePerFrame: gifFrameSpeed)
        ukraineRussiaRocketGif!.run(SKAction.repeat(animateAction, count: 1))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            self.ukraineRussiaRocketGif?.removeFromParent()
        }
    }
    
    private func addChinaRussiaBombGIFToScene(named gifName: String, at position: CGPoint, rotation: CGFloat) {
        guard let gifURL = Bundle.main.url(forResource: gifName, withExtension: "gif"),
              let imageData = try? Data(contentsOf: gifURL),
              let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            print("Failed to load gif file.")
            return
        }
        
        var frames = [SKTexture]()
        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let texture = SKTexture(cgImage: cgImage)
                frames.append(texture)
            }
        }
        
        guard !frames.isEmpty else {
            print("Failed to load frames from GIF.")
            return
        }
        
        chinaRussiaRocketGif = SKSpriteNode(texture: frames[0])
        chinaRussiaRocketGif?.position = position
        chinaRussiaRocketGif?.setScale(0.3)
        chinaRussiaRocketGif?.zRotation = rotation
        
        contentNode.addChild(chinaRussiaRocketGif!)
        let animateAction = SKAction.animate(with: frames, timePerFrame: gifFrameSpeed)
        chinaRussiaRocketGif!.run(SKAction.repeat(animateAction, count: 1))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            self.chinaRussiaRocketGif?.removeFromParent()
        }
    }
    
    func playSoundEffect() {
        if let soundURL = Bundle.main.url(forResource: "bomb", withExtension: "mp3") {
            run(SKAction.playSoundFileNamed(soundURL.lastPathComponent, waitForCompletion: false))
        }
    }
}

extension GameScene {
    func setupRussia() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "russia")
        russia = SKSpriteNode(texture: texture)
        russia.size = texture.size()
        russia.position = CGPoint(x: self.size.width, y: self.size.height)
        return russia
    }
    
    func setupChina() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "china")
        china = SKSpriteNode(texture: texture)
        china.size = texture.size()
        china.position = CGPoint(x: self.size.width - 3, y: self.size.height - 158)
        return china
    }
    
    func setupUkraine() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "ukraine")
        ukraine = SKSpriteNode(texture: texture)
        ukraine.size = texture.size()
        ukraine.position = CGPoint(x: self.size.width / 1.35 + 14 , y: self.size.height / 1.4 - 7)
        return ukraine
    }
}
