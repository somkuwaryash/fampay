//
//  CardGroupView.swift
//  Fampay
//
//  Created by Yash Somkuwar on 08/02/24.
//

import SwiftUI

struct CardGroupView: View {
    let cardGroup: CardGroup

    var body: some View {
        VStack(spacing: 20) {

            if cardGroup.is_scrollable == true && cardGroup.design_type != .DYNAMIC_WIDTH_CARD {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(cardGroup.cards) { card in
                            CardView(card: card, designType: cardGroup.design_type ?? .SMALL_DISPLAY_CARD)
                                .padding()
                        }
                    }
                }
            } else {
                HStack(spacing: 20) {
                    ForEach(cardGroup.cards) { card in
                        CardView(card: card, designType: cardGroup.design_type ?? .SMALL_DISPLAY_CARD)
                            .padding()
                    }
                }
            }
        }
        .padding()
    }
}


struct CardGroupView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCardGroup = CardGroup(id: 1,
                                         name: "Sample Card Group",
                                         design_type: .SMALL_DISPLAY_CARD,
                                         card_type: 0,
                                         cards: [],
                                         height: nil,
                                         is_scrollable: true)
        
        return CardGroupView(cardGroup: sampleCardGroup)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}




//#Preview {
//    CardGroupView()
//}
