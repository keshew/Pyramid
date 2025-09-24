import SwiftUI

struct LoseView: View {
    @StateObject var loseModel =  LoseViewModel()
    @State var isMain = false
    @State var isRestart = false
    @State var level = ShopManager.shared.getLevel()
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                Image(.endGameBG)
                    .resizable()
                    .ignoresSafeArea()
                
                Image(.loseMan)
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
                                Text("200")
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
                
                Image(.endGameHolder)
                    .resizable()
                    .overlay {
                        Text("YOU COULDN'T HELP ALBERT! YOU DIDN'T COLLECT ALL THE STARS FOR HIS POTION!")
                            .CustomFont(size: UIScreen.main.bounds.width > 700 ? 30 : 20, color: Color(red: 255/255, green: 218/255, blue: 1/255))
                            .offset(y: 4)
                            .padding(.horizontal, UIScreen.main.bounds.width > 700 ? 60 : 20)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: UIScreen.main.bounds.width > 700 ? 560 : 360, height: UIScreen.main.bounds.width > 700 ? 260 : 140)
                    .padding(.top)
                
                Spacer()
                
                Button(action: {
                    isRestart = true
                }) {
                    Image(.btnHolder)
                        .resizable()
                        .overlay {
                            Text("TRY AGAIN!")
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
            //MARK: - LEVEL HERE
            GameView(level: $level)
        }
    }
}

#Preview {
    LoseView()
}

