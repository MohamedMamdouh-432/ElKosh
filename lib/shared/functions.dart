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
