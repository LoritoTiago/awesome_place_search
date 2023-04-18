import 'awesome_place_model.dart';
import '../../domain/entities/awesome_place_entity.dart';

class PredictionModel extends PredictionEntity {
  PredictionModel({
    double? latitude,
    double? longitude,
    String? description,
    List<MatchedSubstring>? matchedSubstrings,
    String? placeId,
    String? reference,
    StructuredFormatting? structuredFormatting,
    List<Term>? terms,
    List<String>? types,
  }) : super(
          latitude: latitude,
          longitude: longitude,
          description: description,
          matchedSubstrings: matchedSubstrings,
          placeId: placeId,
          reference: reference,
          structuredFormatting: structuredFormatting,
          terms: terms,
          types: types,
        );

  factory PredictionModel.fromJson(Map<String, dynamic> json) =>
      PredictionModel(
        description: json["description"],
        matchedSubstrings: json["matched_substrings"] == null
            ? []
            : List<MatchedSubstring>.from(json["matched_substrings"]!
                .map((x) => MatchedSubstring.fromJson(x))),
        placeId: json["place_id"],
        reference: json["reference"],
        structuredFormatting: json["structured_formatting"] == null
            ? null
            : StructuredFormatting.fromJson(json["structured_formatting"]),
        terms: json["terms"] == null
            ? []
            : List<Term>.from(json["terms"]!.map((x) => Term.fromJson(x))),
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
      );
}
