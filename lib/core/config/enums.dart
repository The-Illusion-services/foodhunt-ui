enum AccountType { restaurant, buyer }

extension AccountTypeExtension on AccountType {
  String get type {
    switch (this) {
      case AccountType.restaurant:
        return "restaurant";
      case AccountType.buyer:
        return "buyer";
    }
  }
}

enum Font {
  jkSans,
  sfPro,
}

extension FontExtension on Font {
  String get fontName {
    switch (this) {
      case Font.jkSans:
        return "JK_Sans";
      case Font.sfPro:
        return "SF_Pro";
    }
  }
}
