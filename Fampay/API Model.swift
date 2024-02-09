//
//  API Model.swift
//  Fampay
//
//  Created by Yash Somkuwar on 08/02/24.
//

import Foundation
import SwiftUI

struct APIResponse: Codable {
    var id: Int
    var slug: String?
    var title: String?
    var formatted_title: String?
    var description: String?
    var formatted_description: String?
    var assets: String?
    var hc_groups: [CardGroup]
}


//enum DesignTypes: String, Codable {
//    case SMALL_DISPLAY_CARD = "HC1"
//    case BIG_DISPLAY_CARD = "HC3"
//    case IMAGE_CARD = "HC5"
//    case SMALL_CARD_WITH_ARROW = "HC6"
//    case DYNAMIC_WIDTH_CARD = "HC9"
//}


struct Entity: Codable {
    var text: String?
    var color: String?
    var url: String?
    var font_style: String?
    var type: String?
}

struct CallToAction: Codable {
    var text: String?
    var bg_color: String?
    var url: String?
    var text_color: String?
}

struct GradientModel: Codable {
    var colors: [String]
    var angle: Int?
}

struct CardImage: Codable {
    var image_type: String?
    var asset_type: String?
    var image_url: String?
}

struct FormattedText: Codable {
    var text: String?
    var entities: [Entity]
}

struct Card: Identifiable, Codable {
    var id: Int?
    var name: String?
    var formatted_title: FormattedText?
    var title: String?
    var formatted_description: FormattedText?
    var description: String?
    var icon: CardImage?
    var url: String?
    var bg_image: CardImage?
    var bg_color: String?
    var bg_gradient: GradientModel?
    var cta: [CallToAction]?
}

struct CardGroup: Identifiable, Codable {
    var id: Int?
    var name: String?
    var design_type: DesignTypes?
    var card_type: Int?
    var cards: [Card]
    var height: Double?
    var is_scrollable: Bool?
}


