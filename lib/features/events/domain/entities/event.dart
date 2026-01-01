class Event {
  final String? id;
  final String title;
  final String description;
  final String category;
  final String createdBy;
  final String? supervisingTeacherId;
  final String status; // CHANGED: Now using String instead of EventStatus enum
  final DateTime createdAt;
  final DateTime scheduledFor;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdBy,
    this.supervisingTeacherId,
    required this.status, // CHANGED: Now accepts String
    required this.createdAt,
    required this.scheduledFor,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      supervisingTeacherId: json['supervising_teacher_id']?.toString(),
      status: json['status']?.toString() ?? 'pending', // CHANGED: Direct string
      createdAt: DateTime.parse(json['created_at']),
      scheduledFor: DateTime.parse(json['scheduled_for']),
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'title': title,
      'description': description,
      'category': category,
      'created_by': createdBy,
      'supervising_teacher_id': supervisingTeacherId,
      'status': status,
      'scheduled_for': scheduledFor.toIso8601String(),
    };
    
    if (id != null) {
      json['id'] = id;
    }
    
    return json;
  }
}

// You can remove this enum completely or keep it for reference
// But don't use it in the Event model
/*
enum EventStatus {
  pending,
  approved,
  rejected,
  live,
  completed,
}
*/
// You can keep the enum for reference, but don't use it in Event model
enum EventStatus {
  pending,
  approved,
  rejected,
  live,
  completed,
}