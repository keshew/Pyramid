import SwiftUI

struct Loading: View {
    @State private var currentIndex = 0
    @State private var fillWidth: CGFloat = 0
    @State private var progress = 0
    @State var isMain = false
    private let array = ["Loading.", "Loading..", "Loading..."]
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    private let progressTimer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    let maxWidth: CGFloat = 232
    
    var body: some View {
        ZStack {
            Image(.bgLoading)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("BALL  DROP ")
                    .CustomFontGradient(size: 40)
                    .outlineTextLess(color: Color(red: 255/255, green: 135/255, blue: 2/255), width: 1)
                    .outlineText(color: Color(red: 190/255, green: 28/255, blue: 0/255), width: 0.5)
                    .padding(.top, 150)
                
                Text("PYRAMID ")
                    .CustomFontGradient(size: 40)
                    .outlineTextLess(color: Color(red: 255/255, green: 135/255, blue: 2/255), width: 1)
                    .outlineText(color: Color(red: 190/255, green: 28/255, blue: 0/255), width: 0.5)
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text(array[currentIndex])
                        .CustomFont(size: 20)
                    
                    Text("\(progress)%")
                        .CustomFont(size: 16)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill()
                            .frame(width: 250, height: 24)
                            .cornerRadius(16)
                        
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 242/255, green: 2/255, blue: 245/255),
                                                          Color(red: 204/255, green: 0/255, blue: 249/255),
                                                          Color(red: 128/255, green: 0/255, blue: 218/255)], startPoint: .top, endPoint: .bottom))
                            .frame(width: fillWidth, height: 14)
                            .cornerRadius(20)
                            .padding(.leading, 8)
                            .offset(y: 0.7)
                            .animation(.linear(duration: 3), value: fillWidth)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onReceive(timer) { _ in
            currentIndex = (currentIndex + 1) % array.count
        }
        .onReceive(progressTimer) { _ in
            if progress < 100 {
                progress += 1
            } else {
                progressTimer.upstream.connect().cancel()
                isMain = true
            }
        }
        .onAppear {
            fillWidth = maxWidth
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isMain = true
            }
        }
        .fullScreenCover(isPresented: $isMain) {
            MainView()
        }
    }
}

#Preview {
    Loading()
}

extension Text {
    func CustomFont(size: CGFloat,
                    color: Color = .white)  -> some View {
        self.font(.custom("Adira Display SSi", size: size))
            .foregroundColor(color)
    }
    
    func CustomFontGradient(size: CGFloat,
                            color: LinearGradient = LinearGradient(colors: [Color(red: 255/255, green: 218/255, blue: 1/255),
                                                                            .white,
                                                                            Color(red: 255/255, green: 218/255, blue: 1/255),
                                                                            .white], startPoint: .top, endPoint: .bottom))  -> some View {
                                                                                self.font(.custom("Adira Display SSi", size: size))
                                                                                    .foregroundStyle(color)
                                                                            }
}

extension View {
    func outlineText(color: Color, width: CGFloat) -> some View {
        modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
    
    func outlineTextLess(color: Color, width: CGFloat) -> some View {
        modifier(StrokeModifierLess(strokeSize: width, strokeColor: color))
    }
}

struct StrokeModifier: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background (Rectangle()
                .foregroundStyle(strokeColor)
                .mask({
                    outline(context: content)
                })
            )}
    
    func outline(context:Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                if let text = context.resolveSymbol(id: id) {
                    layer.draw(text, at: .init(x: size.width/1.95, y: size.height/1.9))
                }
            }
        } symbols: {
            context.tag(id)
                .blur(radius: strokeSize)
        }
    }
}

struct StrokeModifierLess: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background (Rectangle()
                .foregroundStyle(strokeColor)
                .mask({
                    outline(context: content)
                })
            )}
    
    func outline(context:Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                if let text = context.resolveSymbol(id: id) {
                    layer.draw(text, at: .init(x: size.width/2, y: size.height/2))
                }
            }
        } symbols: {
            context.tag(id)
                .blur(radius: strokeSize)
        }
    }
}
