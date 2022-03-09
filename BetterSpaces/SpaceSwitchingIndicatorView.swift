//
//  SpaceSwitchingIndicatorView.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 09/03/2022.
//

import SwiftUI

struct SpaceSwitchingIndicatorView: View {
    var rows: Int
    var columns: Int
    @ObservedObject var spaceSelector : SpaceSelector
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.pink)
            VStack(spacing: 5) {
                ForEach(0...rows-1, id: \.self) { i in
                    HStack(spacing: 5) {
                        ForEach(0...columns-1, id: \.self) { j in
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(
                                    spaceSelector.selectedSpace == i*rows+j ?  Color(.sRGB, red: 10, green: 10, blue: 10, opacity: 1) : .gray)
                        }
                    }.padding(0)
                    }
            }.padding(5)
        }
    }
    
    init(rows: Int, columns: Int, spaceSelector: SpaceSelector) {
        self.rows = rows
        self.columns = columns
        self.spaceSelector = spaceSelector
    }
}



struct SpaceSwitchingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        SpaceSwitchingIndicatorView(rows: 3, columns: 3, spaceSelector: SpaceSelector())
    }
}

extension RoundedRectangle {
    func makeSelectable(index: Int, selectedIndex: Binding<Int>) -> some View {
        if index == selectedIndex.wrappedValue {
            return self.foregroundColor(Color(.sRGB, red: 10, green: 10, blue: 10, opacity: 1))
        } else {
            return self.foregroundColor(.gray)
        }
    }
}
