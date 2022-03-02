enum DonationType {
  UNKNOWN,
  PAYPAL,
  BRAVEREWARDS,
  BUYMEACOFFEE,
  KOFI,
  PATREON,
  GOOGLEPLAY,
  APPLEPLAY,
}

String getImage(DonationType donation) {
  switch (donation) {
    case DonationType.PAYPAL:
      return "payPal.png";
    case DonationType.BRAVEREWARDS:
      return "bat.png";
    case DonationType.BUYMEACOFFEE:
      return "buyMeACoffee.png";
    case DonationType.KOFI:
      return "kofi.png";
    case DonationType.PATREON:
      return "patreon.png";
    case DonationType.GOOGLEPLAY:
      return "googlePay.png";
    case DonationType.APPLEPLAY:
      return "applePay.png";
    case DonationType.UNKNOWN:
    default:
      return "unknown.png";
  }
}
