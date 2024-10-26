import 'package:bee_creative/models/creation.dart';

class Collection {
  List<Creation> creations;

  Collection(this.creations);

  void addCreation(Creation creation) {
    creations.add(creation);
  }

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      (json['creations'] as List)
          .map((creation) => Creation.fromJson(creation))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creations': creations.map((creation) => creation.toJson()).toList()
    };
  }
}
