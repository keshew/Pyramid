import SwiftUI

struct LevelPinData: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGSize
}

struct LevelView: View {
    @StateObject var levelModel =  LevelViewModel()
    @State var currentLevel = ShopManager.shared.getLevel()
    @State var isReset = false
    @State var isGame = false
    @State var selectedLevel = 0
    @State var coins = ShopManager.shared.getCoins()
    @Environment(\.presentationMode) var presentationMode
    
    var levelPins: [LevelPinData] {
        let screenWidth = UIScreen.main.bounds.width
        var size13 = 90
        
        if UIScreen.main.bounds.width > 900 {
            size13 = 90
        } else if UIScreen.main.bounds.width > 700 {
            size13 = 70
        }
        
        if screenWidth > 700 {
            return [LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 3, y: UIScreen.main.bounds.height / 1.09),
                                 size: CGSize(width: size13, height: size13)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.15),
                                 size: CGSize(width: size13, height: size13)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 1.65, y: UIScreen.main.bounds.height / 1.29),
                                 size: CGSize(width: size13, height: size13)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.15, y: UIScreen.main.bounds.height / 1.35),
                                 size: CGSize(width: size13, height: size13)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.55, y: UIScreen.main.bounds.height / 1.5),
                                 size: CGSize(width: size13, height: size13)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 1.95, y: UIScreen.main.bounds.height / 1.64),
                                 size: CGSize(width: size13, height: size13)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.4, y: UIScreen.main.bounds.height / 1.81),
                                 size: CGSize(width: size13, height: size13)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 1.9, y: UIScreen.main.bounds.height / 1.9),
                                 size: CGSize(width: size13, height: size13)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 1.6, y: UIScreen.main.bounds.height / 2.05),
                                 size: CGSize(width: size13 - 10, height: size13 - 10)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 1.85, y: UIScreen.main.bounds.height / 2.2),
                                 size: CGSize(width: size13 - 20, height: size13 - 20)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.2, y: UIScreen.main.bounds.height / 2.25),
                                 size: CGSize(width: size13 - 20, height: size13 - 20)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.6, y: UIScreen.main.bounds.height / 2.4),
                                 size: CGSize(width: size13 - 20, height: size13 - 20)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.94, y: UIScreen.main.bounds.height / 2.65),
                                 size: CGSize(width: size13 - 20, height: size13 - 20))]
        } else {
            return [LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 3, y: UIScreen.main.bounds.height / 1.15),
                                 size: CGSize(width: 80, height: 40)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.21),
                                 size: CGSize(width: 80, height: 40)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 1.65, y: UIScreen.main.bounds.height / 1.29),
                                 size: CGSize(width: 80, height: 40)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 1.85, y: UIScreen.main.bounds.height / 1.40),
                                 size: CGSize(width: 80, height: 40)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.55, y: UIScreen.main.bounds.height / 1.5),
                                 size: CGSize(width: 80, height: 40)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.15, y: UIScreen.main.bounds.height / 1.64),
                                 size: CGSize(width: 70, height: 35)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.0, y: UIScreen.main.bounds.height / 1.81),
                                 size: CGSize(width: 60, height: 30)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.4, y: UIScreen.main.bounds.height / 1.99),
                                 size: CGSize(width: 60, height: 30)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 1.8, y: UIScreen.main.bounds.height / 2.15),
                                 size: CGSize(width: 55, height: 25)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 1.6, y: UIScreen.main.bounds.height / 2.32),
                                 size: CGSize(width: 50, height: 25)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 1.9, y: UIScreen.main.bounds.height / 2.45),
                                 size: CGSize(width: 40, height: 20)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.4, y: UIScreen.main.bounds.height / 2.55),
                                 size: CGSize(width: 35, height: 17)),
                    LevelPinData(position: CGPoint(x: UIScreen.main.bounds.width / 2.64, y: UIScreen.main.bounds.height / 2.75),
                                 size: CGSize(width: 28, height: 15))]
        }
    }
    
    var body: some View {
        ZStack {
            Image(.bgLevel)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(.backBtn)
                            .resizable()
                            .frame(width: 65, height: 60)
                    }
                    
                    Spacer()
                    
                    Image(.backHolder)
                        .resizable()
                        .overlay {
                            HStack {
                                Text("\(coins)")
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
                
                VStack(spacing: 0) {
                    Image(.levelHolder1)
                        .resizable()
                        .overlay {
                            Text("LEVEL")
                                .CustomFont(size: 38)
                                .outlineTextLess(color: Color(red: 255/255, green: 135/255, blue: 2/255), width: 1)
                                .offset(y: -5)
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 370, height: 70)
                    
                    Image(.levelHolder)
                        .resizable()
                        .overlay {
                            Text("\(currentLevel)")
                                .CustomFontGradient(size: 32)
                                .outlineTextLess(color: Color(red: 255/255, green: 135/255, blue: 2/255), width: 1)
                        }
                        .frame(width: 75, height: 75)
                }
                .padding(.top, 40)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            isReset = true
                        }
                    }) {
                        Image(.reset)
                            .resizable()
                            .frame(width: 70, height: 70)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            
            ZStack {
                ForEach(0..<levelPins.count, id: \.self) { index in
                    Button(action: {
                        selectedLevel = index + 1
                        isGame = true
                    }) {
                        Image(.levelPin)
                            .resizable()
                            .frame(width: levelPins[index].size.width, height: levelPins[index].size.height)
                            .overlay {
                                if currentLevel == (index + 1) {
                                    Color.clear
                                } else if currentLevel < (index + 1){
                                    Text("\(index + 1)")
                                        .CustomFont(size: 16, color: Color(red: 120/255, green: 120/255, blue: 120/255))
                                        .outlineText(color: .white, width: 0.7)
                                        .offset(y: -5)
                                } else {
                                    Text("\(index + 1)")
                                        .CustomFont(size: 16, color: Color(red: 135/255, green: 0/255, blue: 58/255))
                                        .outlineText(color: .white, width: 0.7)
                                        .offset(y: -4)
                                }
                            }
                    }
                    .position(levelPins[index].position)
                    .disabled(index + 1 > currentLevel)
                    .opacity(index + 1 > currentLevel ? 0.5 : 1)
                }

                if currentLevel > 0 && currentLevel <= levelPins.count {
                    Image(.currentLevelPin)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .position(levelPins[currentLevel - 1].position)
                        .offset(y: -20)
                        .zIndex(10)
                }
            }

            if isReset {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    
                    Image(.alertHolder)
                        .resizable()
                        .overlay {
                            VStack(spacing: 30) {
                                Text("ARE YOU SURE YOU\nWANT TO RESTART\nTHE PRECESS?")
                                    .CustomFont(size: 18)
                                    .multilineTextAlignment(.center)
                                
                                HStack(spacing: 20) {
                                    Button(action: {
                                        withAnimation {
                                            ShopManager.shared.resetShop()
                                            coins = ShopManager.shared.getCoins()
                                            currentLevel =  ShopManager.shared.getLevel()
                                            isReset = false
                                            NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
                                        }
                                    }) {
                                        Image(.agree)
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                    }
                                    
                                    Button(action: {
                                        withAnimation {
                                            isReset = false
                                        }
                                    }) {
                                        Image(.cancel)
                                            .resizable()
                                            .frame(width: 55, height: 55)
                                    }
                                }
                            }
                        }
                        .frame(width: 300, height: 300)
                    
                        Image(.manAlert)
                            .resizable()
                            .frame(width: 250, height: 400)
                            .offset(x: 100, y: 230)
                            .allowsHitTesting(false)
                }
            }
        }
        .fullScreenCover(isPresented: $isGame) {
            GameView(level: $selectedLevel)
        }
    }
}

#Preview {
    LevelView()
}

