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

	var body: some View {

		GeometryReader { geometry in

			ZStack {

				Path { path in

					let width:CGFloat = min(geometry.size.width, geometry.size.height)
					let height = width

					path.addRect(CGRect(
						x: 0,
						y: 0,
						width: width,
						height: height
					))

				}
				.fill(Color.white)

				Path { path in

					let width:CGFloat = min(geometry.size.width, geometry.size.height)
					let height = width

					path.addRect(CGRect(
						x: self.x + (width / 2),
						y: self.y + (height / 2),
						width: 4,
						height: 4
					))

				}
				.fill(Color.black)

			}
			.frame(
				minWidth: 50,
				idealWidth: 60,
				maxWidth: 200,
				minHeight: 50,
				idealHeight: 60,
				maxHeight: 200,
				alignment: .center
			)

		}

	}

}

struct Coords2d_Previews: PreviewProvider {
	static var previews: some View {
		Coords2d(x:10, y:10)
	}
}
