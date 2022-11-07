//
//  CustomBottomSheetViewController.swift
//  SwiftPlaygroundApp
//
//  Created by 현수빈 on 2022/11/07.
//

import UIKit
import SnapKit




class CustomBottomSheetViewController: UIViewController {
    
    enum BottomSheetViewState {
          case expanded
          case normal
      }
    
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    var defaultHeight: CGFloat = 300
    
    // Bottom Sheet과 safe Area Top 사이의 최소값을 지정하기 위한 프로퍼티
    var bottomSheetPanMinTopConstant: CGFloat = 20.0
    
    // 그래그 전 Bottom Sheet의 top Constraint value를 저장하기 위한 프로퍼티
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant
    
    //ui적으로 올라갈 수 있음을 알리는 view
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let bottomSheetView: UIView = {
       let view = UIView()
       view.backgroundColor = .white
       view.layer.cornerRadius = 10
       view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       view.clipsToBounds = true
       return view
   }()

      
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    private func setupUI() {
        [backgroundView, bottomSheetView, dragIndicatorView]
            .forEach {self.view.addSubview($0)}
        
        //background view 선택 시 내려가는 gesture
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:)))
        backgroundView.addGestureRecognizer(backgroundTapGesture)
        backgroundView.isUserInteractionEnabled = true
        
        // Pan Gesture Recognizer를 view controller의 view에 추가하기 위한 코드
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))

        // 기본적으로 iOS는 터치가 드래그하였을 때 딜레이가 발생하기 때문에 false로 설정
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)

        setupLayout()
    }
    
    private func setupLayout() {
        backgroundView.alpha = 0.0
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        
        
        self.backgroundView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view)
        }

        self.bottomSheetView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
        NSLayoutConstraint.activate([bottomSheetViewTopConstraint])
        
        
        self.dragIndicatorView.snp.makeConstraints {
            $0.top.equalTo(self.bottomSheetView.snp.top).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(dragIndicatorView.layer.cornerRadius * 2)
        }
    }
    
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.7
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    @objc private func backgroundViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: view)
        
        let velocity = panGestureRecognizer.velocity(in: view)
        
        switch panGestureRecognizer.state {
        case .began:
            bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
        case .changed:
            if bottomSheetPanStartingTopConstant + translation.y > bottomSheetPanMinTopConstant {
                bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
            }
            backgroundView.alpha = dimAlphaWithBottomSheetTopConstraint(value: bottomSheetViewTopConstraint.constant)
                       
        case .ended:
            if velocity.y > 1500 { //빠르게 아래로 스와이프시 bottom sheet가 dismiss
                hideBottomSheetAndGoBack()
                return
            }
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding = view.safeAreaInsets.bottom
            let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight
            
            let nearestValue = nearest(to: bottomSheetViewTopConstraint.constant, inValues: [bottomSheetPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])
            
            if nearestValue == bottomSheetPanMinTopConstant {
                showBottomSheet(atState: .expanded)
            } else if nearestValue == defaultPadding { // Bottom Sheet을 .normal 상태로 보여주기
                showBottomSheet(atState: .normal)
            } else { // Bottom Sheet을 숨기고 현재 View Controller를 dismiss시키기
                hideBottomSheetAndGoBack()
            }
        default:
            break
        }
    }
    func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }
    
    private func showBottomSheet(atState: BottomSheetViewState = .normal) {
        if atState == .normal {
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        } else {
            bottomSheetViewTopConstraint.constant = bottomSheetPanMinTopConstant
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = self.dimAlphaWithBottomSheetTopConstraint(value: self.bottomSheetViewTopConstraint.constant)
                            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    //bottomSheet가 내려갈 수록 backgroundView의 알파값이 변하는 UI를 완성하기 위한 function
    private func dimAlphaWithBottomSheetTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha: CGFloat = 0.7
        
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
            // bottom sheet의 top constraint 값이 fullDimPosition과 같으면
            // dimmer view의 alpha 값이 0.7
        let fullDimPosition = (safeAreaHeight + bottomPadding - defaultHeight) / 2

            // bottom sheet의 top constraint 값이 noDimPosition과 같으면
            // dimmer view의 alpha 값이 0.0
        let noDimPosition = safeAreaHeight + bottomPadding

            // Bottom Sheet의 top constraint 값이 fullDimPosition보다 작으면
            // 배경색이 가장 진해진 상태로 지정
        if value < fullDimPosition {
            return fullDimAlpha
        }
        
            // Bottom Sheet의 top constraint 값이 noDimPosition보다 크면
            // 배경색이 투명한 상태로 지정
        if value > noDimPosition {
            return 0.0
        }
        
            // 그 외의 경우 top constraint 값에 따라 0.0과 0.7 사이의 alpha 값이 Return되도록 합니다
        return fullDimAlpha * (1 - ((value - fullDimPosition) / (noDimPosition - fullDimPosition)))
    }

}
