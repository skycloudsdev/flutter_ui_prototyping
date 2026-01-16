class Member {
  const Member({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  final String id;
  final String name;
  final String avatarUrl;

  Member copyWith({
    String? id,
    String? name,
    String? avatarUrl,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
