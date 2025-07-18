//
//  CarouselContainerView.swift
//  ZoomingCarousel
//
//  Created by Sanchit Mittal on 18/07/25.
//

import SwiftUI

struct CarouselContainerView: View {
    let imageURLs: [URL]
    @State private var currentIndex: Int
    
    init(imageURLs: [URL]) {
        self.imageURLs = imageURLs
        self.currentIndex = imageURLs.count/2
    }
    
    var body: some View {
        VStack(spacing: 16) {
            CarouselView(imageURLs: imageURLs,
                         currentIndex: $currentIndex)
            
            // 🔘 Page Control
            HStack(spacing: 8) {
                ForEach(0..<imageURLs.count, id: \.self) { index in
                    Circle()
                        .fill(.gray)
                        .opacity(index == currentIndex ? 1 : 0.2)
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
}

#Preview {
    CarouselContainerView(imageURLs: [URL(string: "https://picsum.photos/id/1062/600/400")!])
}
