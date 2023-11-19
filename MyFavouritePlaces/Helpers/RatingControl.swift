//
//  RatingControl.swift
//  MyFavouritePlaces
//
//  Created by Шахова Анастасия on 18.11.2023.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectuinState()
        }
    }
    
    @IBInspectable var startSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setUpButtons()
        }
    }
    
    @IBInspectable var startCount: Int = 5 {
        didSet {
            setUpButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
    }
    
    @objc func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    private func setUpButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let filledStart = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStart = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStart = UIImage(named: "highlightedStar", in: bundle,  compatibleWith: self.traitCollection)
        
        
        
        for _ in 0..<startCount {
            let button = UIButton()
        
            button.setImage(emptyStart, for: .normal)
            button.setImage(filledStart, for: .selected)
            button.setImage(highlightedStart, for: .highlighted)
            button.setImage(highlightedStart, for: [.highlighted, .selected])
            
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: startSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: startSize.width).isActive = true
            
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        updateButtonSelectuinState()
    }
    
    private func updateButtonSelectuinState() {
        
        for(index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
