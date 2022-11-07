//
//  BottomSheetViewController.swift
//  SwiftPlaygroundApp
//
//  Created by 현수빈 on 2022/11/07.
//

import UIKit
import BottomSheet
import SnapKit

class BottomSheetViewController: UIViewController, ScrollableBottomSheetPresentedController {
    
    var scrollView: UIScrollView?
    
    
    private lazy var bottomSheetLabel: CountScrollLabel = {
        let label = CountScrollLabel()
        label.text = "써니의 BottomSheet"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }
    
    private func setLayout() {
        [self.bottomSheetLabel]
            .forEach {self.view.addSubview($0)}
        
        self.bottomSheetLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
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
