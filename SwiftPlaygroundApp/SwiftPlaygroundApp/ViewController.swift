//
//  ViewController.swift
//  SwiftPlaygroundApp
//
//  Created by 현수빈 on 2022/11/03.
//

import UIKit
import Toast
import SnapKit

class ViewController: UIViewController {

    private lazy var logoNameLabel: UILabel = {
        let label = UILabel()
        label.text = "SUNNY UI PLAYGROUND"
        label.font = .systemFont(ofSize: 20, weight: .medium)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setLayout()
        
        testToast()
       
    }
    
    
    func addSubViews(){
            [logoNameLabel] // z스택처럼 쌓임
                .forEach { self.view.addSubview($0) }
    }
    
    func setLayout() {
        self.logoNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
    }

    func testToast() {

        
        // crypto 주소 복사하기 toast
//        self.view.showToast(copyToastView, position: .bottom){ didTap in
//            if didTap {
//                print("completion from tap")
//            } else {
//                print("completion without tap")
//            }
//        }
        

        // indicator toast
        self.view.makeToastActivity(.center)
        
        // 핀번호 변경 완료 toast
        
        var style = ToastStyle()
        style.cornerRadius = 20
        style.imageSize = CGSize(width: 10, height: 10)
        self.view.makeToast("핀번호 변경이 완료되었습니다.", image: UIImage(systemName: "globe"),style: style)

        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
