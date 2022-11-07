//
//  ViewController.swift
//  SwiftPlaygroundApp
//
//  Created by 현수빈 on 2022/11/03.
//

import UIKit
import Toast
import SnapKit
import BottomSheet

class ViewController: UIViewController {

    private lazy var testScrollMoneyLabel: CountScrollLabel = {
        let label = CountScrollLabel()
        label.text = "써니의 플레이그라운드"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private lazy var informationLabel1: UILabel = {
        let label = UILabel()
        label.text = "유니와플 가입을\n축하드립니다!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private lazy var informationLabel2: UILabel = {
        let label = UILabel()
        label.text = "강력한 보안을 위해\n핀번호를 설정합니다."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private lazy var copyToastView: UIView = {
        let toastView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 64.0))
        let informationLabel = UILabel()
        let symbolImageView = UIImageView()
        let addressLabel = UILabel()
        let button = UIButton()
        
        informationLabel.text = "방금 복사됨"
        informationLabel.font = .systemFont(ofSize: 12)
        informationLabel.textColor = .white
        
        symbolImageView.image = UIImage(systemName: "globe")
        symbolImageView.backgroundColor = .white
        symbolImageView.layer.cornerRadius = 5

        addressLabel.text = "0xd5a339ead953..."
        addressLabel.textColor = .white
        addressLabel.font = .systemFont(ofSize: 15)
        
        button.setTitle("보내기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        //addSubView
        [informationLabel, symbolImageView, addressLabel, button ] // z스택처럼 쌓임
            .forEach { toastView.addSubview($0) }

        //constraint
        informationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(16)
        }
        symbolImageView.snp.makeConstraints {
            $0.top.equalTo(informationLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.width.height.equalTo(10)
        }
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(informationLabel.snp.bottom).offset(4)
            $0.leading.equalTo(symbolImageView.snp.trailing).offset(4)
            $0.bottom.equalToSuperview().inset(16)
            $0.width.equalTo(120)
        }
        button.snp.makeConstraints {
            $0.leading.equalTo(addressLabel.snp.trailing).inset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(64)

        }
        
        toastView.backgroundColor = .darkGray
        toastView.layer.cornerRadius = 30
        
        return toastView
        
    }()
    
    private lazy var colorPalleteButtonList: [UIView] = {
        var list: [UIView] = []
        let colorList: [UIColor] = [.systemRed, .systemOrange, .systemGreen, .systemBlue, .systemPurple, .black]
        
        for i in 0..<colorList.count {
            
//            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//            button.backgroundColor = colorList[i]
//            button.tintColor = .white
//            button.layer.cornerRadius = button.frame.size.width / 2
            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            image.image = UIImage()
            image.contentMode = .center
            image.clipsToBounds = true
            image.backgroundColor = colorList[i]
            image.tintColor = .white
            image.layer.cornerRadius = image.frame.size.width / 2
           
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
            
            view.addSubview(image)
        
            image.snp.makeConstraints {
                $0.top.bottom.trailing.leading.equalToSuperview().inset(4)

            }
            view.layer.cornerRadius = view.frame.size.width / 2
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 1
            view.backgroundColor = .white
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(colorPalleteButtonTapped(_:)))

            view.addGestureRecognizer(tapGestureRecognizer)
            list.append(view)
        }
        
        return list
    }()
    
    private lazy var colorPalleteStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: self.colorPalleteButtonList)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    @objc func colorPalleteButtonTapped(_ sender: UITapGestureRecognizer) {
       
        print("누름")
        let senderView = sender.view
        guard let senderImageView = sender.view?.subviews[0] as? UIImageView else {return}
        senderImageView.image = UIImage(systemName: "checkmark")
        
        senderView?.layer.borderColor = UIColor.systemGray4.cgColor
        
        
        for view in colorPalleteButtonList {
            if view != senderView {
                guard let imageView = view.subviews[0] as? UIImageView else {return}
                view.layer.borderColor = UIColor.white.cgColor
                imageView.image = UIImage()
            }
        }
    }
    

    
    private var dataSource = getSampleImages()
    
    private let flowLayout: UICollectionViewFlowLayout = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.minimumInteritemSpacing = 16.0
//      layout.itemSize = CGSize(width: 300, height: 100)
      return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.layer.cornerRadius = 10
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
       
        button.setTitleColor(.black, for: .normal)
        button.setTitle("현수빈의 제목 편집하기", for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.addTarget(self, action: #selector(navigationTitleButtonTapped), for: .touchUpInside)
        
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceRightToLeft
        navigationItem.titleView = button
        
        addSubViews()
        setLayout()
        
//        testToast()
       testScrollLabel()
        testTextAnimation()
    }
    
    
    func addSubViews(){
            [testScrollMoneyLabel, colorPalleteStackView, informationLabel1, informationLabel2, collectionView] // z스택처럼 쌓임
                .forEach { self.view.addSubview($0) }
    }
    
    func setLayout() {
        self.testScrollMoneyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
     
        for item in colorPalleteButtonList {
            item.snp.makeConstraints {
                $0.width.height.equalTo(50)
            }
        }
        
        
        self.colorPalleteStackView.snp.makeConstraints {
            $0.top.equalTo(self.testScrollMoneyLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        self.informationLabel1.snp.makeConstraints {
            $0.top.equalTo(self.colorPalleteStackView.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        self.informationLabel2.snp.makeConstraints {
            $0.top.equalTo(self.colorPalleteStackView.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(self.informationLabel2.snp.bottom).offset(64)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(180)
            $0.trailing.leading.equalToSuperview()
            
        }
    }
    
    @objc func navigationTitleButtonTapped() {
        print("네비게이션 타이틀을 누름")
//        presentBottomSheetInsideNavigationController(
//            viewController: BottomSheetViewController(),
//            configuration: .default
//        )
        
        showBottomSheet()
        
 
    }
    
    private func showBottomSheet() {
        let bottomSheetVC = CustomBottomSheetViewController()
       // 1
       bottomSheetVC.modalPresentationStyle = .overFullScreen
       // 2
       self.present(bottomSheetVC, animated: false, completion: nil)
    }


    func testToast() {
        // crypto 주소 복사하기 toast
        self.view.showToast(copyToastView, position: .bottom){ didTap in
            if didTap {
                print("completion from tap")
            } else {
                print("completion without tap")
            }
        }
        

        // indicator toast
        self.view.makeToastActivity(.center)
        
        // 핀번호 변경 완료 toast
        var style = ToastStyle()
        style.cornerRadius = 20
        style.imageSize = CGSize(width: 10, height: 10)
        self.view.makeToast("핀번호 변경이 완료되었습니다.", image: UIImage(systemName: "globe"),style: style)

        
    }
    
    func testScrollLabel() {
        testScrollMoneyLabel.configure(with: 103934958)
        testScrollMoneyLabel.animate()
    }
    
    func testTextAnimation() {
        self.informationLabel1.isHidden = false
        makeCATransitionLabel(informationLabel1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
          // 1초 후 실행될 부분
            self.informationLabel1.isHidden = true
            self.informationLabel2.isHidden = false
            self.makeCATransitionLabel(self.informationLabel2)
        }
        
    }
    
    func makeCATransitionLabel(_ label: UILabel) {
        let transition = CATransition()
        transition.duration = 2
        transition.timingFunction = .init(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromTop
        label.layer.add(transition, forKey: CATransitionType.push.rawValue)
    }

}

extension ViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.dataSource.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCell.id, for: indexPath) as! MyCell
      
    cell.prepare(image: self.dataSource[indexPath.item])
      cell.backgroundColor = .systemGray6
    return cell
  }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
          {
          let width  = (collectionView.frame.width-16)
              return CGSize(width: width, height: 180)
          }
  
}

func getSampleImages() -> [UIImage?] {
  (1...10).map { _ in return UIImage(named: "nft_image") }
}
