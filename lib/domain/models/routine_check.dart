class RoutineCheck {
  final String id;
  final String routineId;
  final DateTime date;
  final bool isCompleted;
  final DateTime? completedAt;

  const RoutineCheck({
    required this.id,
    required this.routineId,
    required this.date,
    required this.isCompleted,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'routine_id': routineId,
      'date': date.millisecondsSinceEpoch,
      'is_completed': isCompleted ? 1 : 0,
      'completed_at': completedAt?.millisecondsSinceEpoch,
    };
  }

  factory RoutineCheck.fromMap(Map<String, dynamic> map) {
    return RoutineCheck(
      id: map['id'],
      routineId: map['routine_id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      isCompleted: map['is_completed'] == 1,
      completedAt: map['completed_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'])
          : null,
    );
  }

  RoutineCheck copyWith({
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return RoutineCheck(
      id: id,
      routineId: routineId,
      date: date,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class DailyProgress {
  final DateTime date;
  final int completedCount;
  final int totalCount;

  double get completionRate => totalCount > 0 ? completedCount / totalCount : 0.0;

  const DailyProgress({
    required this.date,
    required this.completedCount,
    required this.totalCount,
  });
} 