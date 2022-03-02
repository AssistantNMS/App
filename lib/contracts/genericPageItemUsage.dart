import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class GenericPageItemUsage {
  bool hasUsedToCraft;
  bool hasChargedBy;
  bool hasUsedToRecharge;
  bool hasRefinedUsing;
  bool hasRefinedToCreate;
  bool hasCookUsing;
  bool hasCookToCreate;
  bool hasDevProperties;
  bool isConsumable;
  bool isEggIngredient;

  GenericPageItemUsage({
    this.hasUsedToCraft,
    this.hasChargedBy,
    this.hasUsedToRecharge,
    this.hasRefinedUsing,
    this.hasRefinedToCreate,
    this.hasCookUsing,
    this.hasCookToCreate,
    this.hasDevProperties,
    this.isConsumable,
    this.isEggIngredient,
  });

  factory GenericPageItemUsage.initial() => GenericPageItemUsage(
        hasUsedToCraft: false,
        hasChargedBy: false,
        hasUsedToRecharge: false,
        hasRefinedUsing: false,
        hasRefinedToCreate: false,
        hasCookUsing: false,
        hasCookToCreate: false,
        hasDevProperties: false,
        isConsumable: false,
        isEggIngredient: false,
      );

  factory GenericPageItemUsage.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return GenericPageItemUsage.initial();
    }
    return GenericPageItemUsage(
      hasUsedToCraft: readBoolSafe(json, 'HasUsedToCraft'),
      hasChargedBy: readBoolSafe(json, 'HasChargedBy'),
      hasUsedToRecharge: readBoolSafe(json, 'HasUsedToRecharge'),
      hasRefinedUsing: readBoolSafe(json, 'HasRefinedUsing'),
      hasRefinedToCreate: readBoolSafe(json, 'HasRefinedToCreate'),
      hasCookUsing: readBoolSafe(json, 'HasCookUsing'),
      hasCookToCreate: readBoolSafe(json, 'HasCookToCreate'),
      hasDevProperties: readBoolSafe(json, 'HasDevProperties'),
      isConsumable: readBoolSafe(json, 'IsConsumable'),
      isEggIngredient: readBoolSafe(json, 'IsEggIngredient'),
    );
  }

  Map<String, dynamic> toJson() => {
        'HasUsedToCraft': this.hasUsedToCraft,
        'HasChargedBy': this.hasChargedBy,
        'HasUsedToRecharge': this.hasUsedToRecharge,
        'HasRefinedUsing': this.hasRefinedUsing,
        'HasRefinedToCreate': this.hasRefinedToCreate,
        'HasCookUsing': this.hasCookUsing,
        'HasCookToCreate': this.hasCookToCreate,
        'HasDevProperties': this.hasDevProperties,
        'IsConsumable': this.isConsumable,
        'IsEggIngredient': this.isEggIngredient,
      };
}
