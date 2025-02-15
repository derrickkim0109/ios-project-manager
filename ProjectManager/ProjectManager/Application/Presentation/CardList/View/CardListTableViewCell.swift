//
//  CardListTableViewCell.swift
//  ProjectManager
//
//  Created by Derrick kim on 9/7/22.
//

import UIKit
import Then

final class CardListTableViewCell: UITableViewCell, ReuseIdentifying {
    private enum Const {
        static let stackViewSpacing = 5.0
        static let baseConstraint = 12.0
        static let layerCornerRadius = 30.0
        static let numberOfLines = 3
        static let seperatorLineWidth = 16.0
        static let minimumPressDuration = 1.0
        static let zero = 0.0
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3)
        $0.setContentHuggingPriority(.defaultHigh,
                                     for: .vertical)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textColor = .systemGray3
        $0.numberOfLines = Const.numberOfLines
    }
    
    private let deadlineDateLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .callout)
        $0.setContentHuggingPriority(.defaultHigh,
                                     for: .vertical)
    }
    
    private lazy var rootStackView = UIStackView(
        arrangedSubviews: [titleLabel, descriptionLabel, deadlineDateLabel]).then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = Const.stackViewSpacing
        }

    var viewModel: CardListItemViewModel?
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefault()
        setupLongGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        deadlineDateLabel.text = nil
    }

    override func draw(_ rect: CGRect) {
        let separator = UIBezierPath()

        separator.move(to: CGPoint(x: Const.zero,
                                   y: bounds.maxY))
        separator.addLine(to: CGPoint(x: bounds.maxX,
                                      y: bounds.maxY))

        UIColor.systemGray6.setStroke()
        separator.lineWidth = Const.seperatorLineWidth
        separator.stroke()
    }

    func bindUI() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        deadlineDateLabel.text = viewModel.date
        deadlineDateLabel.textColor = viewModel.isExpired ? .red : .black
    }
    
    private func setupDefault() {
        contentView.addSubview(rootStackView)
        backgroundColor = .white

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: Const.baseConstraint),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -Const.baseConstraint),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Const.baseConstraint),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -Const.baseConstraint)
        ])
    }
}

extension CardListTableViewCell {
    private func setupLongGesture() {
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = Const.minimumPressDuration
        longPressGesture.addTarget(self,
                                   action: #selector(didTapTableViewCellLongPress))
        addGestureRecognizer(longPressGesture)
    }

    @objc private func didTapTableViewCellLongPress(_ guesture: UILongPressGestureRecognizer) {
        if guesture.state == .began {
            viewModel?.connectWithActionSheetForMoving(sourceView: self)
        }
    }
}
