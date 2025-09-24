import SwiftUI

enum StoreSelected {
    case platforms
    case balls
}

struct ShopItems: Codable, Identifiable {
    var id = UUID().uuidString
    var imageName: String
    var cost: Int
    var isSelected = false
    var isAvailivle = false
}

struct ShopView: View {
    @StateObject var shopModel =  ShopViewModel()
    @State var storSelected: StoreSelected = .platforms
    @Environment(\.presentationMode) var presentationMode
    
    let grid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var platforms = [ShopItems(imageName: "platform1", cost: 200, isSelected: true, isAvailivle: true),
                     ShopItems(imageName: "platform2", cost: 250),
                     ShopItems(imageName: "platform3", cost: 300),
                     ShopItems(imageName: "platform4", cost: 350),
                     ShopItems(imageName: "platform5", cost: 400),
                     ShopItems(imageName: "platform6", cost: 450),
                     ShopItems(imageName: "platform7", cost: 500),
                     ShopItems(imageName: "platform8", cost: 550),
                     ShopItems(imageName: "platform9", cost: 600)]
    
    var balls = [ShopItems(imageName: "ball1", cost: 200, isSelected: true, isAvailivle: true),
                 ShopItems(imageName: "ball2", cost: 250),
                 ShopItems(imageName: "ball3", cost: 300),
                 ShopItems(imageName: "ball4", cost: 350),
                 ShopItems(imageName: "ball5", cost: 400),
                 ShopItems(imageName: "ball6", cost: 450),
                 ShopItems(imageName: "ball7", cost: 500),
                 ShopItems(imageName: "ball8", cost: 550),
                 ShopItems(imageName: "ball9", cost: 600)]
    
    var body: some View {
        ZStack {
            Image(.bgLoading)
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
                
                VStack(spacing: 0) {
                    Image(.levelHolder1)
                        .resizable()
                        .overlay {
                            Text("STORE")
                                .CustomFont(size: 38)
                                .outlineTextLess(color: Color(red: 255/255, green: 135/255, blue: 2/255), width: 1)
                                .offset(y: -5)
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 370, height: 70)
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                storSelected = .platforms
                            }
                        }) {
                            Image(.platoformsHolder)
                                .resizable()
                                .overlay {
                                    Text("PLATFORMS")
                                        .CustomFont(size: 14, color: storSelected == StoreSelected.platforms ? Color(red: 255/255, green: 218/255, blue: 1/255) : .white)
                                        .offset(y: 3)
                                }
                                .frame(width: 130, height: 80)
                        }
                        
                        Button(action: {
                            withAnimation {
                                storSelected = .balls
                            }
                        }) {
                            Image(.ballHolder)
                                .resizable()
                                .overlay {
                                    Text("BALLS")
                                        .CustomFont(size: 14, color: storSelected == StoreSelected.balls ? Color(red: 255/255, green: 218/255, blue: 1/255) : .white)
                                        .offset(y: 3)
                                }
                                .frame(width: 130, height: 80)
                        }
                    }
                }
                .padding(.top, 40)
                
                ScrollView(showsIndicators: false) {
                             LazyVGrid(columns: grid, spacing: 30) {
                                 if storSelected == .platforms {
                                     ForEach(shopModel.platforms) { index in
                                         Image("platformBack")
                                             .resizable()
                                             .frame(width: 110, height: 110)
                                             .overlay {
                                                 VStack {
                                                     Image(index.imageName)
                                                         .resizable()
                                                         .frame(width: 80, height: 30)
                                                     
                                                     Button(action: {
                                                         shopModel.purchaseOrSelect(type: .platforms, itemID: index.id)
                                                     }) {
                                                         if index.isSelected {
                                                             Image("selected")
                                                                 .resizable()
                                                                 .frame(width: 60, height: 35)
                                                         } else if index.isAvailivle {
                                                             Image("backHolder")
                                                                 .resizable()
                                                                 .overlay {
                                                                     HStack(spacing: 3) {
                                                                         Text("SELECT")
                                                                             .CustomFont(size: 10, color: Color(red: 255/255, green: 218/255, blue: 1/255))
                                                                             .offset(y: 1.5)
                                                                     }
                                                                 }
                                                                 .frame(width: 60, height: 35)
                                                         } else {
                                                             Image("backHolder")
                                                                 .resizable()
                                                                 .overlay {
                                                                     HStack(spacing: 3) {
                                                                         Text("\(index.cost)")
                                                                             .CustomFont(size: 12, color: Color(red: 255/255, green: 218/255, blue: 1/255))
                                                                             .offset(y: 1.5)
                                                                         Image("coin")
                                                                             .resizable()
                                                                             .frame(width: 12, height: 12)
                                                                     }
                                                                 }
                                                                 .frame(width: 60, height: 35)
                                                         }
                                                     }
                                                     .disabled(!index.isAvailivle && shopModel.coins < index.cost)
                                                 }
                                             }
                                     }
                                 } else {
                                     ForEach(shopModel.balls) { index in
                                         Image("ballsBack")
                                             .resizable()
                                             .frame(width: 110, height: 110)
                                             .overlay {
                                                 VStack {
                                                     Image(index.imageName)
                                                         .resizable()
                                                         .frame(width: 30, height: 30)
                                                     
                                                     Button(action: {
                                                         shopModel.purchaseOrSelect(type: .balls, itemID: index.id)
                                                     }) {
                                                         if index.isSelected {
                                                             Image("selected")
                                                                 .resizable()
                                                                 .frame(width: 60, height: 35)
                                                         } else if index.isAvailivle {
                                                             Image("backHolder")
                                                                 .resizable()
                                                                 .overlay {
                                                                     HStack(spacing: 3) {
                                                                         Text("SELECT")
                                                                             .CustomFont(size: 10, color: Color(red: 255/255, green: 218/255, blue: 1/255))
                                                                             .offset(y: 1.5)
                                                                     }
                                                                 }
                                                                 .frame(width: 60, height: 35)
                                                         } else {
                                                             Image("backHolder")
                                                                 .resizable()
                                                                 .overlay {
                                                                     HStack(spacing: 3) {
                                                                         Text("\(index.cost)")
                                                                             .CustomFont(size: 12, color: Color(red: 255/255, green: 218/255, blue: 1/255))
                                                                             .offset(y: 1.5)
                                                                         Image("coin")
                                                                             .resizable()
                                                                             .frame(width: 12, height: 12)
                                                                     }
                                                                 }
                                                                 .frame(width: 60, height: 35)
                                                         }
                                                     }
                                                     .disabled(!index.isAvailivle && shopModel.coins < index.cost)
                                                 }
                                             }
                                     }
                                 }
                             }
                             .padding()
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    ShopView()
}

class ShopManager {
    static let shared = ShopManager()
    
    private let coinKey = "coin"
    private let platformsKey = "platforms"
    private let ballsKey = "balls"
    private let levelKey = "level"
    
    private let defaults = UserDefaults.standard
    
    private let initialPlatforms: [ShopItems] = [
        ShopItems(imageName: "platform1", cost: 200, isSelected: true),
        ShopItems(imageName: "platform2", cost: 250),
        ShopItems(imageName: "platform3", cost: 300),
        ShopItems(imageName: "platform4", cost: 350),
        ShopItems(imageName: "platform5", cost: 400),
        ShopItems(imageName: "platform6", cost: 450),
        ShopItems(imageName: "platform7", cost: 500),
        ShopItems(imageName: "platform8", cost: 550),
        ShopItems(imageName: "platform9", cost: 600)
    ]
    
    private let initialBalls: [ShopItems] = [
        ShopItems(imageName: "ball1", cost: 200, isSelected: true),
        ShopItems(imageName: "ball2", cost: 250),
        ShopItems(imageName: "ball3", cost: 300),
        ShopItems(imageName: "ball4", cost: 350),
        ShopItems(imageName: "ball5", cost: 400),
        ShopItems(imageName: "ball6", cost: 450),
        ShopItems(imageName: "ball7", cost: 500),
        ShopItems(imageName: "ball8", cost: 550),
        ShopItems(imageName: "ball9", cost: 600)
    ]

    func getSelectedPlatform() -> ShopItems? {
        let platforms = getPlatforms()
        return platforms.first(where: { $0.isSelected })
    }
    
    func getSelectedBall() -> ShopItems? {
        let balls = getBalls()
        return balls.first(where: { $0.isSelected })
    }
    
    func getCoins() -> Int {
        return defaults.integer(forKey: coinKey)
    }
    
    func setCoins(_ coins: Int) {
        defaults.set(coins, forKey: coinKey)
    }
    
    func addCoins(_ amount: Int) {
        let currentCoins = defaults.integer(forKey: coinKey)
        let newTotal = currentCoins + amount
        defaults.set(newTotal, forKey: coinKey)
    }
    
    func getLevel() -> Int {
        return defaults.integer(forKey: levelKey)
    }
    
    func setLevel(_ level: Int) {
        let current = defaults.integer(forKey: levelKey)
        defaults.set(current + level, forKey: levelKey)
    }
    
    func getPlatforms() -> [ShopItems] {
        guard let data = defaults.data(forKey: platformsKey),
              let items = try? JSONDecoder().decode([ShopItems].self, from: data) else {
            savePlatforms(initialPlatforms)
            return initialPlatforms
        }
        return items
    }
    
    func savePlatforms(_ platforms: [ShopItems]) {
        if let data = try? JSONEncoder().encode(platforms) {
            defaults.set(data, forKey: platformsKey)
        }
    }
    
    func getBalls() -> [ShopItems] {
        guard let data = defaults.data(forKey: ballsKey),
              let items = try? JSONDecoder().decode([ShopItems].self, from: data) else {
            saveBalls(initialBalls)
            return initialBalls
        }
        return items
    }
    
    func saveBalls(_ balls: [ShopItems]) {
        if let data = try? JSONEncoder().encode(balls) {
            defaults.set(data, forKey: ballsKey)
        }
    }
    
    func purchaseItem(type: StoreSelected, itemID: String) -> Bool {
        var items: [ShopItems]
        
        switch type {
        case .platforms:
            items = getPlatforms()
        case .balls:
            items = getBalls()
        }
        
        guard let index = items.firstIndex(where: { $0.id == itemID }) else { return false }
        let item = items[index]
        
        if item.isAvailivle || item.isSelected {
            items = selectItem(items: items, selectedID: itemID)
            saveItems(type: type, items: items)
            return true
        }
        
        let currentCoins = getCoins()
        guard currentCoins >= item.cost else {
            return false
        }
        
        setCoins(currentCoins - item.cost)
        
        items[index].isAvailivle = true
        items = selectItem(items: items, selectedID: itemID)
        saveItems(type: type, items: items)
        
        return true
    }
    
    private func selectItem(items: [ShopItems], selectedID: String) -> [ShopItems] {
        items.map { item in
            var newItem = item
            if item.id == selectedID {
                newItem.isSelected = true
                newItem.isAvailivle = true
            } else if item.isSelected {
                newItem.isSelected = false
                newItem.isAvailivle = true
            }
            return newItem
        }
    }
    
    private func saveItems(type: StoreSelected, items: [ShopItems]) {
        switch type {
        case .platforms:
            savePlatforms(items)
        case .balls:
            saveBalls(items)
        }
    }
    
    func resetShop() {
        defaults.removeObject(forKey: coinKey)
        defaults.removeObject(forKey: levelKey)
        defaults.removeObject(forKey: platformsKey)
        defaults.removeObject(forKey: ballsKey)
        
        setCoins(500)
        setLevel(1)
        savePlatforms(initialPlatforms)
        saveBalls(initialBalls)
    }
}
