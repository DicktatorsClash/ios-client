import SpriteKit

class GameScene: SKScene {
    var russia: SKSpriteNode!
    var china: SKSpriteNode!
    var ukraine: SKSpriteNode!

    
    private var contentNode = SKNode()
    private var previousTouchLocation: CGPoint?
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.gray
        setupContent()        
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

            // Limit the scrolling to the bounds of the content
            let minX = min(0, self.size.width - contentNode.calculateAccumulatedFrame().width)
            let minY = min(0, self.size.height - contentNode.calculateAccumulatedFrame().height)
            let maxX: CGFloat = 0
            let maxY: CGFloat = 0
            
            contentNode.position.x = min(max(contentNode.position.x, minX), maxX)
            contentNode.position.y = min(max(contentNode.position.y, minY), maxY)
        }
    }
    
    func setupContent() {
        let contentSize = CGSize(width: self.size.width * 2, height: self.size.height * 2)
        contentNode = SKNode()
        addChild(contentNode)
        
        // Add content to the contentNode (e.g., a large map or background)
        let background = SKSpriteNode(color: .gray, size: contentSize)
        background.position = CGPoint(x: 0, y: 0)
        contentNode.addChild(background)
        
        let russia = setupRussia()
        contentNode.addChild(russia)
        
        let china = setupChina()
        contentNode.addChild(china)
        
        let ukraine = setupUkraine()
        contentNode.addChild(ukraine)
        
        contentNode.position = CGPoint(x: self.size.width /  2, y: self.size.height / 2)
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
        ukraine.position = CGPoint(x: self.size.width / 1.35 + 10 , y: self.size.height / 1.4 - 6)
        return ukraine
    }
}
