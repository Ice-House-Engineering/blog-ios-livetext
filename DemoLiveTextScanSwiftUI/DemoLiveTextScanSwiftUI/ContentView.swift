//
//  ContentView.swift
//  DemoLiveTextScanSwiftUI
//
//  Created by Arifin Firdaus Ice House on 21/06/22.
//

import SwiftUI

struct ContentView: View {

	@StateObject private var dataScannerViewAdapter: DataScannerViewAdapter = DataScannerViewAdapter()

	var body: some View {

		GeometryReader { proxy in

			DataScannerView(dataScannerViewAdapter: dataScannerViewAdapter)
				.onTapGesture {
					if !dataScannerViewAdapter.recognizedText.isEmpty {
						dataScannerViewAdapter.resetRecognizedText()
					}
				}
				.overlay(alignment: .bottomLeading) {

					if !dataScannerViewAdapter.recognizedText.isEmpty {
						cardView
						.frame(width: proxy.size.width, height: 200)
						.background(.white)
					}
				}
		}
	}

	private var cardView: some View {
		ZStack {
			VStack {
				HStack {
					Text("Live text :")
						.foregroundColor(.black)

					Text(dataScannerViewAdapter.recognizedText)
						.foregroundColor(.black)
						.bold()
				}

				button
			}
			.padding(.leading, 16)
		}
	}

	private var button: some View {
		Button(
			action: { searchOnBrowser(forText: dataScannerViewAdapter.recognizedText) },
			label: { buttonText }
		)
		.background(.blue)
		.clipShape(RoundedRectangle(cornerRadius: 10))
	}

	private var buttonText: some View {
		Text("Find in Browser")
			.foregroundColor(.white)
			.bold()
			.padding()
	}

	private func searchOnBrowser(forText text: String) {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "www.google.com"
		components.path = "/search"
		components.queryItems = [
			URLQueryItem(name: "q", value: text),
			URLQueryItem(name: "ie", value: "UTF-8")
		]

		guard let url = components.url else {
			return
		}

		UIApplication.shared.open(url)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
