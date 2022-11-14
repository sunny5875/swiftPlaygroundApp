//
//  MyTopTipView.swift
//  SwiftPlaygroundApp
//
//  Created by 현수빈 on 2022/11/14.
//

import UIKit
import SnapKit

class MyTopTipView: UIView {
  init(
    viewColor: UIColor,
    tipStartX: CGFloat,
    tipWidth: CGFloat,
    tipHeight: CGFloat
  ) {
    super.init(frame: .zero)
    self.backgroundColor = viewColor
    
    let path = CGMutablePath()

    let tipWidthCenter = tipWidth / 2.0
    let endXWidth = tipStartX + tipWidth
    
    path.move(to: CGPoint(x: tipStartX, y: 0))
    path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: -tipHeight))
    path.addLine(to: CGPoint(x: endXWidth, y: 0))
    path.addLine(to: CGPoint(x: 0, y: 0))

    let shape = CAShapeLayer()
    shape.path = path
      shape.fillColor = viewColor.cgColor
//      shape.strokeColor = UIColor.lightGray.cgColor

    self.layer.insertSublayer(shape, at: 0)
    self.layer.masksToBounds = false
    self.layer.cornerRadius = 16
    
    self.addLabel()
  }
  
  private func addLabel() {
    let titleLabel = UILabel()
    titleLabel.textColor = .black
    titleLabel.text = "수신 및 발신 주소를 반드시 확인하세요!\n잘못 요청된 거래에 대해서 유니와플은 책임지지 않습니다"
    titleLabel.numberOfLines = 0
    titleLabel.lineBreakMode = .byCharWrapping // 글자 단위로 줄바꿈 (디폴트는 어절 단위)
    
    self.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(10)
      $0.left.right.equalToSuperview().inset(16)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
