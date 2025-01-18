import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:models_repository/models_repository.dart';
import 'package:path_provider/path_provider.dart';

String getAddress(Map<String, dynamic> addressMap) {
  String address = '';
  // country, state, city, road, neighbourhood, house_number
  if (addressMap['road'] != null) address += '${addressMap['road']}';
  if (addressMap['neighbourhood'] != null)
    address += ' , ${addressMap['neighbourhood']}';
  if (addressMap['house_number'] != null)
    address += ' , شقة رقم ${addressMap['house_number']}';
  if (addressMap['city'] != null) address += ' , ${addressMap['city']}';
  if (addressMap['country'] != null)
    address += ' , ${addressMap['country']} , ';
  if (addressMap['state'] != null) address += '${addressMap['state']}';
  return address;
}

String toArNumber(String input) {
  const eaMap = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
    ':': ':',
    '.': ',',
  };

  return input.split('').map((char) => eaMap[char] ?? char).join('');
}

String toArabicPeriod(String period) => period == 'am' ? 'ص' : 'م';

Future<File?> fetchImage() async {
  final XFile? fetchedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  if (fetchedImage == null) return null;
  String appDirPath = (await getApplicationDocumentsDirectory()).path;
  final imgPath = '$appDirPath/${fetchedImage.name}';
  final file = await File(fetchedImage.path).copy(imgPath);
  return file;
}

bool isMarketOpen(Market market, DateTime currentTime) {
  final todayOpenTime = DateTime(
    currentTime.year,
    currentTime.month,
    currentTime.day,
    market.beginTime.hour,
    market.beginTime.minute,
  );
  final todayCloseTime = DateTime(
    currentTime.year,
    currentTime.month,
    currentTime.day,
    market.endTime.hour,
    market.endTime.minute,
  );

  if (todayCloseTime.isBefore(todayOpenTime)) {
    if (currentTime.isAfter(todayOpenTime) ||
        currentTime.isBefore(todayCloseTime)) {
      return true;
    }
  } else if (currentTime.isAfter(todayOpenTime) &&
      currentTime.isBefore(todayCloseTime)) {
    return true;
  }
  return false;
}

