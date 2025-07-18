//
//  ContentView.swift
//  ZoomingCarousel
//
//  Created by Sanchit Mittal on 18/07/25.
//

import SwiftUI

struct ContentView: View {
    let imageLinks = [
        URL(string: "https://picsum.photos/id/1015/600/400")!,
        URL(string: "https://picsum.photos/id/1024/600/400")!,
        URL(string: "https://picsum.photos/id/1038/600/400")!
    ]
    
    var body: some View {
        CarouselContainerView(imageURLs: imageLinks)
    }
}

#Preview {
    ContentView()
}
