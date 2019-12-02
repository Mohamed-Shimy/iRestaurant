//
//  ITextField.swift
//  AppCoda
//
//  Created by Mohamed Shemy on 10/20/19.
//  Copyright © 2019 MacOS Mojave. All rights reserved.
//
import UIKit


@IBDesignable open class ITextField: TextFieldEffects {
    
    @IBInspectable dynamic open var Icon: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable dynamic open var borderInactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
  
    @IBInspectable dynamic open var borderActiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable dynamic open var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.65 {
        didSet {
            updatePlaceholder()
        }
    }

    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 0.5, inactive: 0.5)
    private let placeholderInsets = CGPoint(x: 0, y: 6)
    private let textFieldInsets = CGPoint(x: 0, y: 12)
    private let inactiveBorderLayer = CALayer()
    private let activeBorderLayer = CALayer()    
    private var activePlaceholderPoint: CGPoint = CGPoint.zero
    private var iconWidth: Int = 24
    private var iconHeight: Int = 24

    
    // MARK: - TextFieldEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))

        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLabel)
    }
    
    override open func animateViewsForTextEntry() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: ({
                self.placeholderLabel.frame.origin = CGPoint(x: 10, y: self.placeholderLabel.frame.origin.y)
                self.placeholderLabel.alpha = 0
            }), completion: { _ in
                self.animationCompletionHandler?(.textEntry)
            })
        }
    
        layoutPlaceholderInTextRect()
        placeholderLabel.frame.origin = activePlaceholderPoint

		UIView.animate(withDuration: 0.4, animations: {
			self.placeholderLabel.alpha = 1.0
		})

        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
    }
    
    override open func animateViewsForTextDisplay() {
        if let text = text, text.isEmpty {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
            
            activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
            inactiveBorderLayer.frame = self.rectForBorder(self.borderThickness.inactive, isFilled: true)

        }
    }
    
    // MARK: - Private
    
    private func updateBorder()
    {
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: !isFirstResponder)
        inactiveBorderLayer.backgroundColor = borderInactiveColor?.cgColor
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: isFirstResponder)
        activeBorderLayer.backgroundColor = borderActiveColor?.cgColor
        
        //let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width - CGFloat(100), height: frame.height))
    }
    
    private func updatePlaceholder()
    {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func updateView()
    {
        if let image = Icon
        {
            self.rightViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: iconWidth, height: iconHeight))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            self.rightView = imageView
        } else {
            self.rightViewMode = .never
            self.rightView = nil
        }
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(descriptor: font.fontDescriptor, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {        
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2,
            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x, y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderInsets.y)

    }
    
    // MARK: - Overrides
  
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: textFieldInsets.x,
            y: textFieldInsets.y,
            width: bounds.size.width - CGFloat(iconWidth),
            height: bounds.size.height
        )
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
}
