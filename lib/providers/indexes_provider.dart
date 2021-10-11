import 'dart:typed_data';

import 'package:image/image.dart';

double getGA(Uint8List imageAsUint8) {
  final image = decodeImage(imageAsUint8);
  final imageHue = getImageHue(image!);
  final greenAreaImage = getTresholdedImage(imageHue, min: 60.0, max: 180.0);
  final greenArea = getPercentWithinThreshold(greenAreaImage);
  return greenArea;
}

double getGGA(Uint8List imageAsUint8) {
  final image = decodeImage(imageAsUint8);
  final imageHue = getImageHue(image!);
  final greenerAreaImage = getTresholdedImage(imageHue, min: 80.0, max: 180.0);
  final greenerArea = getPercentWithinThreshold(greenerAreaImage);
  return greenerArea;
}

Float32List getImageHue(Image image) {
  final imagePixels = image.getBytes(format: Format.rgb);
  var imageAsHue = Float32List((imagePixels.length) ~/ 3);
  var anotherCounter = 0;
  for (var i = 0, len = imagePixels.length; i < len; i += 3) {
    imageAsHue[anotherCounter] =
        getHue(imagePixels[i], imagePixels[i + 1], imagePixels[i + 2]);
    anotherCounter++;
  }
  return imageAsHue;
}

double getHue(int red, int green, int blue) {
  final max = getMax([red, green, blue]);
  final min = getMin([red, green, blue]);
  final delta = max - min;
  late double hue;
  if (max == 0.0) {
    hue = 0.0;
  } else if (max == red) {
    hue = 60.0 * (((green - blue) / delta) % 6);
  } else if (max == green) {
    hue = 60.0 * (((blue - red) / delta) + 2);
  } else if (max == blue) {
    hue = 60.0 * (((red - green) / delta) + 4);
  }
  hue = hue.isNaN ? 0.0 : hue;
  return hue;
}

int getMax(List<int> list) {
  var max = 0;
  for (var element in list) {
    max = (element > max) ? element : max;
  }
  return max;
}

int getMin(List<int> list) {
  var min = 9999999999;
  for (var element in list) {
    min = (element < min) ? element : min;
  }
  return min;
}

Uint8List getTresholdedImage(Float32List imageHue,
    {required double min, required double max}) {
  var thresholdedImage = Uint8List(imageHue.length);
  int index = 0;
  for (var element in imageHue) {
    (element >= min && element <= max)
        ? thresholdedImage[index] = 255
        : thresholdedImage[index] = 0;
    index++;
  }

  return thresholdedImage;
}

double getPercentWithinThreshold(List<int> thresholdedImage) {
  var pixelsWithinThreshold = 0;
  for (var element in thresholdedImage) {
    if (element == 255) {
      pixelsWithinThreshold++;
    }
  }

  return pixelsWithinThreshold / thresholdedImage.length * 100;
}
