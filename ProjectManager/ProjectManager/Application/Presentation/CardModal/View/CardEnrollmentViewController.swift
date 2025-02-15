//
//  CardEnrollmentViewController.swift
//  ProjectManager
//
//  Created by Derrick kim on 9/7/22.
//

import UIKit

final class CardEnrollmentViewController: UIViewController {
    private enum Const {
        static let title = "TODO"
        static let cancel = "Cancel"
        static let done = "Done"
        static let stackViewSpacing = 10.0
        static let limitedTextAmount = 1000
        static let alertTitle = "글자수 제한"
        static let exceedValue = "글자수가 초과되었습니다"
    }
    
    private let cardModalView = CardModalView().then {
        $0.backgroundColor = .systemBackground
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var coordinator: CoordinatorProtocol?
    private let viewModel: CardViewModelProtocol
    
    init(viewModel: CardViewModelProtocol,
         coodinator: CoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coodinator
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        configureLayout()
        configureNavigationItem()
    }
    
    private func setupDefault() {
        view.addSubview(cardModalView)
        cardModalView.descriptionTextView.delegate = self
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            cardModalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cardModalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cardModalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cardModalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureNavigationItem() {
        title = Const.title
        cardModalView.leftBarButtonItem = UIBarButtonItem(title: Const.cancel,
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(didTapCancelButton))
        
        cardModalView.rightBarButtonItem = UIBarButtonItem(title: Const.done,
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapDoneButton))
        
        navigationItem.leftBarButtonItem = cardModalView.leftBarButtonItem
        navigationItem.rightBarButtonItem = cardModalView.rightBarButtonItem
        
        cardModalView.navigationBar.items = [navigationItem]
    }
    
    private func create() -> CardModel? {
        guard let title = cardModalView.titleTextField.text,
              let description = cardModalView.descriptionTextView.text else { return nil }
        let deadlineDate = cardModalView.datePicker.date
        let newData = CardModel(id: UUID().uuidString,
                                title: title,
                                description: description,
                                deadlineDate: deadlineDate,
                                cardType: .todo)
        return newData
    }
    
    @objc func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc func didTapDoneButton() {
        guard let newCard = create() else { return }
    
        viewModel.append(newCard)

        dismiss(animated: true)
    }
}

// MARK: - UITextViewDelegate

extension CardEnrollmentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        guard textView.text.count < Const.limitedTextAmount else {
            return false
        }
        
        return true
    }
}
