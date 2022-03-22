//
//  ContentView.swift
//  Honeymoon
//
//  Created by wizz on 12/10/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var showbookingAlert =  false
    @State var showGuideView =  false
    @State var showInfoView =  false
    @State var lastCardIndex =  1
    
    @State var cardRemovalTransition = AnyTransition.trailingBottom
    @GestureState private var dragState = DragState.inactive
    private var dragAreaThreshold: CGFloat = 65.0
    
    //MARK: - DRAG STATE
    enum DragState {
        case inactive
        case pressing
        case dragging(transaction: CGSize)
        
        var translation: CGSize {
            switch self {
                case .inactive, .pressing:
                    return .zero
                case .dragging(let translation):
                    return translation
            }
        }
        
        var isDragging: Bool {
            switch self {
                case .dragging:
                    return true
                case .pressing, .inactive:
                    return false
            }
        }
        
        var isPressing: Bool {
            switch self {
                case .dragging, .pressing:
                    return true
                case .inactive:
                    return false
            }
        }
    }
    
    //MARK: - CARD VIEWS
    
    @State var cardViews: [CardView] = {
        var views = [CardView]()
        for index in 0..<2 {
            views.append(CardView(honeymoon: honeymoonDatas[index]))
        }
        return views
    }()
    
    //MARK: - MOVE CARD
    func moveCards(){
        playSound(sound: "sound-rise", type: "mp3")
        cardViews.removeFirst()
        lastCardIndex += 1
        let honeymoon = honeymoonDatas[lastCardIndex % honeymoonDatas.count]
        let newCardView = CardView(honeymoon: honeymoon)
        cardViews.append(newCardView)
    }
    
    //MARK: - TOP CARD
    
    private func isTopCard(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else {
            return false
        }
        return index == 0
    }
    
    var body: some View {
        VStack{
            //MARK: - Header
            HeaderView(showGuideView: $showGuideView, showInfoView: $showInfoView)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default, value: dragState.isDragging)
            Spacer()
            //MARK: - CARDS
            ZStack{
                ForEach(cardViews){cardView in
                    cardView
                        .zIndex(isTopCard(cardView: cardView) ? 1 : 0)
                        .overlay(
                            ZStack{
                                Image(systemName: "x.circle")
                                    .modifier(SymbolModifier())
                                    .opacity(dragState.translation.width < -dragAreaThreshold && isTopCard(cardView: cardView) ? 1.0 : 0.0)
                                
                                Image(systemName: "heart.circle")
                                    .modifier(SymbolModifier())
                                    .opacity(dragState.translation.width > dragAreaThreshold && isTopCard(cardView: cardView) ? 1.0 : 0.0)
                            }
                        )
                        .offset(x: isTopCard(cardView: cardView) ? dragState.translation.width : 0, y: isTopCard(cardView: cardView) ? dragState.translation.height : 0)
                        .scaleEffect(dragState.isDragging && isTopCard(cardView: cardView) ? 0.85 : 1.0)
                        .rotationEffect(Angle(degrees: isTopCard(cardView: cardView) ? Double(dragState.translation.width / 12) : 0))
                        .animation(.interpolatingSpring(stiffness: 120, damping: 120), value: dragState.isDragging)
                        .gesture(LongPressGesture(minimumDuration: 0.01)
                                    .sequenced(before: DragGesture())
                                    .updating($dragState, body: { value, state, transaction in
                            switch value {
                                case .first(true):
                                    state = .pressing
                                case .second(true, let drag):
                                    state = .dragging(transaction: drag?.translation ?? .zero)
                                default:
                                    break
                            }
                        })
                                    .onChanged({ value in
                            guard case .second(true, let drag?) = value else { return }
                            if drag.translation.width < -dragAreaThreshold {
                                cardRemovalTransition = .leadingBottom
                            }
                            if drag.translation.width > dragAreaThreshold {
                                cardRemovalTransition = .trailingBottom
                            }
                        })
                                    .onEnded({ value in
                            guard case .second(true, let drag?) = value else { return }
                            if drag.translation.width < -dragAreaThreshold || drag.translation.width > dragAreaThreshold {
                                moveCards()
                            }
                        })
                        )
                        .transition(cardRemovalTransition)
                }
            }
            .padding(.horizontal)
            //            CardView(honeymoon: honeymoonDatas[3])
            //                .padding()
            Spacer()
            //MARK: - Footer
            FooterView(showbookingAlert: $showbookingAlert)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default, value: dragState.isDragging)
        }
        .alert(isPresented: $showbookingAlert) {
            Alert(title: Text("SUCCESS"), message: Text("Wishing a lovely and most precious of the times together for the amazing couple."), dismissButton: .default(Text("Happy Honeymoon!")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
