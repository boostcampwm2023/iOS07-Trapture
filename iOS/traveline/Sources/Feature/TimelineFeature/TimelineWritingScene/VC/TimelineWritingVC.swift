//
//  TimelineWritingVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/22.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import PhotosUI
import UIKit

final class TimelineWritingVC: UIViewController {
    
    private enum Metric {
        static let topInset: CGFloat = 24
        static let margin: CGFloat = 16
        static let spacing: CGFloat = 20
        static let belowLine: CGFloat = 4
    }
    
    private enum KeyboardState {
        static let willShow = "UIKeyboardWillShowNotification"
        static let willHide = "UIKeyboardWillHideNotification"
    }
    
    private enum Constants {
        static let titlePlaceholder: String = "제목 *"
        static let contentPlaceholder: String = "내용을 입력해주세요. *\n\n부적절하거나 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있습니다."
        static let complete: String = "완료"
        static let selectTime: String = "시간선택"
        static let selectLocation: String = "장소 선택"
        static let alertContentVCKey = "contentViewController"
        static let metaDataKey = "{Exif}"
        static let dateKey = "DateTimeOriginal"
        static let didFinishWritingWithSuccess: String = "타임라인 작성을 완료했어요 !"
        static let didFinishWritingWithFailure: String = "타임라인 작성에 실패했어요."
    }
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = .init()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Metric.spacing
        
        return view
    }()
    
    private lazy var tlNavigationBar: TLNavigationBar = .init(vc: self)
        .addCompleteButton()
    
    private let timePickerVC = TimePickerVC()
    private let titleTextField: TitleTextField = .init()
    private let dateLabel: TLLabel = .init(font: TLFont.body2, color: TLColor.gray)
    private let selectTime: TLImageLabel = .init(image: TLImage.Travel.time, text: "현재시각")
    private let selectLocation: SelectLocationButton = .init()
    private let selectImageButton: SelectImageButton = .init()
    private var locationSearchVC: LocationSearchVC = .init()
    
    private let textView: UITextView = {
        let view = UITextView()
        view.text = Constants.contentPlaceholder
        view.textColor = TLColor.disabledGray
        view.font = TLFont.body1.font
        view.isScrollEnabled = false
        view.backgroundColor = TLColor.black
        
        return view
    }()
    
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var viewModel: TimelineWritingViewModel
    
    weak var delegate: ToastDelegate?
    
    // MARK: - Initialize
    
    init(viewModel: TimelineWritingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupAttributes()
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.sendAction(.viewDidLoad)
    }
    
    // MARK: - Functions
    
    @objc private func selectImageButtonTapped() {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
    @objc private func selectLocationButtonTapped() {
        locationSearchVC.delegate = self
        locationSearchVC.viewDidLoad()
        
        present(locationSearchVC, animated: true)
    }
    
    @objc private func selectTimeButtonTapped() {
        let alert = TLAlertController(
            title: Constants.selectTime,
            message: nil,
            preferredStyle: .alert
        )
        
        let complete = UIAlertAction(
            title: Constants.complete,
            style: .default
        ) { [weak self] _ in
            guard let self else { return }
            self.updateTime()
        }
        
        alert.addAction(complete)
        alert.setValue(timePickerVC, forKey: Constants.alertContentVCKey)
        
        present(alert, animated: true)
    }
    
    private func updateTime() {
        selectTime.setText(to: timePickerVC.time)
        viewModel.sendAction(.timeDidChange(timePickerVC.time))
        print(timePickerVC.time)
    }
    
    @objc private func scrollViewTouched() {
        textView.becomeFirstResponder()
    }
    
    @objc private func keyboardNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        switch notification.name.rawValue {
        case KeyboardState.willShow:
            actionKeyboardWillShow(keyboardFrame)
        case KeyboardState.willHide:
            actionKeyboardWillHide()
        default: break
        }
    }
    
    @objc private func imageButtonCancelTapped() {
        changeImage(to: nil)
    }
    
    @objc private func locationButtonCancelTapped() {
        selectLocation.setText(to: Constants.selectLocation)
        viewModel.sendAction(.placeDidChange(.emtpy))
    }
    
    private func changeImage(to image: UIImage?) {
        selectImageButton.setImage(image)
        viewModel.sendAction(.imageDidChange)
    }
    
    private func actionKeyboardWillShow(_ keyboardFrame: CGRect) {
        self.scrollView.contentInset.bottom = keyboardFrame.size.height
        scrollView.scrollRectToVisible(textView.frame, animated: true)
    }
    
    private func actionKeyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}

// MARK: - Setup Functions

private extension TimelineWritingVC {
    
    func setupAttributes() {
        view.backgroundColor = TLColor.black
        
        titleTextField.placeholder = Constants.titlePlaceholder
        textView.delegate = self
        
        tlNavigationBar.delegate = self
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageButtonTapped))
        let timeTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectTimeButtonTapped))
        let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectLocationButtonTapped))
        
        selectImageButton.cancelButton.addTarget(
            self,
            action: #selector(imageButtonCancelTapped),
            for: .touchUpInside
        )
        selectLocation.cancelButton.addTarget(
            self,
            action: #selector(locationButtonCancelTapped),
            for: .touchUpInside
        )
        
        selectImageButton.addGestureRecognizer(imageTapGesture)
        selectTime.addGestureRecognizer(timeTapGesture)
        selectLocation.addGestureRecognizer(locationTapGesture)
        selectImageButton.isUserInteractionEnabled = true
        selectTime.isUserInteractionEnabled = true
        selectLocation.isUserInteractionEnabled = true
        updateTime()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTouched))
        tapGesture.delegate = self
        scrollView.addGestureRecognizer(tapGesture)
        [
            UIResponder.keyboardWillHideNotification,
            UIResponder.keyboardWillShowNotification
        ].forEach {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardNotification),
                name: $0,
                object: nil
            )
        }
    }
    
    func setupLayout() {
        
        view.addSubviews(tlNavigationBar, scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews(
            titleTextField,
            dateLabel,
            selectTime,
            selectLocation,
            selectImageButton,
            textView
        )
        
        tlNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.arrangedSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: Metric.margin).isActive = true
            $0.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -Metric.margin).isActive = true
        }
        
        NSLayoutConstraint.activate([
            tlNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tlNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tlNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tlNavigationBar.heightAnchor.constraint(equalToConstant: BaseMetric.tlheight),

            scrollView.topAnchor.constraint(equalTo: tlNavigationBar.bottomAnchor, constant: Metric.topInset),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textView.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: Metric.spacing),
            textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func bind() {
        titleTextField
            .textPublisher
            .withUnretained(self)
            .sink { owner, text in
                owner.viewModel.sendAction(.titleDidChange(text))
            }
            .store(in: &cancellables)
        
        locationSearchVC.didScrollToBottom
            .throttle(for: 1.0, scheduler: RunLoop.main, latest: true)
            .withUnretained(self)
            .sink { owner, _ in
                owner.viewModel.sendAction(.placeDidScrollToBottom)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.text)
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .sink { owner, text in
                owner.textView.text = text
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.isCompletable)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, isCompletable in
                owner.tlNavigationBar.isRightButtonEnabled(isCompletable)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.timelineDetailRequest)
            .dropFirst()
            .withUnretained(self)
            .sink { owner, detail in
                owner.tlNavigationBar.setupTitle(to: "Day \(detail.day)")
                owner.titleTextField.text = detail.title
                owner.dateLabel.setText(to: detail.date)
                owner.selectTime.setText(to: detail.time)
                if !detail.content.isEmpty {
                    owner.textView.textColor = TLColor.white
                    owner.textView.text = detail.content
                }
                if let place = detail.place, !place.title.isEmpty {
                    owner.selectLocation.setText(to: place.title)
                }
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.imageURLString)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, imageURLString in
                owner.selectImageButton.setImage(urlString: imageURLString)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.timelinePlaceList)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, list in
                owner.locationSearchVC.setData(
                    keyword: owner.viewModel.currentState.keyword,
                    places: list
                )
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.timelineDetailRequest.time)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, time in
                owner.selectTime.setText(to: time)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.isEditCompleted)
            .removeDuplicates()
            .dropFirst()
            .withUnretained(self)
            .sink { owner, isSuccess in
                owner.navigationController?.popViewController(animated: true)
                owner.delegate?.viewControllerDidFinishAction(
                    isSuccess: isSuccess,
                    message: isSuccess ? Constants.didFinishWritingWithSuccess : Constants.didFinishWritingWithFailure
                )
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - UITextViewDelegate

extension TimelineWritingVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == TLColor.disabledGray {
            textView.text = nil
            textView.textColor = TLColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.contentPlaceholder
            textView.textColor = TLColor.disabledGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        viewModel.sendAction(.contentDidChange(text))
    }
    
}

// MARK: - PHPPickerViewControllerDelegate

extension TimelineWritingVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let imageResult = results.first else { return }
        
        if imageResult.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
          imageResult.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] data, _ in
              
            guard let data = data,
                  let cgImageSource = CGImageSourceCreateWithData(data as CFData, nil),
                  let metadata = CGImageSourceCopyPropertiesAtIndex(cgImageSource, 0, nil) as? [String: Any],
                  let exif = metadata[Constants.metaDataKey] as? [String: Any],
                  let date = exif[Constants.dateKey] as? String
              else { return }
              
              self?.viewModel.sendAction(.metaDataTime(date))
          }
        }
        
        let itemProvider = imageResult.itemProvider
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let selectedImage = image as? UIImage else { return }
                self.changeImage(to: selectedImage)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - extension LocationSearchDelegate

extension TimelineWritingVC: LocationSearchDelegate {
    func editingChagnedLocation(text: String) {
        viewModel.sendAction(.searchPlace(text))
    }
    
    func selectedLocation(result: TimelinePlace) {
        selectLocation.setText(to: result.title)
        viewModel.sendAction(.placeDidChange(result))
    }
}

// MARK: - TLNavigationBarDelegate

extension TimelineWritingVC: TLNavigationBarDelegate {
    func rightButtonDidTapped() {
        if let selectedImage = selectImageButton.imageView.image {
            let image = viewModel.currentState.isOriginImage ? selectedImage : selectedImage.downSampling()
            let imageData = image?.jpegData(compressionQuality: 1)
            viewModel.sendAction(.tapCompleteButton(imageData))
        } else {
            viewModel.sendAction(.tapCompleteButton(nil))
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension TimelineWritingVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false }
        if view == scrollView {
            return true
        }
        return false
    }
}
