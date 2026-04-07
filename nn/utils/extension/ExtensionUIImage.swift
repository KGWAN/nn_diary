//
//  ExtensionUIImage.swift
//  nn
//
//  Created by JUNGGWAN KIM on 8/13/25.
//

import UIKit

extension UIImage {
    func rotated(by degrees: CGFloat) -> UIImage? {
        let radians = degrees * (.pi / 180)

        let newSize = CGRect(origin: .zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size

        // 이미지 회전 후 크기 보정
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // 원점 이동
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        // 회전
        context.rotate(by: radians)
        // 이미지 그리기 (중앙 정렬)
        self.draw(in: CGRect(x: -self.size.width / 2,
                             y: -self.size.height / 2,
                             width: self.size.width,
                             height: self.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage
    }
}

