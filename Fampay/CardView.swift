import SwiftUI

struct CardView: View {
    let card: Card
    let designType: DesignTypes
    
    @State private var showReminderActions = false
    @State private var isSliding = false
    @State private var isDismissed = false
    
    var body: some View {
        VStack(spacing: 10) {
            switch designType {
            case .SMALL_DISPLAY_CARD:
                renderSmallDisplayCard()
            case .BIG_DISPLAY_CARD:
                renderBigDisplayCard()
                    .gesture(
                        LongPressGesture(minimumDuration: 1)
                            .onEnded { _ in
                                showReminderActions.toggle()
                            }
                    )
            case .IMAGE_CARD:
                renderImageCard()
            case .SMALL_CARD_WITH_ARROW:
                renderSmallCardWithArrow()
            case .DYNAMIC_WIDTH_CARD:
                renderDynamicWidthCard()
            }
        }
        .padding()
        .background(
            Group {
                if let bgColor = card.bg_color, designType != .BIG_DISPLAY_CARD && designType != .IMAGE_CARD {
                    Color(hex: bgColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: designType.backgroundHeight)
                        .padding()
                } else if let bgGradient = card.bg_gradient, designType != .BIG_DISPLAY_CARD && designType != .IMAGE_CARD {
                    LinearGradient(
                        gradient: Gradient(colors: bgGradient.colors.map { Color(hex: $0) }),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: designType.backgroundHeight)
                    .padding()
                } else if let bgImage = card.bg_image, let imageUrl = bgImage.image_url, designType != .BIG_DISPLAY_CARD && designType != .IMAGE_CARD {
                    if let dimensions = imageDimensions(url: imageUrl) {
                        AsyncImage(url: URL(string: imageUrl)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: CGFloat(dimensions.width), height: CGFloat(dimensions.height))
                            case .failure(_), .empty:
                                Image("placeholder")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: designType.backgroundHeight)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .padding(.horizontal, 20)
                    } else {
                        Color.clear
                            .frame(maxWidth: .infinity)
                            .frame(height: designType.backgroundHeight)
                    }
                }
            }
        )
        .cornerRadius(10)
        .shadow(radius: 5)
        .onTapGesture {
            if let url = card.url, let deepLink = URL(string: url) {
                UIApplication.shared.open(deepLink)
            }
        }
    }



    private func renderSmallDisplayCard() -> some View {
        VStack(alignment: .leading) {
            parseFormattedText(card.formatted_title ?? FormattedText(text: card.title ?? "", entities: []))
                .font(.title)
                .padding()
            
            parseFormattedText(card.formatted_description ?? FormattedText(text: card.description ?? "", entities: []))
                .font(.body)
                .padding()
        }

        .frame(maxWidth: .infinity)
        .frame(height: designType.backgroundHeight)
        .frame(width: UIScreen.main.bounds.width - 40)
        .padding()
    }

    
    private func renderBigDisplayCard() -> some View {
        let cardContent = VStack {
            VStack(alignment: .leading) {
                parseFormattedText(card.formatted_title ?? FormattedText(text: card.title ?? "", entities: []))
                    .font(.title)
                    .lineLimit(3)
                    .padding()
                
                parseFormattedText(card.formatted_description ?? FormattedText(text: card.description ?? "", entities: []))
                    .font(.body)
                    .lineLimit(3)
                    .padding()
            }

        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: designType.backgroundHeight)
        
        let slidingGesture = LongPressGesture(minimumDuration: 1)
            .onChanged { _ in
                isSliding = true
            }
            .onEnded { _ in
                showReminderActions.toggle()
            }
        
        return ZStack {
            ZStack {
                if let bgImageUrl = card.bg_image?.image_url,
                   let dimensions = imageDimensions(url: bgImageUrl) {
                    AsyncImage(url: URL(string: bgImageUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .padding(40)
                                .frame(width: UIScreen.main.bounds.width - 40, height: CGFloat(dimensions.height))
                                
                        case .failure(_), .empty:
                            Color.clear
                        @unknown default:
                            Color.clear
                        }
                    }
                    .clipped()
                    .cornerRadius(10)
                    .shadow(radius: 5)
                } else {
                    Color.clear
                }
                
                cardContent
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if let url = card.url, let deepLink = URL(string: url) {
                    UIApplication.shared.open(deepLink)
                }
            }
            
            VStack {
                Spacer()
                if showReminderActions {
                    VStack(alignment: .leading) {
                        Button(action: {
                            remindLater()
                            isSliding = false
                            showReminderActions = false
                        }) {
                            Text("Remind Later")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                        
                        Button(action: {
                            dismissCard()
                            isSliding = false
                            showReminderActions = false
                        }) {
                            Text("Dismiss Now")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .offset(x: 0, y: -UIScreen.main.bounds.height / 4)
                }
            }
        }
        .gesture(slidingGesture)
        .animation(.spring())
        .offset(x: isSliding ? UIScreen.main.bounds.width / 2 : 0)
    }

    
    private func renderImageCard() -> some View {
        VStack {
            if let imageUrl = card.bg_image?.image_url {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    default:
                        Color.clear
                    }
                }
            } else {
                Color.clear
            }
            
            
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 40)
        .padding()
    }

    
    private func renderSmallCardWithArrow() -> some View {
        HStack {
            VStack(alignment: .leading) {
                parseFormattedText(card.formatted_title ?? FormattedText(text: card.title ?? "", entities: []))
                    .font(.headline)
                    .foregroundColor(Color.black)
                
                parseFormattedText(card.formatted_description ?? FormattedText(text: card.description ?? "", entities: []))
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.black)
        }
        .padding()
    }

    
    private func renderDynamicWidthCard() -> some View {
        if let bgImage = card.bg_image, let imageUrl = bgImage.image_url {
            return AnyView(
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .cornerRadius(10)
                    case .failure(_), .empty:
                        Image("placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: designType.backgroundHeight)
                            .cornerRadius(10)
                    @unknown default:
                        EmptyView()
                    }
                }
            )
        } else {
            return AnyView(EmptyView()) // Return an empty view if there is no image
        }
    }
    
    func imageDimensions(url: String) -> (width: Int, height: Int)? {
        if let imageSource = CGImageSourceCreateWithURL(URL(string: url)! as CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] {
                if let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as? Int,
                   let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as? Int {
                    return (width: pixelWidth, height: pixelHeight)
                }
            }
        }
        return nil
    }
    
    private func dismissCard() {
        isSliding = false
    }

    private func remindLater() {
        isSliding = false
    }
    
    private func parseFormattedText(_ formattedText: FormattedText) -> Text {
        guard let baseText = formattedText.text, !baseText.isEmpty else {
            return Text("")
        }
        
        let entities = formattedText.entities
        
        var parsedText = Text("")
        
        var currentIndex = baseText.startIndex
        while let braceRange = baseText.range(of: "{}", range: currentIndex ..< baseText.endIndex) {
            parsedText = parsedText + Text(baseText[currentIndex ..< braceRange.lowerBound])
            
            let entityIndex = (currentIndex.utf16Offset(in: baseText) + 1) / 2 - 1
            
            if entityIndex >= 0 && entityIndex < entities.count {
                let entity = entities[Int(entityIndex)]
                
                var entityText = Text(entity.text ?? "")
                
                if let colorHex = entity.color {
                    entityText = entityText.foregroundColor(Color(hex: colorHex))
                }
                
                if let url = entity.url {
                    entityText = entityText.onTapGesture {
                        guard let url = URL(string: url) else { return }
                        UIApplication.shared.open(url)
                    } as! Text
                }
                
                if let fontStyle = entity.font_style {
                    if fontStyle == "underline" {
                        entityText = entityText.underline()
                    } else if fontStyle == "strike-through" {
                        entityText = entityText.strikethrough()
                    }
                }
                
                parsedText = parsedText + entityText
            }
            
            currentIndex = braceRange.upperBound
        }
        
        parsedText = parsedText + Text(baseText[currentIndex...])
        
        return parsedText
    }




}



enum DesignTypes: String, Codable {
    case SMALL_DISPLAY_CARD = "HC1"
    case BIG_DISPLAY_CARD = "HC3"
    case IMAGE_CARD = "HC5"
    case SMALL_CARD_WITH_ARROW = "HC6"
    case DYNAMIC_WIDTH_CARD = "HC9"
    
    var backgroundHeight: CGFloat {
        switch self {
        case .SMALL_DISPLAY_CARD, .SMALL_CARD_WITH_ARROW:
            return 60
        case .BIG_DISPLAY_CARD:
            return 250
        case .IMAGE_CARD:
            return 195
        case .DYNAMIC_WIDTH_CARD:
            return 200 
        }
    }
}
