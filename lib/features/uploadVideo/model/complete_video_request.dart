class CompleteVideoRequest {
  final int id;
  final String name;
  final String email;

  CompleteVideoRequest({
    required this.id,
    required this.name,
    required this.email,
  });
  factory CompleteVideoRequest.fromJson(Map<String, dynamic> json) {
    return CompleteVideoRequest(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}