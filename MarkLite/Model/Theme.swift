//
//  Theme.swift
//  MarkLite
//
//  Created by zhubch on 2017/8/8.
//  Copyright © 2017年 zhubch. All rights reserved.
//

import UIKit
import RxSwift

enum Theme: String {
    case white
    case black
    case green
    case red
    case blue
    case purple
    case pink
}

enum ThemeColorType {
    case navBar
    case navBarTint
    case background
    case tableBackground
    case primary
    case secondary
}

extension Theme {
    var colors: [UIColor] {
        switch self {
        case .white:
            return [rgb("ffffff")!,rgb("333333")!,rgb("ffffff")!,rgb("f2f2f2")!,rgba("333333", 0.8)!,rgba("333333", 0.5)!]
        case .black:
            return [rgb("313231")!,rgb("cccccc")!,rgb("313231")!,rgb("333333")!,rgba("cccccc", 0.8)!,rgba("cccccc", 0.5)!]
        case .blue:
            return [rgb("0291D4")!,rgb("ffffff")!,rgb("ffffff")!,rgb("f2f2f2")!,rgba("0291D4", 0.8)!,rgba("0291D4", 0.5)!]
        case .purple:
            return [rgb("6c16c7")!,rgb("ffffff")!,rgb("ffffff")!,rgb("f2f2f2")!,rgba("6c16c7", 0.8)!,rgba("6c16c7", 0.5)!]
        case .red:
            return [rgb("D2373B")!,rgb("ffffff")!,rgb("ffffff")!,rgb("f2f2f2")!,rgba("D2373B", 0.8)!,rgba("D2373B", 0.5)!]
        case .green:
            return [rgb("01BD70")!,rgb("ffffff")!,rgb("ffffff")!,rgb("f2f2f2")!,rgba("01BD70", 0.8)!,rgba("01BD70", 0.5)!]
        case .pink:
            return [rgb("E52D7C")!,rgb("ffffff")!,rgb("ffffff")!,rgb("f2f2f2")!,rgba("E52D7C", 0.8)!,rgba("E52D7C", 0.5)!]
        }
    }
    
    var displayName: String {
        switch self {
        case .white:
            return "简洁白"
        case .black:
            return "高端黑"
        case .blue:
            return "清新蓝"
        case .red:
            return "中国红"
        case .purple:
            return "风骚紫"
        case .pink:
            return "脑残粉"
        case .green:
            return "原谅绿"
        }
    }
}

class ColorCenter {
    static let shared = ColorCenter()
    
    let navBar = Variable(UIColor.clear)
    let navBarTint = Variable(UIColor.clear)
    let primary = Variable(UIColor.clear)
    let secondary = Variable(UIColor.clear)
    let background = Variable(UIColor.clear)
    let tableBackground = Variable(UIColor.clear)
    
    var theme: Theme = .white {
        didSet {
            navBar.value = theme.colors[0]
            navBarTint.value = theme.colors[1]
            background.value = theme.colors[2]
            tableBackground.value = theme.colors[3]
            primary.value = theme.colors[4]
            secondary.value = theme.colors[5]
        }
    }
    
    func colorVariable(with type: ThemeColorType) -> Variable<UIColor> {
        switch type {
        case .navBar:
            return navBar
        case .navBarTint:
            return navBarTint
        case .primary:
            return primary
        case .secondary:
            return secondary
        case .background:
            return background
        case .tableBackground:
            return tableBackground
        }
    }
}

extension UINavigationBar {
    func setBarTintColor(_ color: ThemeColorType) {
        _ = ColorCenter.shared.colorVariable(with: color).asObservable().takeUntil(rx.deallocated).subscribe(onNext: { [unowned self](color) in
            self.barTintColor = color
            self.setBackgroundImage(UIImage(color: color, size: CGSize(width: 1000, height: 64)), for: .default)
        })
    }
    
    func setContentColor(_ color: ThemeColorType) {
        _ = ColorCenter.shared.colorVariable(with: color).asObservable().takeUntil(rx.deallocated).subscribe(onNext: { [unowned self](color) in
            self.tintColor = color
            let attr: [String: Any] = [
                NSFontAttributeName: UIFont.font(ofSize: 18),
                NSForegroundColorAttributeName: color
            ]
            self.titleTextAttributes = attr
        })
    }
}

extension UIView {
    func setBackgroundColor(_ color: ThemeColorType) {
        _ = ColorCenter.shared.colorVariable(with: color).asObservable().takeUntil(rx.deallocated).subscribe(onNext: { [unowned self] (color) in
            self.backgroundColor = color
        })
    }
    
    func setTintColor(_ color: ThemeColorType) {
        _ = ColorCenter.shared.colorVariable(with: color).asObservable().takeUntil(rx.deallocated).subscribe(onNext: { [unowned self](color) in
            self.tintColor = color
        })
    }
}

extension UILabel {
    
    func setTextColor(_ color: ThemeColorType) {
        _ = ColorCenter.shared.colorVariable(with: color).asObservable().takeUntil(rx.deallocated).subscribe(onNext: { [unowned self](color) in
            self.textColor = color
        })
    }
}

extension UIButton {
    
    func setTitleColor(_ color: ThemeColorType, forState: UIControlState = .normal) {
        _ = ColorCenter.shared.colorVariable(with: color).asObservable().takeUntil(rx.deallocated).subscribe(onNext: { [unowned self](color) in
            self.setTitleColor(color, for: forState)
        })
    }
}

extension UITableView {
    func setSeparatorColor(_ color: ThemeColorType) {
        _ = ColorCenter.shared.colorVariable(with: color).asObservable().takeUntil(rx.deallocated).subscribe(onNext: { [unowned self](color) in
            self.separatorColor = color * 0.1
        })
    }
}

extension UITextField {
    func setTextColor(_ color: ThemeColorType) {
        _ = ColorCenter.shared.colorVariable(with: color).asObservable().takeUntil(rx.deallocated).subscribe(onNext: { [unowned self](color) in
            self.textColor = color
        })
    }
}
