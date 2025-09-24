import SwiftUI

struct WinView: View {
    @StateObject var winModel =  WinViewModel()
    @State var isMain = false
    @State var isRestart = false
    @Binding var coins: Int
    @State var level = ShopManager.shared.getLevel()
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                Image(.endGameBG)
                    .resizable()
                    .ignoresSafeArea()
                
                Image(.winMan)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 380, height: 540)
                    .offset(y: 40)
            }
            
            VStack {
                HStack {
                    Button(action: {
                        isMain = true
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
                                Text("\(ShopManager.shared.getCoins())")
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
                
                ZStack(alignment: .bottom) {
                    Image(.endGameHolder)
                        .resizable()
                        .overlay {
                            Text("NOW ALBERT CAN MAKE THE POTION HE NEEDS! YOU'VE COLLECTED ALL THE STARS FOR HIM!")
                                .CustomFont(size: UIScreen.main.bounds.width > 700 ? 30 : 20, color: Color(red: 255/255, green: 218/255, blue: 1/255))
                                .offset(y: 4)
                                .padding(.horizontal, UIScreen.main.bounds.width > 700 ? 60 : 20)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: UIScreen.main.bounds.width > 700 ? 560 : 360, height: UIScreen.main.bounds.width > 700 ? 260 : 140)
                        .padding(.top)
                    
                    Image(.platoformsHolder)
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
                        .offset(y: 40)
                }
                
                Spacer()
                
                Button(action: {
                    isRestart = true
                }) {
                    Image(.btnHolder)
                        .resizable()
                        .overlay {
                            Text("NEXT LEVEL")
                                .CustomFont(size: 22, color: Color(red: 255/255, green: 218/255, blue: 1/255))
                        }
                        .frame(width: 260, height: 100)
                }
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $isMain) {
            MainView()
        }
        .fullScreenCover(isPresented: $isRestart) {
            if level == 13 {
                GameView(level: .constant(level))
            } else {
                GameView(level: .constant(level + 1))
            }
        }
        .onAppear {
            if level <= 12 {
                ShopManager.shared.setLevel(1)
            }
            ShopManager.shared.addCoins(coins)
        }
    }
}

#Preview {
    WinView(coins: .constant(10))
}

