//
//  DataScannerViewAdapter.swift
//  DemoLiveTextScanSwiftUI
//
//  Created by Arifin Firdaus Ice House on 21/06/22.
//

import SwiftUI
import VisionKit

final class DataScannerViewAdapter: ObservableObject, DataScannerViewControllerDelegate {

	@Published private(set) var error: DataScannerViewController.ScanningUnavailable?
	@Published private(set) var recognizedText: String = ""

	// MARK: - DataScannerViewControllerDelegate

	func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
		switch item {
		case let .barcode(barcodeText): recognizedText = barcodeText.payloadStringValue ?? ""
		case let .text(text): recognizedText = text.transcript
		@unknown default: break
		}
	}

	func dataScanner(
		_ dataScanner: DataScannerViewController,
		becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable
	) {
		self.error = error
	}
}

extension DataScannerViewAdapter {
	func resetRecognizedText() {
		recognizedText = ""
	}
}
