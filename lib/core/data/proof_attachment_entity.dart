class ProofAttachmentEntity {
  final int id;
  final String type; // proof | attachment
  final String file;

  ProofAttachmentEntity({
    required this.id,
    required this.type,
    required this.file,
  });
}
