//
//  MyCell.swift
//  SwiftPlaygroundApp
//
//  Created by 현수빈 on 2022/11/04.
//

import UIKit
import SnapKit

final class MyCell: UICollectionViewCell {
  static let id = "MyCell"
  
  // MARK: UI
    
    private lazy var folderNameLabel: UILabel = {
        let label = UILabel()
        label.text = "현수빈의 NFT 보관함"
        label.font = .systemFont(ofSize: 13,weight: .bold)
        return label
    }()
  private let imageView1: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFill
    view.backgroundColor = .systemRed
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 10
    return view
  }()
    private let imageView2: UIImageView = {
      let view = UIImageView()
        view.backgroundColor = .systemYellow
      view.contentMode = .scaleAspectFill
      view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
      return view
    }()
    private let imageView3: UIImageView = {
      let view = UIImageView()
        view.backgroundColor = .systemBlue
      view.contentMode = .scaleAspectFill
      view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
      return view
    }()
  
  // MARK: Initializer
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
      [self.folderNameLabel, self.imageView1, self.imageView2, self.imageView3].forEach{ self.addSubview($0)}
      
      self.folderNameLabel.snp.makeConstraints {
          $0.top.equalToSuperview().inset(8)
          $0.leading.equalToSuperview().inset(8)
          $0.trailing.equalToSuperview().inset(8)
      }
      self.imageView1.snp.makeConstraints {
          $0.top.equalTo(self.folderNameLabel.snp.bottom).offset(8)
          $0.bottom.equalToSuperview().inset(8)
          $0.leading.equalToSuperview().inset(8)
          $0.height.equalTo(self.imageView1.snp.width)
      }
      self.imageView2.snp.makeConstraints {
          $0.top.equalTo(self.folderNameLabel.snp.bottom).offset(8)
          $0.bottom.equalToSuperview().inset(8)
          $0.leading.equalTo(self.imageView1.snp.trailing).inset(16)
          $0.height.equalTo(self.imageView2.snp.width)
      }
      self.imageView3.snp.makeConstraints {
          $0.top.equalTo(self.folderNameLabel.snp.bottom).offset(8)
          $0.bottom.equalToSuperview().inset(8)
          $0.leading.equalTo(self.imageView2.snp.trailing).inset(16)
          $0.trailing.equalToSuperview().inset(8)
          $0.height.equalTo(self.imageView3.snp.width)
      }
   
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()

    self.prepare(image: nil)
  }
  
  func prepare(image: UIImage?) {
//    self.imageView1.image = image
//    self.imageView2.image = UIImage(systemName: "checkmark")
//      self.imageView2.backgroundColor = .systemBlue
//    self.imageView3.image = image
    
  }
}
