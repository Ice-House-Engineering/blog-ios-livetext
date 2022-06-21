//
//  ContentView.swift
//  DemoLiveTextImageSwiftUI
//
//  Created by Arifin Firdaus Ice House on 21/06/22.
//

import SwiftUI
import VisionKit

struct ContentView: View {

	@State private var showImagePicker = false
	@State private var inputImage: UIImage? = UIImage(named: "image-1")


	var body: some View {
		VStack {
			if #available(iOS 16.0, *) {

				ScrollView([.horizontal,. vertical], showsIndicators: false) {
					ImageView(image: $inputImage)
						.aspectRatio(contentMode: .fit)
				}

				Button {
					guard let image = [ UIImage(named: "image-1"), UIImage(named: "image-2") ].randomElement() else {
						return
					}
					inputImage = image
				} label: {
					Text("Change Image")
				}

			} else {
				Text("iOS not supported")
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

@available(iOS 16.0, *)
struct ImageView: UIViewRepresentable {

	@Binding var image: UIImage?

	let analyzer = ImageAnalyzer()
	let interaction = ImageAnalysisInteraction()

	@MainActor func makeUIView(context: Context) -> UIImageView {
		let imageView = UIImageView()
		imageView.addInteraction(interaction)
		imageView.contentScaleFactor = 100
		return imageView
	}

	func updateUIView(_ uiView: UIImageView, context: Context) {
		uiView.image = image
		interaction.reset()
		analyzeCurrentImage()
	}

	@MainActor func analyzeCurrentImage() {
		guard let image = image else { return } // 1
		Task {
			do {
				let configuration = ImageAnalyzer.Configuration([.text, .machineReadableCode]) // 2
				let analysis = try await analyzer.analyze(image, configuration: configuration) // 3

				guard let analysis = analysis, image == self.image else { return } // 4

				interaction.analysis = analysis // 5
				interaction.preferredInteractionTypes = .automatic // 6
			} catch {
				print(error)
			}
		}
	}
}

private extension ImageAnalysisInteraction {
	func reset() {
		preferredInteractionTypes = []
		analysis = nil
	}
}
