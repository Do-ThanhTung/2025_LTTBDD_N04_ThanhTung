// Cleaner, idiomatic response model with safe JSON parsing.
class ResponseModel {
  final String? word;
  final String? phonetic;
  final List<Phonetics>? phonetics;
  final List<Meanings>? meanings;
  final License? license;
  final List<String>? sourceUrls;

  const ResponseModel({
    this.word,
    this.phonetic,
    this.phonetics,
    this.meanings,
    this.license,
    this.sourceUrls,
  });

  factory ResponseModel.fromJson(
      Map<String, dynamic> json) {
    return ResponseModel(
      word: json['word'] as String?,
      phonetic: json['phonetic'] as String?,
      phonetics: (json['phonetics'] as List<dynamic>?)
          ?.map((e) => Phonetics.fromJson(
              Map<String, dynamic>.from(e)))
          .toList(),
      meanings: (json['meanings'] as List<dynamic>?)
          ?.map((e) => Meanings.fromJson(
              Map<String, dynamic>.from(e)))
          .toList(),
      license: json['license'] != null
          ? License.fromJson(Map<String, dynamic>.from(
              json['license']))
          : null,
      sourceUrls:
          (json['sourceUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'phonetic': phonetic,
        if (phonetics != null)
          'phonetics': phonetics!
              .map((e) => e.toJson())
              .toList(),
        if (meanings != null)
          'meanings': meanings!
              .map((e) => e.toJson())
              .toList(),
        if (license != null)
          'license': license!.toJson(),
        if (sourceUrls != null)
          'sourceUrls': sourceUrls,
      };
}

class Phonetics {
  final String? text;
  final String? audio;
  final String? sourceUrl;

  const Phonetics(
      {this.text, this.audio, this.sourceUrl});

  factory Phonetics.fromJson(
          Map<String, dynamic> json) =>
      Phonetics(
        text: json['text'] as String?,
        audio: json['audio'] as String?,
        sourceUrl: json['sourceUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'audio': audio,
        'sourceUrl': sourceUrl,
      };
}

class Meanings {
  final String? partOfSpeech;
  final List<Definitions>? definitions;
  final List<String>? synonyms;
  final List<String>? antonyms;

  const Meanings(
      {this.partOfSpeech,
      this.definitions,
      this.synonyms,
      this.antonyms});

  factory Meanings.fromJson(
          Map<String, dynamic> json) =>
      Meanings(
        partOfSpeech: json['partOfSpeech'] as String?,
        definitions:
            (json['definitions'] as List<dynamic>?)
                ?.map((e) => Definitions.fromJson(
                    Map<String, dynamic>.from(e)))
                .toList(),
        synonyms: (json['synonyms'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        antonyms: (json['antonyms'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'partOfSpeech': partOfSpeech,
        if (definitions != null)
          'definitions': definitions!
              .map((e) => e.toJson())
              .toList(),
        if (synonyms != null) 'synonyms': synonyms,
        if (antonyms != null) 'antonyms': antonyms,
      };
}

class Definitions {
  final String? definition;
  final List<String>? synonyms;
  final List<String>? antonyms;
  final String? example;

  const Definitions(
      {this.definition,
      this.synonyms,
      this.antonyms,
      this.example});

  factory Definitions.fromJson(
          Map<String, dynamic> json) =>
      Definitions(
        definition: json['definition'] as String?,
        synonyms: (json['synonyms'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        antonyms: (json['antonyms'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        example: json['example'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'definition': definition,
        if (synonyms != null) 'synonyms': synonyms,
        if (antonyms != null) 'antonyms': antonyms,
        if (example != null) 'example': example,
      };
}

class License {
  final String? name;
  final String? url;

  const License({this.name, this.url});

  factory License.fromJson(
          Map<String, dynamic> json) =>
      License(
        name: json['name'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
      };
}
