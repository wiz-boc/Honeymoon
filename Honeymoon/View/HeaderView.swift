//
//  HeaderView.swift
//  Honeymoon
//
//  Created by wizz on 12/10/21.
//

import SwiftUI

struct HeaderView: View {
    
    @Binding var showGuideView: Bool
    @Binding var showInfoView: Bool
    let hapticfeed = UINotificationFeedbackGenerator()
    
    var body: some View {
        HStack {
            Button {
                playSound(sound: "sound-click", type: "mp3")
                hapticfeed.notificationOccurred(.success)
                showInfoView.toggle()
            } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 24, weight: .regular))
            }
            .tint(.primary)
            Spacer()
            Image("logo-honeymoon-pink")
                .resizable()
                .scaledToFit()
                .frame(height: 28)
            Spacer()
            Button {
                hapticfeed.notificationOccurred(.success)
                playSound(sound: "sound-click", type: "mp3")
                showGuideView.toggle()
            } label: {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 24, weight: .regular))
            }
            .tint(.primary)
            .sheet(isPresented: $showGuideView){
                GuideView()
            }
            .sheet(isPresented: $showInfoView){
                InfoView()
            }

        }
        .padding()
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(showGuideView: .constant(false), showInfoView: .constant(false))
            .previewLayout(.fixed(width: 375, height: 80))
    }
}
