//
//  DataScannerView.swift
//  DemoLiveTextScanSwiftUI
//
//  Created by Arifin Firdaus Ice House on 21/06/22.
//

import SwiftUI
import VisionKit

struct DataScannerView: UIViewControllerRepresentable {

	@ObservedObject var dataScannerViewAdapter: DataScannerViewAdapter

	func makeUIViewController(context: Context) -> DataScannerViewController {

		let viewController = DataScannerViewController(
			recognizedDataTypes: [ .barcode(symbologies: [.upce,.ean8,.ean13]), .text() ],
			qualityLevel: .fast,
			isHighlightingEnabled: true
		)
		viewController.delegate = dataScannerViewAdapter

		try? viewController.startScanning()

		return viewController
	}

	func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}
}

