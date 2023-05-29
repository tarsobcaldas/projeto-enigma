class EnigmaMessage {
  final int id;
  final String message;

  EnigmaMessage({
    required this.id,
    required this.message,
  });

  factory EnigmaMessage.fromJson(Map<String, dynamic> json) {
    return EnigmaMessage(
      id: json['id'],
      message: json['message'],
    );
  }
}
