class Pemandu {
  int? id;
  String? guide;
  String? languages;
  int? rating;

  Pemandu({this.id, this.guide, this.languages, this.rating});

  // Factory constructor untuk parsing dari JSON
  factory Pemandu.fromJson(Map<String, dynamic> obj) {
    return Pemandu(
      id: obj['id'] as int?,
      guide: obj['guide'] as String?, 
      languages: obj['languages'] as String?, 
      rating: obj['rating'] as int?,
    );
  }
}
