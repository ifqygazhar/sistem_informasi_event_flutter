class Event {
  final int id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String location;
  final String? image;
  final int? capacity;
  final String status;
  final int participantsCount;
  final bool hasReachedCapacity;
  final User? creator;
  final List<User> participants;
  final String createdAt;
  final String updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.image,
    this.capacity,
    required this.status,
    required this.participantsCount,
    required this.hasReachedCapacity,
    this.creator,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      location: json['location'] ?? '',
      image: json['image'],
      capacity: json['capacity'],
      status: json['status'] ?? '',
      participantsCount: json['participants_count'] ?? 0,
      hasReachedCapacity: json['has_reached_capacity'] ?? false,
      creator: json['creator'] != null ? User.fromJson(json['creator']) : null,
      participants:
          json['participants'] != null
              ? (json['participants'] as List)
                  .map((p) => User.fromJson(p))
                  .toList()
              : [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool isAdmin;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isAdmin: json['is_admin'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class PaginationInfo {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  PaginationInfo({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      hasMorePages: json['has_more_pages'] ?? false,
    );
  }
}
