//
//  ComposeView.swift
//  Nanameue
//
//  Created by Stanley Lim on 29/10/2022.
//

import UIKit

class ComposeView: UIView {
    
    // MARK: - Initializer and Lifecycle Methods -
    lazy var scrollView: UIScrollView = {
        let newScrollView = UIScrollView()
        newScrollView.translatesAutoresizingMaskIntoConstraints = false
        return newScrollView
    }()
    lazy var containerView: UIView = {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        return newView
    }()
    lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let newImageView = UIImageView()
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        newImageView.contentMode = .scaleAspectFit
        return newImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    convenience init(frame: CGRect, layout: UICollectionViewLayout) {
        self.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupSubviews() {
        addSubview(scrollView)
        backgroundColor = .systemBackground
        scrollView.addSubview(containerView)
        containerView.addSubview(textView)
        containerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            
        ])
        
    }

}
