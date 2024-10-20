//
//  CardDisplay.swift
//  ios-app
//
//  Created by Tabitha on 10/17/24.
//

import SwiftUI

struct CardDisplay: View {
    var front: String
    var back: String
    @State var showBack: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            Text(showBack ? back : front)
                .font(.title)
            Spacer()
        }
        .padding(.vertical, 110)
        .padding(.horizontal, 10)
        .background(Color.offWhite.shadow(.drop(color:.black, radius: 20, y:5)))
        .gesture(TapGesture()
            .onEnded { _ in
                showBack = !showBack
            })
    }
}

extension Color {
    static let offWhite = Color(hue:0.1, saturation: 0.13, brightness:1)
    
    init?(hex: String) {
      let r, g, b: Double

      var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
      hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

      var rgb: UInt64 = 0
      Scanner(string: hexSanitized).scanHexInt64(&rgb)

      switch hexSanitized.count {
      case 3: // RGB
        (r, g, b) = (
          Double((rgb >> 8) & 0xF) / 15.0,
          Double((rgb >> 4) & 0xF) / 15.0,
          Double(rgb & 0xF) / 15.0
        )
      case 6: // RRGGBB
        (r, g, b) = (
          Double((rgb >> 16) & 0xFF) / 255.0,
          Double((rgb >> 8) & 0xFF) / 255.0,
          Double(rgb & 0xFF) / 255.0
        )
      default:
        return nil
      }

      self.init(red: r, green: g, blue: b)
    }
}
#Preview {
    CardDisplay(front:"hola", back:"hello")
}
