//
//  ComposeViewController.swift
//  Nanameue
//
//  Created by Stanley Lim on 29/10/2022.
//

import UIKit
import PhotosUI

protocol ComposeViewControllerDelegate: AnyObject {
    func composeViewController(_ controller: ComposeViewController, didFinishAdding tweet: Tweet)
}

class ComposeViewController: UIViewController {
    
    weak var delegate: ComposeViewControllerDelegate?
    
    var rootView: ComposeView {
        return view as! ComposeView
    }
    
    override func loadView() {
        view = ComposeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(photoButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.textView.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @objc private func photoButtonPressed() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    @objc private func doneButtonPressed() {
        if !rootView.textView.text.isEmpty || rootView.imageView.image != nil {
            delegate?.composeViewController(self, didFinishAdding: Tweet(text: rootView.textView.text, image: rootView.imageView.image))
        }
        dismiss(animated: true)
    }
    
}

extension ComposeViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        guard !results.isEmpty else { return }
        for result in results {
            let provider = result.itemProvider
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    guard let strongSelf = self else { return }
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            strongSelf.rootView.imageView.image = image
                        }
                    }
                }
            }
        }
    }
}
