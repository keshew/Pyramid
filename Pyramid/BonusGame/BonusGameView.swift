import SwiftUI
import SpriteKit

struct BonusGameView: View {
    @StateObject var bonusGameModel =  BonusGameViewModel()
    @StateObject var gameModel = CatchGameData()
    @State var isMain = false
    @State var isRestart = false
    @State var level = ShopManager.shared.getLevel()
    @Binding var totalCoint: Int
    
    var totalCollectedCoin: Int {
        totalCoint * gameModel.mult
    }
    
    var body: some View {
        ZStack {
            Image(.gameBg)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        gameModel.isPause = true
                    }) {
                        Image(.pause)
                            .resizable()
                            .frame(width: 65, height: 60)
                    }
                    
                    Spacer()
                    
                    Text("BONUS GAME")
                        .CustomFont(size: 18, color: Color(red: 255/255, green: 218/255, blue: 1/255))
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    Image(.platoformsHolder)
                        .resizable()
                        .overlay {
                            HStack {
                                Text("10")
                                    .CustomFont(size: 17, color: Color(red: 255/255, green: 218/255, blue: 1/255))
                                    .offset(y: 2)
                                
                                Image(.coin)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .frame(width: 100, height: 60)
                }
                .padding(.horizontal)
                
                Spacer()
                
                SpriteView(scene: createGameScene(gameData: gameModel), options: .allowsTransparency)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                
                Spacer()
            }
            
            if gameModel.isPause  {
                Color.black.opacity(0.7).ignoresSafeArea()
                
                Image(.alertHolder)
                    .resizable()
                    .overlay {
                        VStack(spacing: 30) {
                            VStack(spacing: 0) {
                                Button(action: {
                                    withAnimation {
                                        gameModel.isPause = false
                                    }
                                }) {
                                    Image(.btnHolder)
                                        .resizable()
                                        .overlay {
                                            Text("RESUME")
                                                .CustomFont(size: 14)
                                                .offset(y: -1)
                                        }
                                        .frame(width: 175, height: 65)
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        isRestart = true
                                    }
                                }) {
                                    Image(.btnHolder)
                                        .resizable()
                                        .overlay {
                                            Text("RESTART")
                                                .CustomFont(size: 14)
                                                .offset(y: -1)
                                        }
                                        .frame(width: 175, height: 65)
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        isMain = true
                                    }
                                }) {
                                    Image(.btnHolder)
                                        .resizable()
                                        .overlay {
                                            Text("MAIN VIEW")
                                                .CustomFont(size: 14)
                                                .offset(y: -1)
                                        }
                                        .frame(width: 175, height: 65)
                                }
                            }
                        }
                    }
                    .frame(width: 300, height: 300)
            }
        }
        .fullScreenCover(isPresented: $isMain) {
            MainView()
        }
        .fullScreenCover(isPresented: $isRestart) {
            GameView(level: $level)
        }
        .fullScreenCover(isPresented: $gameModel.isWin) {
            WinView(coins: .constant(totalCollectedCoin))
        }
    }
    
    func createGameScene(gameData: CatchGameData) -> BonusGameViewSpriteKit {
        let scene = BonusGameViewSpriteKit()
        scene.game  = gameData
        return scene
    }
}

#Preview {
    BonusGameView(totalCoint: .constant(10))
}

class BonusGameViewSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: CatchGameData?
    private var movingNode: SKSpriteNode!
    private var ballNode: SKSpriteNode!
    private var isBallLaunched = false
    private var shouldResetBall = false
    
    struct PhysicsCategory {
        static let none: UInt32 = 0
        static let ball: UInt32 = 0x1 << 0
        static let platform: UInt32 = 0x1 << 1
        static let obstacle: UInt32 = 0x1 << 2
        static let edge: UInt32 = 0x1 << 3
        static let bottomLine: UInt32 = 0x1 << 4
        static let star: UInt32 = 0x1 << 5
        static let multiplierBox: UInt32 = 0x1 << 6
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        size = UIScreen.main.bounds.size
        backgroundColor = .clear
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.categoryBitMask = PhysicsCategory.edge
        physicsBody?.contactTestBitMask = PhysicsCategory.ball
        physicsBody?.collisionBitMask = PhysicsCategory.ball
        physicsBody?.friction = 0
        physicsBody?.restitution = 1
        
        addYellowLines()
        createMainNode()
        createBall()
        createObstacles(count: 5)
        addBottomLimit()
        addMultiplierBoxes()
    }
    
    
    func addBottomLimit() {
        let limitHeight: CGFloat = 5
        let limitWidth = size.width
        let bottomLimit = SKNode()
        bottomLimit.position = CGPoint(x: size.width / 2, y: limitHeight * 2)
        
        bottomLimit.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: limitWidth, height: limitHeight))
        bottomLimit.physicsBody?.isDynamic = false
        bottomLimit.physicsBody?.categoryBitMask = PhysicsCategory.bottomLine
        bottomLimit.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        bottomLimit.physicsBody?.collisionBitMask = PhysicsCategory.none
        bottomLimit.name = "bottomLimit"
        
        addChild(bottomLimit)
    }
    
    func addMultiplierBoxes() {
        let boxNames = ["5x", "2x", "4x", "3x"]
        let boxSize = CGSize(width: 70, height: 80)
        let spacing: CGFloat = 25
        let totalWidth = CGFloat(boxNames.count) * boxSize.width + CGFloat(boxNames.count - 1) * spacing
        let startX = (size.width - totalWidth) / 2 + boxSize.width/2
        
        for (index, name) in boxNames.enumerated() {
            let box = SKSpriteNode(imageNamed: name)
            box.size = boxSize
            box.position = CGPoint(x: startX + CGFloat(index) * (boxSize.width + spacing), y: boxSize.height/2 + 5)
            box.name = name
            
            box.physicsBody = SKPhysicsBody(rectangleOf: boxSize)
            box.physicsBody?.isDynamic = false
            box.physicsBody?.categoryBitMask = PhysicsCategory.multiplierBox
            box.physicsBody?.contactTestBitMask = PhysicsCategory.ball
            box.physicsBody?.collisionBitMask = PhysicsCategory.none
            
            let digitText = String(name)
            let label = SKLabelNode(text: digitText)
            label.fontName = "Adira Display SSi"
            label.fontSize = 30
            label.xScale = 0.8
            label.fontColor = UIColor(red: 64/255, green: 0/255, blue: 1/255, alpha: 1)
            label.verticalAlignmentMode = .center
            label.position = CGPoint(x: 0, y: -boxSize.height / 5)
            box.addChild(label)
            
            addChild(box)
        }
    }
    
    func addYellowLines() {
        let lineHeight: CGFloat = 5
        let lineWidth = size.width
        
        let topLine = SKShapeNode(rectOf: CGSize(width: lineWidth, height: lineHeight))
        topLine.fillColor = .yellow
        topLine.strokeColor = .yellow
        topLine.position = CGPoint(x: size.width / 2, y: size.height - lineHeight / 2)
        addChild(topLine)
        
        let bottomLine = SKShapeNode(rectOf: CGSize(width: lineWidth, height: lineHeight))
        bottomLine.name = "bottomLine"
        bottomLine.fillColor = .yellow
        bottomLine.strokeColor = .yellow
        bottomLine.position = CGPoint(x: size.width / 2, y: lineHeight * 24)
        
        addChild(bottomLine)
    }
    
    func createMainNode() {
        let nodeSize = CGSize(width: 140, height: 60)
        movingNode = SKSpriteNode(imageNamed: ShopManager.shared.getSelectedPlatform()?.imageName ?? "platform1")
        movingNode.size = nodeSize
        movingNode.position = CGPoint(x: size.width / 2, y: 170)
        
        movingNode.physicsBody = SKPhysicsBody(rectangleOf: nodeSize)
        movingNode.physicsBody?.isDynamic = false
        movingNode.physicsBody?.categoryBitMask = PhysicsCategory.platform
        movingNode.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        movingNode.physicsBody?.collisionBitMask = PhysicsCategory.ball
        
        addChild(movingNode)
    }
    
    func createBall() {
        let ballRadius: CGFloat = 20
        ballNode = SKSpriteNode(imageNamed: ShopManager.shared.getSelectedBall()?.imageName ?? "ball1")
        ballNode.size = CGSize(width: ballRadius * 2, height: ballRadius * 2.7)
        ballNode.position = CGPoint(x: movingNode.position.x, y: movingNode.position.y + movingNode.size.height/2 + ballRadius)
        
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius / 2)
        ballNode.physicsBody?.affectedByGravity = false
        ballNode.physicsBody?.allowsRotation = false
        ballNode.physicsBody?.restitution = 1
        ballNode.physicsBody?.friction = 0
        ballNode.physicsBody?.linearDamping = 0
        ballNode.physicsBody?.mass = 0.2
        
        ballNode.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ballNode.physicsBody?.contactTestBitMask = PhysicsCategory.platform | PhysicsCategory.obstacle | PhysicsCategory.bottomLine | PhysicsCategory.edge
        ballNode.physicsBody?.collisionBitMask = PhysicsCategory.platform | PhysicsCategory.obstacle | PhysicsCategory.edge
        
        addChild(ballNode)
    }
    
    func createObstacles(count: Int) {
        let obstacleSize = CGSize(width: 50, height: 65)
        let minY: CGFloat = 450
        let maxY: CGFloat = size.height - 150
        let minDistance: CGFloat = 80
        
        var obstaclesPositions = [CGPoint]()
        
        for _ in 0..<count {
            var position: CGPoint
            var attempts = 0
            repeat {
                let randomX = CGFloat.random(in: obstacleSize.width/2...(size.width - obstacleSize.width/2))
                let randomY = CGFloat.random(in: minY...maxY)
                position = CGPoint(x: randomX, y: randomY)
                attempts += 1
                
                let tooClose = obstaclesPositions.contains { existingPos in
                    let dx = existingPos.x - position.x
                    let dy = existingPos.y - position.y
                    let distance = sqrt(dx*dx + dy*dy)
                    return distance < minDistance
                }
                if !tooClose { break }
                if attempts > 100 { break }
            } while true
            
            obstaclesPositions.append(position)
            
            let obstacle = SKSpriteNode(imageNamed: "obstacle")
            obstacle.size = obstacleSize
            obstacle.position = position
            
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacleSize)
            obstacle.physicsBody?.isDynamic = false
            obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
            obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.ball
            obstacle.physicsBody?.collisionBitMask = PhysicsCategory.ball
            
            addChild(obstacle)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if shouldResetBall {
            resetBallPosition()
            shouldResetBall = false
        }
        
        guard let velocity = ballNode.physicsBody?.velocity else { return }
        let minSpeed: CGFloat = 150
        let speed = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
        if speed < minSpeed && isBallLaunched {
            let direction: CGFloat = Bool.random() ? 1 : -1
            ballNode.physicsBody?.applyImpulse(CGVector(dx: 20 * direction, dy: 0))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isBallLaunched && (game?.isPlaying ?? true) {
            ballNode.physicsBody?.affectedByGravity = true
            ballNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
            isBallLaunched = true
            
            if let gameData = game {
                if gameData.lives == 5 && gameData.timerText == "03:00" {
                    gameData.startTimer()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard self.isPaused == false else { return }
        let location = touch.location(in: self)
        let clampedX = max(movingNode.size.width / 2, min(location.x, size.width - movingNode.size.width / 2))
        movingNode.position = CGPoint(x: clampedX, y: movingNode.position.y)
    }
    
    func resetBallPosition() {
        ballNode.position = CGPoint(x: movingNode.position.x, y: movingNode.position.y + movingNode.size.height / 2 + ballNode.size.height / 2)
        ballNode.physicsBody?.velocity = .zero
        ballNode.physicsBody?.angularVelocity = 0
        ballNode.physicsBody?.affectedByGravity = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let categories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if categories & PhysicsCategory.ball != 0 {
            if categories & PhysicsCategory.bottomLine != 0 {
                ballNode.physicsBody?.velocity = .zero
                ballNode.physicsBody?.affectedByGravity = false
                isBallLaunched = false

                game?.loseLife()
                
                if game?.isWin == false {
                    game?.isWin = true
                }
                
                if game?.isPlaying == false {
                    self.isPaused = true
                    game?.stopTimer()
                } else {
                    shouldResetBall = true
                }
            } else if categories & PhysicsCategory.star != 0 {
                let starBody = contact.bodyA.categoryBitMask == PhysicsCategory.star ? contact.bodyA.node : contact.bodyB.node
                starBody?.removeFromParent()
                game?.collectStar()
            } else if categories & PhysicsCategory.multiplierBox != 0 {
                let boxNode = contact.bodyA.categoryBitMask == PhysicsCategory.multiplierBox ? contact.bodyA.node : contact.bodyB.node
                if let boxName = boxNode?.name {
                    let multiplierString = boxName.prefix(1)
                    if let multiplier = Int(String(multiplierString)) {
                        if game?.isWin == false {
                            game?.isWin = true
                            game?.mult = multiplier
                        }
                    }
                }
            }
        }
    }

}
