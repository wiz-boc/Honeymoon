//
//  FooterView.swift
//  Honeymoon
//
//  Created by wizz on 12/10/21.
//

import SwiftUI

struct FooterView: View {
    @Binding var showbookingAlert: Bool
     let hapticfeed = UINotificationFeedbackGenerator()
    var body: some View {
        HStack {
            Image(systemName: "xmark.circle")
                .font(.system(size: 42, weight: .light))

            Spacer()
            Button {
                //print("Success")
                playSound(sound: "sound-click", type: "mp3")
                showbookingAlert.toggle()
                hapticfeed.notificationOccurred(.success)
            } label: {
                Text("Book Destination".uppercased())
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.heavy)
                    .padding(.horizontal, 20)
                    .padding(.vertical,12)
                    .tint(.pink)
                    .background(
                        Capsule()
                            .stroke(.pink, lineWidth: 2)
                    )
            }

            Spacer()
            Image(systemName: "heart.circle")
                .font(.system(size: 42, weight: .light))
        }
        .padding()
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView(showbookingAlert: .constant(false))
            .previewLayout(.fixed(width: 375, height: 80))
    }
}
