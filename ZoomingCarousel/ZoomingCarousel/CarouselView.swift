//
//  CarouselView.swift
//  ZoomingCarousel
//
//  Created by Sanchit Mittal on 18/07/25.
//

import SwiftUI

struct CarouselView: View {
    let imageURLs: [URL]
    let baseSize: CGFloat = UIScreen.main.bounds.width - 50
    let zoomedHeight: CGFloat = UIScreen.main.bounds.width
    let overlap: CGFloat = 10
    let threshold = 20.0
    
    @Binding var currentIndex: Int
    @State private var scrollOffset: CGFloat
    
    init(imageURLs: [URL], currentIndex: Binding<Int>) {
        self.imageURLs = imageURLs
        self._currentIndex = currentIndex
        self.scrollOffset = -1*(CGFloat(currentIndex.wrappedValue) * baseSize) + overlap
    }
    
    var body: some View {
        GeometryReader { outerProxy in
            let screenWidth = outerProxy.size.width
            let cardWidth = baseSize - overlap
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(imageURLs.indices, id: \.self) { index in
                        GeometryReader { geo in
                            let frame = geo.frame(in: .global)
                            let midX = frame.midX
                            let distance = abs(midX - screenWidth / 2)
                            let height = max(baseSize, zoomedHeight - (distance / screenWidth) * (zoomedHeight - baseSize))
                            
                            AsyncImage(url: imageURLs[index]) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    Color.red
                                }
                            }
                            .frame(width: baseSize, height: height)
                            .clipped()
                            .cornerRadius(16)
                            .animation(.easeInOut(duration: 0.25), value: height)
                            .offset(y: (zoomedHeight - height) / 2) // center growth
                            .zIndex(currentIndex == index ? 1.0 : 0.0)
                        }
                        .frame(width: baseSize, height: zoomedHeight)
                    }
                }
                .padding(.horizontal, 10)
            }
            .content.offset(x: scrollOffset)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let direction = value.translation.width > threshold ? -1 :
                        value.translation.width < -threshold ? 1 : 0
                        let clampedIndex = max(0, min(imageURLs.count - 1, currentIndex + direction))
                        withAnimation(.easeOut) {
                            scrollOffset = -CGFloat(clampedIndex) * cardWidth
                            currentIndex = clampedIndex
                        }
                    }
                    .onChanged { value in
                        scrollOffset = -CGFloat(currentIndex) * cardWidth + value.translation.width
                    }
            )
        }
        .frame(height: zoomedHeight)
    }
}

#Preview {
    CarouselView(imageURLs: [URL(string: "https://picsum.photos/id/1015/600/400")!,
                             URL(string: "https://picsum.photos/id/1024/600/400")!,
                             URL(string: "https://picsum.photos/id/1038/600/400")!],
                 currentIndex: .constant(0))
}
