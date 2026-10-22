class RenterEntity {
  const RenterEntity({
    required this.email,
    required this.fullName,
    this.phone,
    this.point = 0,
    this.blocked = false,
    this.role,
  });

  final String email;
  final String fullName;
  final String? phone;
  final int point;
  final bool blocked;
  final String? role;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenterEntity &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;
}
