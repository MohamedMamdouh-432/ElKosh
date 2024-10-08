import 'dart:developer';

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
  log(address);
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
  };

  return input.split('').map((char) => eaMap[char] ?? char).join('');
}
