import UIKit
import Vision

// Load image
let sourceImage = UIImage(named: "punchcard.png")!
var inputImage = CIImage(cgImage: sourceImage.cgImage!)
let imageView = UIImageView(image: sourceImage)

// Filter image
let noiseReductionFilter = CIFilter.gaussianBlur()
noiseReductionFilter.radius = 2.5
noiseReductionFilter.inputImage = inputImage

let intermediateImage = noiseReductionFilter.outputImage!

let monochromeFilter = CIFilter.colorControls()
monochromeFilter.inputImage = intermediateImage
monochromeFilter.contrast = 20.0
monochromeFilter.brightness = 8
monochromeFilter.saturation = 50

inputImage = monochromeFilter.outputImage!

// Detect contours
let contourRequest = VNDetectContoursRequest()
let requestHandler = VNImageRequestHandler(ciImage: inputImage, options: [:])

try requestHandler.perform([contourRequest])
let contoursObservation = contourRequest.results!.first!
print("\(contoursObservation.contourCount) contours found")
_ = drawContours(contoursObservation: contoursObservation, sourceImage: imageView)

