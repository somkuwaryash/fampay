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


struct Entity: Codable, Equatable {
    var text: String?
    var color: String?
    var url: String?
    var font_style: String?
    var type: String?

    static func == (lhs: Entity, rhs: Entity) -> Bool {
        return lhs.text == rhs.text
            && lhs.color == rhs.color
            && lhs.url == rhs.url
            && lhs.font_style == rhs.font_style
            && lhs.type == rhs.type
    }
}

struct CallToAction: Codable, Equatable {
    var text: String?
    var bg_color: String?
    var url: String?
    var text_color: String?

    static func == (lhs: CallToAction, rhs: CallToAction) -> Bool {
        return lhs.text == rhs.text
            && lhs.bg_color == rhs.bg_color
            && lhs.url == rhs.url
            && lhs.text_color == rhs.text_color
    }
}

struct GradientModel: Codable, Equatable {
    var colors: [String]
    var angle: Int?

    static func == (lhs: GradientModel, rhs: GradientModel) -> Bool {
        return lhs.colors == rhs.colors
            && lhs.angle == rhs.angle
    }
}

struct CardImage: Codable, Equatable {
    var image_type: String?
    var asset_type: String?
    var image_url: String?

    static func == (lhs: CardImage, rhs: CardImage) -> Bool {
        return lhs.image_type == rhs.image_type
            && lhs.asset_type == rhs.asset_type
            && lhs.image_url == rhs.image_url
    }
}

struct FormattedText: Codable, Equatable {
    var text: String?
    var entities: [Entity]

    static func == (lhs: FormattedText, rhs: FormattedText) -> Bool {
        return lhs.text == rhs.text
            && lhs.entities == rhs.entities
    }
}


struct Card: Identifiable, Codable, Equatable {
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

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.formatted_title == rhs.formatted_title
            && lhs.title == rhs.title
            && lhs.formatted_description == rhs.formatted_description
            && lhs.description == rhs.description
            && lhs.icon == rhs.icon
            && lhs.url == rhs.url
            && lhs.bg_image == rhs.bg_image
            && lhs.bg_color == rhs.bg_color
            && lhs.bg_gradient == rhs.bg_gradient
            && lhs.cta == rhs.cta
    }
}


struct CardGroup: Identifiable, Codable, Equatable {
    var id: Int?
    var name: String?
    var design_type: DesignTypes?
    var card_type: Int?
    var cards: [Card]
    var height: Double?
    var is_scrollable: Bool?

    static func == (lhs: CardGroup, rhs: CardGroup) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.design_type == rhs.design_type
            && lhs.card_type == rhs.card_type
            && lhs.cards == rhs.cards
            && lhs.height == rhs.height
            && lhs.is_scrollable == rhs.is_scrollable
    }
}

