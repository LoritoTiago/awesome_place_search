import 'dart:convert';

import 'package:awesome_place_search/src/data/models/prediction_model.dart';

import '../../domain/entities/awesome_place_entity.dart';
import '../../domain/repositories/i_get_places.dart';

AwesomePlacesSearchModel awesomePlacesModelFromJson(String str) =>
    AwesomePlacesSearchModel.fromJson(json.decode(str));

class AwesomePlacesSearchModel extends AwesomePlacesSearchEntity {
  final List<PredictionModel>? predictions;
  AwesomePlacesSearchModel({
    this.predictions,
    String? status,
  }) : super(predictions: predictions, status: status);

  factory AwesomePlacesSearchModel.fromJson(Map<String, dynamic> json) =>
      AwesomePlacesSearchModel(
        predictions: json["predictions"] == null
            ? []
            : List<PredictionModel>.from(
                json["predictions"]!.map((x) => PredictionModel.fromJson(x))),
        status: json["status"],
      );
}

class MatchedSubstring extends MatchedSubstringEntity {
  MatchedSubstring({
    int? length,
    int? offset,
  }) : super(length: length, offset: offset);

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MatchedSubstring(
        length: json["length"],
        offset: json["offset"],
      );
}

class StructuredFormatting extends StructuredFormattingEntity {
  StructuredFormatting({
    String? mainText,
    List<MatchedSubstring>? mainTextMatchedSubstrings,
    String? secondaryText,
  }) : super(
            mainText: mainText,
            mainTextMatchedSubstrings: mainTextMatchedSubstrings,
            secondaryText: secondaryText);

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
        mainTextMatchedSubstrings: json["main_text_matched_substrings"] == null
            ? []
            : List<MatchedSubstring>.from(json["main_text_matched_substrings"]!
                .map((x) => MatchedSubstring.fromJson(x))),
        secondaryText: json["secondary_text"],
      );
}

class Term extends TermEntity {
  Term({
    int? offset,
    String? value,
  }) : super(offset: offset, value: value);

  factory Term.fromJson(Map<String, dynamic> json) => Term(
        offset: json["offset"],
        value: json["value"],
      );
}

class ParmSearchModel extends ParmSearchEntity {
  ParmSearchModel({required String value, required String key})
      : super(key: key, value: value);
}
