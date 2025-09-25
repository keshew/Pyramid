import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject var gameViewModel =  GameViewModel()
    @StateObject var gameModel = CatchGameData()
    @State var isMain = false
    @State var isRestart = false
    @Binding var level: Int
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
                    
                    Image(.levelHolder)
                        .resizable()
                        .overlay {
                            Text("\(level)")
                                .CustomFontGradient(size: 32)
                                .outlineTextLess(color: Color(red: 255/255, green: 135/255, blue: 2/255), width: 1)
                        }
                        .frame(width: 75, height: 75)
                        .padding(.leading, 40)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Image(.backHolder)
                            .resizable()
                            .overlay {
                                HStack {
                                    Text("\(ShopManager.shared.getCoins())")
                                        .CustomFont(size: 17, color: Color(red: 255/255, green: 218/255, blue: 1/255))
                                        .offset(y: 2)
                                    
                                    Image(.coin)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                            .frame(width: 100, height: 60)
                        
                        HStack {
                            HStack {
                                ForEach(0..<5, id: \.self) { index in
                                    if index < gameModel.lives {
                                        Image(.life)
                                            .resizable()
                                            .frame(width: 14, height: 12)
                                    } else {
                                        Image(.lifeEnd)
                                            .resizable()
                                            .frame(width: 14, height: 12)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                SpriteView(scene: createGameScene(gameData: gameModel), options: .allowsTransparency)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                
                Spacer()
                
                HStack {
                    Image(.platoformsHolder)
                        .resizable()
                        .overlay {
                            HStack(spacing: 2) {
                                Image(.star)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                HStack(spacing: 0) {
                                    Text("\(gameModel.starsCollected)/")
                                        .CustomFont(size: 14)
                                    Text("\(gameModel.totalStars)")
                                        .CustomFont(size: 14)
                                }
                                .offset(y: 3)
                            }
                        }
                        .frame(width: 130, height: 80)
                    
                    Image(.platoformsHolder)
                        .resizable()
                        .overlay {
                            HStack(spacing: 5) {
                                Image(.time)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                
                                Text(gameModel.timerText)
                                    .CustomFont(size: 14)
                                    .offset(y: 3)
                            }
                        }
                        .frame(width: 130, height: 80)
                }
                .padding(.horizontal)
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
        .fullScreenCover(isPresented: $gameModel.isBonus) {
            BonusGameView(totalCoint: $gameModel.coinsCollected)
        }
        .fullScreenCover(isPresented: $gameModel.isLose) {
            LoseView()
        }
    }
    
    func createGameScene(gameData: CatchGameData) -> CatchGameSpriteKit {
        let scene = CatchGameSpriteKit()
        scene.game  = gameData
        return scene
    }
}

#Preview {
    GameView(level: .constant(2))
}

class CatchGameData: ObservableObject {
    @Published var isLose = false
    @Published var score = 0
    @Published var isPlaying = true
    @Published var lives: Int = 5
    @Published var timerText: String = "03:00"
    @Published var starsCollected: Int = 0
    @Published var coinsCollected: Int = 0
    @Published var isPause = false
    @Published var isBonus = false
    @Published var isWin = false
    @Published var totalCollectedCoin = 0
    @Published var mult = 1
    
    private var totalSeconds = 180
    private var timer: Timer?
    let totalStars: Int = 5

    func collectStar() {
        starsCollected += 1
    }

    
    func startTimer() {
        timer?.invalidate()
        totalSeconds = 180
        updateTimerText()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.totalSeconds > 0 {
                self.totalSeconds -= 1
                self.updateTimerText()
            } else {
                self.isPlaying = false
                self.timer?.invalidate()
                print("Время вышло")
            }
        }
    }
    
    func updateTimerText() {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        timerText = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func loseLife() {
        if lives > 0 {
            lives -= 1
        }
        if lives == 0 {
            isPlaying = false
            print("Проиграл. Жизней нет")
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        totalSeconds = 0
        updateTimerText()
        isPlaying = false
    }
    
    func collectCoin() {
        coinsCollected += 1
        print("Монет собрано: \(coinsCollected)")
    }
}

class CatchGameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: CatchGameData?
    private var movingNode: SKSpriteNode!
    private var ballNode: SKSpriteNode!
    private var isBallLaunched = false
    private var shouldResetBall = false
    private var coinNode: SKSpriteNode?
    var obstaclesPositions = [CGPoint]()
    
    struct PhysicsCategory {
        static let none: UInt32 = 0
        static let ball: UInt32 = 0x1 << 0
        static let platform: UInt32 = 0x1 << 1
        static let obstacle: UInt32 = 0x1 << 2
        static let edge: UInt32 = 0x1 << 3
        static let bottomLine: UInt32 = 0x1 << 4
        static let star: UInt32 = 0x1 << 5
        static let coin: UInt32 = 0x1 << 6
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
        createStars(count: 5)
        startCoinSpawnCycle()
    }
    
    func startCoinSpawnCycle() {
        let wait = SKAction.wait(forDuration: 10)
        let spawn = SKAction.run { [weak self] in
            self?.spawnCoin()
        }
        let sequence = SKAction.sequence([spawn, wait])
        run(SKAction.repeatForever(sequence))
    }
    
    func spawnCoin() {
        coinNode?.removeFromParent()
        coinNode = nil
        
        let coinSize = CGSize(width: 28, height: 40)
        let xPos = CGFloat.random(in: coinSize.width/2...(size.width - coinSize.width/2))
        let yPos = CGFloat.random(in: 150...(size.height - 150))
        
        let coin = SKSpriteNode(imageNamed: "coinGame")
        coin.size = coinSize
        coin.position = CGPoint(x: xPos, y: yPos)
        coin.name = "coin2"
        
        coin.physicsBody = SKPhysicsBody(rectangleOf: coinSize)
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = PhysicsCategory.coin
        coin.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        coin.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        addChild(coin)
        coinNode = coin
        
        let wait = SKAction.wait(forDuration: 7)
        let remove = SKAction.run { [weak self] in
            self?.coinNode?.removeFromParent()
            self?.coinNode = nil
        }
        coin.run(SKAction.sequence([wait, remove]))
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
        bottomLine.position = CGPoint(x: size.width / 2, y: lineHeight / 2)
        
        bottomLine.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: lineWidth, height: lineHeight))
        bottomLine.physicsBody?.isDynamic = false
        bottomLine.physicsBody?.categoryBitMask = PhysicsCategory.bottomLine
        bottomLine.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        bottomLine.physicsBody?.collisionBitMask = PhysicsCategory.ball
        
        addChild(bottomLine)
    }
    
    func createStars(count: Int) {
        let starSize = CGSize(width: 40, height: 60)
        let minY: CGFloat = 200
        let maxY: CGFloat = size.height - 150
        let minDistance: CGFloat = 80

        var starPositions = [CGPoint]()
        var allPositions = [CGPoint]()

        allPositions.append(contentsOf: obstaclesPositions)

        for _ in 0..<count {
            var position: CGPoint
            var attempts = 0
            repeat {
                let randomX = CGFloat.random(in: starSize.width/2...(size.width - starSize.width/2))
                let randomY = CGFloat.random(in: minY...maxY)
                position = CGPoint(x: randomX, y: randomY)
                attempts += 1

                let tooClose = allPositions.contains { existingPos in
                    let dx = existingPos.x - position.x
                    let dy = existingPos.y - position.y
                    let distance = sqrt(dx*dx + dy*dy)
                    return distance < minDistance
                }
                if !tooClose { break }
                if attempts > 100 { break }
            } while true

            starPositions.append(position)
            allPositions.append(position)

            let star = SKSpriteNode(imageNamed: "star")
            star.size = starSize
            star.position = position

            star.physicsBody = SKPhysicsBody(rectangleOf: starSize)
            star.physicsBody?.isDynamic = false
            star.physicsBody?.categoryBitMask = PhysicsCategory.star
            star.physicsBody?.contactTestBitMask = PhysicsCategory.ball
            star.physicsBody?.collisionBitMask = PhysicsCategory.none

            addChild(star)
        }
    }
    
    func createMainNode() {
        let nodeSize = CGSize(width: 140, height: 60)
        movingNode = SKSpriteNode(imageNamed: ShopManager.shared.getSelectedPlatform()?.imageName ?? "platform1")
        movingNode.size = nodeSize
        movingNode.position = CGPoint(x: size.width / 2, y: 60)
        
        let texture = SKTexture(imageNamed: ShopManager.shared.getSelectedPlatform()?.imageName ?? "platform1")
        movingNode.physicsBody = SKPhysicsBody(texture: texture, size: movingNode.size)
        movingNode.physicsBody?.isDynamic = false
        movingNode.physicsBody?.categoryBitMask = PhysicsCategory.platform
        movingNode.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        movingNode.physicsBody?.collisionBitMask = PhysicsCategory.ball
        
        addChild(movingNode)
    }
    
    func createBall() {
        let ballRadius: CGFloat = 20
        ballNode = SKSpriteNode(imageNamed: ShopManager.shared.getSelectedBall()?.imageName ?? "ball1")
        ballNode.size = CGSize(width: ballRadius * 2, height: ballRadius * 2.9)
        ballNode.position = CGPoint(x: movingNode.position.x, y: size.height - 100)
        
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
        let obstacleSize = CGSize(width: 50, height: 75)
        let minY: CGFloat = 150
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

            let texture = SKTexture(imageNamed: "obstacle")
            obstacle.physicsBody = SKPhysicsBody(texture: texture, size: obstacle.size)
            obstacle.physicsBody?.isDynamic = false
            obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
            obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.ball
            obstacle.physicsBody?.collisionBitMask = PhysicsCategory.ball

            addChild(obstacle)
        }

        self.obstaclesPositions = obstaclesPositions
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
        guard let gameData = game else { return }
        
        if !isBallLaunched && gameData.isPlaying && !gameData.isPause {
            resetBallPosition()
            
            ballNode.physicsBody?.affectedByGravity = true

            if gameData.lives == 5 && gameData.timerText == "03:00" {
                gameData.startTimer()
            }

            isBallLaunched = true
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
        let startX = size.width / 2
        let startY = size.height - 100
        ballNode.position = CGPoint(x: startX, y: startY)
        ballNode.physicsBody?.velocity = .zero
        ballNode.physicsBody?.angularVelocity = 0
        ballNode.physicsBody?.affectedByGravity = true
        isBallLaunched = false
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let categories = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if categories & PhysicsCategory.ball != 0 {
            if categories & PhysicsCategory.bottomLine != 0 {
                ballNode.physicsBody?.velocity = .zero
                ballNode.physicsBody?.affectedByGravity = false
                isBallLaunched = false

                game?.loseLife()

                if game?.lives == 0 {
                    game?.isPlaying = false
                    self.isPaused = true
                    game?.isLose = true
                    game?.stopTimer()
                } else {
                    shouldResetBall = true
                }
            } else if categories & PhysicsCategory.star != 0 {
                let starBody = contact.bodyA.categoryBitMask == PhysicsCategory.star ? contact.bodyA.node : contact.bodyB.node
                starBody?.removeFromParent()
                game?.collectStar()

                if game?.starsCollected == game?.totalStars {
                    game?.isPlaying = false
                    self.isPaused = true
                    game?.isBonus = true
                    game?.stopTimer()
                }
            } else if categories & PhysicsCategory.coin != 0 {
                let coinBody = contact.bodyA.categoryBitMask == PhysicsCategory.coin ? contact.bodyA.node : contact.bodyB.node
                coinBody?.removeFromParent()
                coinNode = nil
                game?.collectCoin()
            }
        }
    }

}
