class EventDetail {
  final String message;
  final Data data;
  final bool isRegistered;

  EventDetail({
    required this.message,
    required this.data,
    required this.isRegistered,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) => EventDetail(
    message: json["message"],
    data: Data.fromJson(json["data"]),
    isRegistered: json["is_registered"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
    "is_registered": isRegistered,
  };
}

class Data {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String image;
  final int capacity;
  final String status;
  final int participantsCount;
  final bool hasReachedCapacity;
  final Creator creator;
  final List<Creator> participants;
  final DateTime createdAt;
  final DateTime updatedAt;

  Data({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.image,
    required this.capacity,
    required this.status,
    required this.participantsCount,
    required this.hasReachedCapacity,
    required this.creator,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    location: json["location"],
    image: json["image"],
    capacity: json["capacity"],
    status: json["status"],
    participantsCount: json["participants_count"],
    hasReachedCapacity: json["has_reached_capacity"],
    creator: Creator.fromJson(json["creator"]),
    participants: List<Creator>.from(
      json["participants"].map((x) => Creator.fromJson(x)),
    ),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "location": location,
    "image": image,
    "capacity": capacity,
    "status": status,
    "participants_count": participantsCount,
    "has_reached_capacity": hasReachedCapacity,
    "creator": creator.toJson(),
    "participants": List<dynamic>.from(participants.map((x) => x.toJson())),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Creator {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;

  Creator({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    isAdmin: json["is_admin"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "is_admin": isAdmin,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
