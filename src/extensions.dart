import 'enums.dart';

extension ClassTypeExtension on ClassType {
  String get name {
    return this.toString().split('.')[1];
  }

  String get toFolderName {
    switch (this) {
      case ClassType.model:
        return "freezed models".toFolderName;
      case ClassType.repository:
        return "repositories".toFolderName;
      case ClassType.adapter:
        return "adapters".toFolderName;
      default:
        return "";
    }
  }
}

extension StringExtension on String {
  // "payment service"=>"PaymentService"
  String get toClassName {
    return this.toLowerCase().replaceAllMapped(RegExp(r"(^|\s)\w"),
        (match) => match.group(0)!.toUpperCase().replaceAll(" ", ""));
  }

  // "finish payment"=>"finishPayment"
  String get toFunctionName {
    return this.toLowerCase().replaceAllMapped(RegExp(r"\s\w"),
        (match) => match.group(0)!.toUpperCase().replaceAll(" ", ""));
  }

  // "payment gateway"=>"payment_gateway"
  String get toFolderName {
    return this.toLowerCase().replaceAll(" ", "_");
  }

  // "payment service"=>"paymentService.dart"
  String get toFileName {
    return this.toFolderName + ".dart";
  }

  //"POST"=> "RequestType.post"
  RequestType get requestType {
    return RequestType.values.firstWhere(
        (element) => element.toString().split(".")[1].toUpperCase() == this);
  }
}

extension RequestTypeExtension on RequestType {
  bool get hasBody {
    return this.name == "post" || this.name == "put";
  }
}
