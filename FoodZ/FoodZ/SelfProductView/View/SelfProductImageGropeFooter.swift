//
//  SelfProductImageGropeFooter.swift
//  FoodZ
//
//  Created by surexnx on 13.05.2024.
//

import Foundation
import UIKit

protocol SelfProductImageGropeFooterOutput: AnyObject {
    func proccesedTappedSection(indexPath: IndexPath)
    func didLoadFooter(input: SelfProductImageGropeFooterInput)
}

protocol SelfProductImageGropeFooterInput: AnyObject {
    func proccesedScrollItem(index: Int)
}

final class SelfProductImageGropeFooter: UICollectionReusableView {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "SelfProductImageGropeFooter"

    // MARK: Private properties

    private lazy var segmentControl = UISegmentedControl()
    private var section: Int?

    // MARK: Internal static properties

    weak var delegate: SelfProductImageGropeFooterOutput?

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSegmentControl()
        makeConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func makeConstraint() {
        addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupSegmentControl() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(changeSegment(_:)), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc private func changeSegment(_ sender: UISegmentedControl) {
        segmentControl.changeUnderlinePosition()
        segmentControl.isEnabled = false
        let index = sender.selectedSegmentIndex
        guard let section = section else { return }
        var outputIndexPath = IndexPath(row: index, section: section)
        delegate?.proccesedTappedSection(indexPath: outputIndexPath)
    }

    // MARK: Internal methods

    func configure(indexPath: IndexPath) {
        let count = indexPath.row
        for i in 0..<count {
            segmentControl.insertSegment(withTitle: "", at: i, animated: false)
        }
        segmentControl.selectedSegmentIndex = count
        self.section = indexPath.section
        delegate?.didLoadFooter(input: self)
    }
}

// MARK: - SelfProductImageGropeFooterInput

extension SelfProductImageGropeFooter: SelfProductImageGropeFooterInput {
    func proccesedScrollItem(index: Int) {
        segmentControl.selectedSegmentIndex = index
    }
}
