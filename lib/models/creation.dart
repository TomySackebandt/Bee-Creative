class Creation {
  final String name;
  final String prompt;
  final String negativePrompt;
  final String model;
  final String filePath;
  final int height;
  final int width;
  final int seed;
  final DateTime creationDate;

  Creation(this.name, this.prompt, this.negativePrompt, this.model,
      this.filePath, this.height, this.width, this.seed, this.creationDate);

  factory Creation.fromJson(Map<String, dynamic> json) {
    return Creation(
        json['name'],
        json['prompt'],
        json['negativePrompt'] ?? "",
        json['model'],
        json['filePath'],
        json['height'] ?? 0, // default to 0 if 'height' is missing
        json['width'] ?? 0, // default to 0 if 'width' is missing
        json['seed'] ?? 0,
        DateTime.parse(json['creationDate']));
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'prompt': prompt,
      'negativePrompt': negativePrompt,
      'model': model,
      'filePath': filePath,
      'height': height,
      'width': width,
      'seed': seed,
      'creationDate': creationDate.toIso8601String(),
    };
  }
}
