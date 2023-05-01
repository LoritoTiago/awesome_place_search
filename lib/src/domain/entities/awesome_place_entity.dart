class AwesomePlacesSearchEntity {
  AwesomePlacesSearchEntity({
    this.predictions,
    this.status,
  });

  final List<PredictionEntity>? predictions;
  final String? status;
}

class PredictionEntity {
  PredictionEntity({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.types,
    this.latitude,
    this.longitude,
  });

  final String? description;
  double? latitude;
  double? longitude;

  final List<MatchedSubstringEntity>? matchedSubstrings;
  final String? placeId;
  final String? reference;
  final StructuredFormattingEntity? structuredFormatting;
  final List<TermEntity>? terms;
  final List<String>? types;
}

class MatchedSubstringEntity {
  MatchedSubstringEntity({
    this.length,
    this.offset,
  });

  final int? length;
  final int? offset;
}

class StructuredFormattingEntity {
  StructuredFormattingEntity({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
  });

  final String? mainText;
  final List<MatchedSubstringEntity>? mainTextMatchedSubstrings;
  final String? secondaryText;
}

class TermEntity {
  TermEntity({
    this.offset,
    this.value,
  });

  final int? offset;
  final String? value;
}
