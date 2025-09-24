import SwiftUI

struct MainView: View {
    @StateObject var mainModel =  MainViewModel()
    @State var isLevel = false
    @State var isPlay = false
    @State var isShop = false
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                Image(.bgMain)
                    .resizable()
                    .ignoresSafeArea()
                
                Image(.manMain)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 380, height: 570)
                    .ignoresSafeArea(edges: .bottom)
                    .offset(y: 40)
            }
            
            VStack {
                HStack {
                    Spacer()
                    
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
                    
                    Button(action: {
                        mainModel.isAudio.toggle()
                    }) {
                        Image(mainModel.isAudio ? .soundOn : .soundOff)
                            .resizable()
                            .frame(width: 65, height: 60)
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 0) {
                    Text("BALL  DROP ")
                        .CustomFontGradient(size: 40)
                        .outlineTextLess(color: Color(red: 255/255, green: 135/255, blue: 2/255), width: 1)
                        .outlineText(color: Color(red: 190/255, green: 28/255, blue: 0/255), width: 0.5)
                        .padding(.top, 20)
                    
                    Text("PYRAMID ")
                        .CustomFontGradient(size: 40)
                        .outlineTextLess(color: Color(red: 255/255, green: 135/255, blue: 2/255), width: 1)
                        .outlineText(color: Color(red: 190/255, green: 28/255, blue: 0/255), width: 0.5)
                }
                .padding(.top, 40)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        isLevel = true
                    }) {
                        Image(.level)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width > 700 ? 160 : 90, height: UIScreen.main.bounds.width > 700 ? 160 : 90)
                    }
                    .offset(y: -40)
                    
                    ZStack(alignment: .bottomTrailing){
                        Button(action: {
                            isPlay = true
                        }) {
                            Image(.play)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width > 700 ? 220 : 140, height: UIScreen.main.bounds.width > 700 ? 220 : 140)
                        }
                        
                        Image(.levelHolder)
                            .resizable()
                            .overlay {
                                Text("\(mainModel.level)")
                                    .CustomFontGradient(size: 28)
                                    .outlineTextLess(color: Color(red: 255/255, green: 135/255, blue: 2/255), width: 1)
                            }
                            .frame(width: UIScreen.main.bounds.width > 700 ? 90 : 55, height: UIScreen.main.bounds.width > 700 ? 90 : 55)
                    }
                    
                    Button(action: {
                        isShop = true
                    }) {
                        Image(.shop)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width > 700 ? 160 : 90, height: UIScreen.main.bounds.width > 700 ? 160 : 90)
                    }
                    .offset(y: -40)
                }
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $isShop) {
            ShopView()
        }
        .fullScreenCover(isPresented: $isLevel) {
            LevelView()
        }
        .fullScreenCover(isPresented: $isPlay) {
            GameView(level: $mainModel.level)
        }
    }
}

#Preview {
    MainView()
}

