import 'package:intl_phone_field/countries.dart';

class PhoneNumber {
  String? countryISOCode;
  String? countryCode;
  String? number;

  PhoneNumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
  });

  String get completeNumber {
    return countryCode! + number!;
  }

  factory PhoneNumber.fromCompleteNumber(String completeNumber) {
    final number = completeNumber.replaceFirst(RegExp(r'^(\+|0+)'), '');
    final country = countries.firstWhere((map) {
      final dialCode = map['dial_code'];
      final len = map['max_length'];
      if (!number.startsWith(dialCode.toString())) {
        return false;
      }
      final completeLength = len + dialCode.toString().length;
      if (number.length != completeLength) {
        return false;
      }
      return true;
    }, orElse: () => Map<String, dynamic>());
    if (country.isNotEmpty) {
      final code = country['code'];
      final dialCode = country['dial_code'].toString();
      return PhoneNumber(
          countryISOCode: code,
          countryCode: dialCode,
          number: number.substring(dialCode.length));
    } else {
      return PhoneNumber(countryISOCode: null, countryCode: null, number: null);
    }
  }
}
