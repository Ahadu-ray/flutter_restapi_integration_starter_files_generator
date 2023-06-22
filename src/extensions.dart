import 'enums.dart';

extension ClassTypeExtension on ClassType {
  String get folderName {
    switch (this) {
      case ClassType.model:
        return "freezed models".folderName;
      case ClassType.repository:
        return "repositories".folderName;
      case ClassType.adapter:
        return "adapters".folderName;
      default:
        return "";
    }
  }
}

extension StringExtension on String {
  // "payment service"=>"PaymentService"
  String get className {
    return this.toLowerCase().replaceAllMapped(RegExp(r"(^|\s)\w"),
        (match) => match.group(0)!.toUpperCase().replaceAll(" ", ""));
  }

  // "finish payment"=>"finishPayment"
  String get functionName {
    return this.toLowerCase().replaceAllMapped(RegExp(r"(\s)\w"),
        (match) => match.group(0)!.toUpperCase().replaceAll(" ", ""));
  }

  // "payment gateway"=>"payment_gateway"
  String get folderName {
    return this.toLowerCase().replaceAll(" ", "_");
  }

  // "payment service"=>"paymentService.dart"
  String get fileName {
    return this.functionName + ".dart";
  }
}
