import 'package:image/image.dart';
import 'dart:io';

double getGA(String imagePath, pls) {
  final image = decodeImage(pls);
  final imageHue = getImageHue(image!);
  final greenAreaImage = getTresholdedImage(imageHue, min: 60.0, max: 180.0);
  final greenArea = getPercentWithinThreshold(greenAreaImage);
  return greenArea;
}

double getGGA(String imagePath, pls) {
  final image = decodeImage(pls);
  final imageHue = getImageHue(image!);
  final greenerAreaImage = getTresholdedImage(imageHue, min: 80.0, max: 180.0);
  final greenerArea = getPercentWithinThreshold(greenerAreaImage);
  return greenerArea;
}

List<double> getImageHue(Image image) {
  final imagePixels = image.getBytes(format: Format.rgb);
  var imageAsHue = <double>[];
  for (var i = 0, len = imagePixels.length; i < len; i += 3) {
    imageAsHue
        .add(getHue(imagePixels[i], imagePixels[i + 1], imagePixels[i + 2]));
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
  list.forEach((element) {
    max = (element > max) ? element : max;
  });
  return max;
}

int getMin(List<int> list) {
  var min = 999999999999999999;
  list.forEach((element) {
    min = (element < min) ? element : min;
  });
  return min;
}

List<int> getTresholdedImage(List<double> imageHue,
    {required double min, required double max}) {
  var thresholdedImage = <int>[];
  imageHue.forEach((element) {
    (element >= min && element <= max)
        ? thresholdedImage.add(255)
        : thresholdedImage.add(0);
  });
  return thresholdedImage;
}

double getPercentWithinThreshold(List<int> thresholdedImage) {
  var pixelsWithinThreshold = 0;
  thresholdedImage.forEach((element) {
    if (element == 255) {
      pixelsWithinThreshold++;
    }
  });
  return pixelsWithinThreshold / thresholdedImage.length * 100;
}
