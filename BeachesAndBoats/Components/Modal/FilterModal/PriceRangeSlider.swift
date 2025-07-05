//
//  PriceSlider.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/07/2025.
//


import UIKit

public class PriceRangeSlider: UIView {

    private let track = UIView()
    private let minThumb = UIView()
    private let maxThumb = UIView()
//    private let minLabel = UILabel()
//    private let maxLabel = UILabel()

    var minValue: CGFloat = 100
    var maxValue: CGFloat = 200000
    var selectedMin: CGFloat = 1000
    var selectedMax: CGFloat = 100000

    private var thumbWidth: CGFloat = 20

    // Callbacks
    var onValueChanged: ((CGFloat, CGFloat) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutThumbs()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        layoutThumbs()
    }

    private func setupViews() {
        // Track
        track.backgroundColor = .beachBlue
        track.layer.cornerRadius = 2
        addSubview(track)

        // Thumbs
        [minThumb, maxThumb].forEach {
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.cornerRadius = thumbWidth / 2
            $0.isUserInteractionEnabled = true
            addSubview($0)
        }

        // Labels
//        [minLabel, maxLabel].forEach {
//            $0.font = .systemFont(ofSize: 12)
//            $0.textColor = .black
//            addSubview($0)
//        }

        // Gestures
        let minPan = UIPanGestureRecognizer(target: self, action: #selector(handleMinPan(_:)))
        let maxPan = UIPanGestureRecognizer(target: self, action: #selector(handleMaxPan(_:)))
        minThumb.addGestureRecognizer(minPan)
        maxThumb.addGestureRecognizer(maxPan)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        track.frame = CGRect(x: thumbWidth / 2, y: bounds.height / 2 - 2, width: bounds.width - thumbWidth, height: 4)
        layoutThumbs()
    }

    private func layoutThumbs() {
        let range = maxValue - minValue
        let width = track.bounds.width

        let minX = track.frame.origin.x + ((selectedMin - minValue) / range) * width
        let maxX = track.frame.origin.x + ((selectedMax - minValue) / range) * width

        minThumb.frame = CGRect(x: minX - thumbWidth / 2, y: track.center.y - thumbWidth / 2, width: thumbWidth, height: thumbWidth)
        maxThumb.frame = CGRect(x: maxX - thumbWidth / 2, y: track.center.y - thumbWidth / 2, width: thumbWidth, height: thumbWidth)

//        minLabel.text = "₦\(Int(selectedMin))"
//        maxLabel.text = "₦\(Int(selectedMax))"
//        minLabel.sizeToFit()
//        maxLabel.sizeToFit()
//        minLabel.center = CGPoint(x: minThumb.center.x, y: minThumb.frame.minY - 10)
//        maxLabel.center = CGPoint(x: maxThumb.center.x, y: maxThumb.frame.minY - 10)

        // Fire callback
        onValueChanged?(selectedMin, selectedMax)
    }

    @objc private func handleMinPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        gesture.setTranslation(.zero, in: self)

        var newCenterX = minThumb.center.x + translation.x
        let leftLimit = track.frame.minX
        let rightLimit = maxThumb.center.x - thumbWidth

        newCenterX = max(leftLimit, min(newCenterX, rightLimit))
        minThumb.center.x = newCenterX

        selectedMin = valueForPosition(newCenterX)
        layoutThumbs()
    }

    @objc private func handleMaxPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        gesture.setTranslation(.zero, in: self)

        var newCenterX = maxThumb.center.x + translation.x
        let leftLimit = minThumb.center.x + thumbWidth
        let rightLimit = track.frame.maxX

        newCenterX = max(leftLimit, min(newCenterX, rightLimit))
        maxThumb.center.x = newCenterX

        selectedMax = valueForPosition(newCenterX)
        layoutThumbs()
    }

    private func valueForPosition(_ x: CGFloat) -> CGFloat {
        let width = track.frame.width
        let position = x - track.frame.minX
        let percent = position / width
        return round((minValue + percent * (maxValue - minValue)) / 100) * 100 // round to nearest 100
    }
}
