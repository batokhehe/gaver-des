class ProofAttachment {
  final int id;
  final String type; // proof | attachment
  final String file;

  ProofAttachment({
    required this.id,
    required this.type,
    required this.file,
  });

  factory ProofAttachment.fromJson(Map<String, dynamic> json) {
    return ProofAttachment(
      id: json['id'],
      file: json['file'],
      type: json['type'],
    );
  }
}
