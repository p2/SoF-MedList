//
//  DetailViewController.swift
//  SoF-MedList
//
//  Created by Pascal Pfiffner on 6/20/14.
//  Copyright (c) 2014 SMART Platforms. All rights reserved.
//

import UIKit
import SMART


class DetailViewController: UIViewController, UISplitViewControllerDelegate {
	
	@IBOutlet var detailDescriptionLabel: UILabel?
	
	/// The prescription to show details about
	var resource: Resource? {
		didSet {
			configureView()
		}
	}
	
	func configureView() {
		guard let label = detailDescriptionLabel else {
			return
		}
		if let detail = resource {
			do {
				let data = try JSONSerialization.data(withJSONObject: detail.asJSON(), options: .prettyPrinted)
				let string = String(data: data, encoding: String.Encoding.utf8)
				label.text = string ?? "Unable to generate JSON"
			}
			catch let error {
				label.text = "\(error)"
			}
		}
		else {
			var style = UIFont.TextStyle.headline
			if #available(iOS 9, *) {
				style = .title1
			}
			let p = NSMutableParagraphStyle()
			p.alignment = .center
			p.paragraphSpacingBefore = 200.0
			let attr = NSAttributedString(string: "Select a FHIR Resource first", attributes: [
				NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: style),
				NSAttributedString.Key.paragraphStyle: p,
				])
			label.attributedText = attr
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureView()
	}
	
	
	// MARK: - Split view
	
	func splitViewController(_ splitController: UISplitViewController, willShow viewController: UIViewController, invalidating barButtonItem: UIBarButtonItem) {
		// Called when the view is shown again in the split view, invalidating the button and popover controller.
		self.navigationItem.setLeftBarButton(nil, animated: true)
	}
	
	func splitViewController(_ splitController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		// Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
		return true
	}
	
	func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
		// We want ourselves to be separated
		return self
	}
}

