class FaqModel {
  final String id;
  final String question;
  final String answer;
  final DateTime createdAt;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] ?? "",
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question,
      "answer": answer,
      "createdAt": createdAt,
    };
  }
}