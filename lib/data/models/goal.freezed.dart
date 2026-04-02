// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Goal _$GoalFromJson(Map<String, dynamic> json) {
  return _Goal.fromJson(json);
}

/// @nodoc
mixin _$Goal {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  double get targetAmount => throw _privateConstructorUsedError;
  @HiveField(3)
  double get currentAmount => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime? get deadline => throw _privateConstructorUsedError;
  @HiveField(5)
  GoalType get type => throw _privateConstructorUsedError;
  @HiveField(6)
  int get streakDays => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime? get lastCheckIn => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get isCompleted => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(10)
  int get contributionStreak => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime? get lastContribution => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoalCopyWith<Goal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalCopyWith<$Res> {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) then) =
      _$GoalCopyWithImpl<$Res, Goal>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) double targetAmount,
      @HiveField(3) double currentAmount,
      @HiveField(4) DateTime? deadline,
      @HiveField(5) GoalType type,
      @HiveField(6) int streakDays,
      @HiveField(7) DateTime? lastCheckIn,
      @HiveField(8) bool isCompleted,
      @HiveField(9) DateTime createdAt,
      @HiveField(10) int contributionStreak,
      @HiveField(11) DateTime? lastContribution});
}

/// @nodoc
class _$GoalCopyWithImpl<$Res, $Val extends Goal>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? deadline = freezed,
    Object? type = null,
    Object? streakDays = null,
    Object? lastCheckIn = freezed,
    Object? isCompleted = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAmount: null == currentAmount
          ? _value.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GoalType,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      lastCheckIn: freezed == lastCheckIn
          ? _value.lastCheckIn
          : lastCheckIn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalImplCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$$GoalImplCopyWith(
          _$GoalImpl value, $Res Function(_$GoalImpl) then) =
      __$$GoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) double targetAmount,
      @HiveField(3) double currentAmount,
      @HiveField(4) DateTime? deadline,
      @HiveField(5) GoalType type,
      @HiveField(6) int streakDays,
      @HiveField(7) DateTime? lastCheckIn,
      @HiveField(8) bool isCompleted,
      @HiveField(9) DateTime createdAt});
}

/// @nodoc
class __$$GoalImplCopyWithImpl<$Res>
    extends _$GoalCopyWithImpl<$Res, _$GoalImpl>
    implements _$$GoalImplCopyWith<$Res> {
  __$$GoalImplCopyWithImpl(_$GoalImpl _value, $Res Function(_$GoalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? deadline = freezed,
    Object? type = null,
    Object? streakDays = null,
    Object? lastCheckIn = freezed,
    Object? isCompleted = null,
    Object? createdAt = null,
  }) {
    return _then(_$GoalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAmount: null == currentAmount
          ? _value.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GoalType,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      lastCheckIn: freezed == lastCheckIn
          ? _value.lastCheckIn
          : lastCheckIn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalImpl extends _Goal {
  _$GoalImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.targetAmount,
      @HiveField(3) this.currentAmount = 0.0,
      @HiveField(4) this.deadline,
      @HiveField(5) required this.type,
      @HiveField(6) this.streakDays = 0,
      @HiveField(7) this.lastCheckIn,
      @HiveField(8) this.isCompleted = false,
      @HiveField(9) required this.createdAt,
      @HiveField(10) this.contributionStreak = 0,
      @HiveField(11) this.lastContribution})
      : super._();

  factory _$GoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final double targetAmount;
  @override
  @JsonKey()
  @HiveField(3)
  final double currentAmount;
  @override
  @HiveField(4)
  final DateTime? deadline;
  @override
  @HiveField(5)
  final GoalType type;
  @override
  @JsonKey()
  @HiveField(6)
  final int streakDays;
  @override
  @HiveField(7)
  final DateTime? lastCheckIn;
  @override
  @JsonKey()
  @HiveField(8)
  final bool isCompleted;
  @override
  @HiveField(9)
  final DateTime createdAt;
  @override
  @HiveField(10)
  final int contributionStreak;
  @override
  @HiveField(11)
  final DateTime? lastContribution;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.lastCheckIn, lastCheckIn) ||
                other.lastCheckIn == lastCheckIn) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.contributionStreak, contributionStreak) ||
                other.contributionStreak == contributionStreak) &&
            (identical(other.lastContribution, lastContribution) ||
                other.lastContribution == lastContribution));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      targetAmount,
      currentAmount,
      deadline,
      type,
      streakDays,
      lastCheckIn,
      isCompleted,
      createdAt,
      contributionStreak,
      lastContribution);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      __$$GoalImplCopyWithImpl<_$GoalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalImplToJson(
      this,
    );
  }
}

abstract class _Goal extends Goal {
  factory _Goal(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(2) required final double targetAmount,
      @HiveField(3) final double currentAmount,
      @HiveField(4) final DateTime? deadline,
      @HiveField(5) required final GoalType type,
      @HiveField(6) final int streakDays,
      @HiveField(7) final DateTime? lastCheckIn,
      @HiveField(8) final bool isCompleted,
      @HiveField(9) required final DateTime createdAt,
      @HiveField(10) final int contributionStreak,
      @HiveField(11) final DateTime? lastContribution}) = _$GoalImpl;
  _Goal._() : super._();

  factory _Goal.fromJson(Map<String, dynamic> json) = _$GoalImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  double get targetAmount;
  @override
  @HiveField(3)
  double get currentAmount;
  @override
  @HiveField(4)
  DateTime? get deadline;
  @override
  @HiveField(5)
  GoalType get type;
  @override
  @HiveField(6)
  int get streakDays;
  @override
  @HiveField(7)
  DateTime? get lastCheckIn;
  @override
  @HiveField(8)
  bool get isCompleted;
  @override
  @HiveField(9)
  DateTime get createdAt;
  @override
  @HiveField(10)
  int get contributionStreak;
  @override
  @HiveField(11)
  DateTime? get lastContribution;
  @override
  @JsonKey(ignore: true)
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
