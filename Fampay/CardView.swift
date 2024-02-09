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
                                                    isSliding.toggle()
                                                }
                                        )
                                        .offset(x: isSliding ? UIScreen.main.bounds.width : 0)
                                        .onTapGesture {
                                            if !isSliding {
                                                openURL()
                                            }
                                        }
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
                if let bgColor = card.bg_color {
                    Color(hex: bgColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: designType.backgroundHeight)
                        .padding()
                } else if let bgGradient = card.bg_gradient {
                    LinearGradient(
                        gradient: Gradient(colors: bgGradient.colors.map { Color(hex: $0) }),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: designType.backgroundHeight)
                    .padding()
                } else if let bgImage = card.bg_image, let imageUrl = bgImage.image_url {
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
        VStack {
            Text(card.formatted_title?.text ?? card.title ?? "")
                .font(.headline)
                .foregroundColor(Color.black)
            Text(card.formatted_description?.text ?? card.description ?? "")
                .font(.subheadline)
                .foregroundColor(Color.gray)
            // Add more views if needed
        }
        .frame(maxWidth: .infinity)
        .frame(height: designType.backgroundHeight)
        .frame(width: UIScreen.main.bounds.width - 40)
        .padding()
    }
    
    private func renderBigDisplayCard() -> some View {
        VStack {
            Text(card.formatted_title?.text ?? card.title ?? "")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .lineLimit(3) // Limit number of lines for title
                .padding()
            
            Text(card.formatted_description?.text ?? card.description ?? "")
                .font(.body)
                .foregroundColor(Color.white)
                .lineLimit(3) // Limit number of lines for description
                .padding()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: designType.backgroundHeight)
        .background(
            // Background rendering code
        )
        .cornerRadius(10)
        .shadow(radius: 5)
        .offset(x: isSliding ? UIScreen.main.bounds.width / 2 : 0) // Offset the card to the right when sliding
        .gesture(
            LongPressGesture(minimumDuration: 1)
                .onChanged { _ in
                    isSliding = true // Start sliding animation on long-press gesture
                }
                .onEnded { _ in
                    showReminderActions.toggle() // Toggle the visibility of action buttons
                }
        )
        .animation(.spring()) // Add animation to sliding effect
        
        
        return VStack {
            Spacer()
            HStack {
                Button(action: {
                    remindLater()
                }) {
                    Text("Remind Later")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                
                Button(action: {
                    dismissCard()
                }) {
                    Text("Dismiss Now")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(8)
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
            .offset(x: showReminderActions ? 0 : -UIScreen.main.bounds.width / 2)
            .animation(.spring())
        }
        .edgesIgnoringSafeArea(.all)
    }


    
    private func renderImageCard() -> some View {
        VStack {
            // Add more views if needed
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private func renderSmallCardWithArrow() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(card.formatted_title?.text ?? card.title ?? "")
                    .font(.headline)
                    .foregroundColor(Color.black)
                Text(card.formatted_description?.text ?? card.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            Image(systemName: "arrow.right")
                .foregroundColor(Color.blue)
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
            isDismissed = true
        }
        
        private func remindLater() {
            isSliding = false
        }
        
        private func openURL() {
            if let url = card.url, let deepLink = URL(string: url) {
                        UIApplication.shared.open(deepLink)
                    }
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
            return 200 // Set a default height
        }
    }
}
