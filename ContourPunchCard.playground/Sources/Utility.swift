import UIKit
import Vision

public class GaussianBlurFilter {
    private let filter = CIFilter(name: "CIGaussianBlur")!
    init() {}
    public var radius: Float {
        set {
            filter.setValue(newValue, forKey: "inputRadius")
        }
        get {
            filter.value(forKey: "inputRadius") as! Float
        }
    }
    public var inputImage: CIImage {
        set {
            filter.setValue(newValue, forKey: kCIInputImageKey)
        }
        get {
            filter.value(forKey: kCIInputImageKey) as! CIImage
        }
    }
    public var outputImage: CIImage? {
        filter.outputImage
    }
}

// https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIColorControls
public class ColorControlsFilter {
    private let filter = CIFilter(name: "CIColorControls")!
    init() {}
    public var inputImage: CIImage {
        set {
            filter.setValue(newValue, forKey: kCIInputImageKey)
        }
        get {
            filter.value(forKey: kCIInputImageKey) as! CIImage
        }
    }
    public var contrast: Float {
        set {
            filter.setValue(newValue, forKey: kCIInputContrastKey)
        }
        get {
            filter.value(forKey: kCIInputContrastKey) as! Float
        }
    }
    public var brightness: Float {
        set {
            filter.setValue(newValue, forKey: kCIInputBrightnessKey)
        }
        get {
            filter.value(forKey: kCIInputBrightnessKey) as! Float
        }
    }
    public var saturation: Float {
        set {
            filter.setValue(newValue, forKey: kCIInputSaturationKey)
        }
        get {
            filter.value(forKey: kCIInputSaturationKey) as! Float
        }
    }
    public var outputImage: CIImage? {
        filter.outputImage
    }
}

extension CIFilter {
    public static func gaussianBlur() -> GaussianBlurFilter {
        GaussianBlurFilter()
    }
    public static func colorControls() -> ColorControlsFilter {
        ColorControlsFilter()
    }
}

public class ContoursView: UIView {
    var color: UIColor = .red

    public var contours: CGPath? {
        set {
            pathLayer?.path = newValue
        }
        get {
            pathLayer?.path
        }
    }

    private var pathLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    private func setupLayer() {
        isOpaque = false
        backgroundColor = .clear
        let pathLayer = CAShapeLayer()
        pathLayer.strokeColor = color.cgColor
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.lineWidth = 4
        layer.addSublayer(pathLayer)
        self.pathLayer = pathLayer
    }
}

extension CGAffineTransform {
    public static var verticalFlip = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
}

public func drawContours(
    contoursObservation: VNContoursObservation,
    sourceImage: UIView
) -> UIView {
    let contoursView = ContoursView()
    //let path = CGPath(roundedRect: CGRect(x: 200, y: 200, width: 200.0, height: 200.0), cornerWidth: 2.0, cornerHeight: 2.0, transform: nil)  // Sample  path
    let path = UIBezierPath(cgPath: contoursObservation.normalizedPath)
    path.apply(CGAffineTransform.verticalFlip)
    path.apply(CGAffineTransform(scaleX: sourceImage.bounds.width, y: sourceImage.bounds.height))
    contoursView.contours = path.cgPath
    sourceImage.addSubview(contoursView)
    contoursView.frame = sourceImage.bounds
    
    return sourceImage
}
