//
//  Coords2d.swift
//  GamePad
//
//  Created by Marco Luglio on 12/07/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation
import SwiftUI



struct Coords2d: View {

	var x:CGFloat
	var y:CGFloat
	var foregroundColor:Color = Color.white

	var body: some View {

		GeometryReader { geometry in

			ZStack {

				Path { path in

					let width:CGFloat = geometry.size.width//min(geometry.size.width, geometry.size.height)
					let height = geometry.size.height

					path.addRect(
						CGRect(
							x: geometry.frame(in: .local).midX - width / 2,
							y: geometry.frame(in: .local).midY - height / 2,
							width: width,
							height: height
						)
					)

				}
				.fill(self.foregroundColor)
				.cornerRadius(8)

				Path { path in

					//let width:CGFloat = min(geometry.size.width, geometry.size.height)
					let size:CGFloat = 4

					path.addRect(CGRect(
						x: self.x + geometry.frame(in: .local).midX - size / 2,
						y: self.y + geometry.frame(in: .local).midY - size / 2,
						width: size,
						height: size
					))

				}
				.fill(Color.black)

			}

		}

	}

}

struct Coords2d_Previews: PreviewProvider {
	static var previews: some View {
		Coords2d(x:10, y:10)
	}
}
