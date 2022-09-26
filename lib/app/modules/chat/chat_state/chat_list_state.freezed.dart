// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'chat_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ChatListState {
  StreamChannelListController get individualChannelsListController =>
      throw _privateConstructorUsedError;
  StreamChannelListController get groupChannelsListController =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChatListStateCopyWith<ChatListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatListStateCopyWith<$Res> {
  factory $ChatListStateCopyWith(
          ChatListState value, $Res Function(ChatListState) then) =
      _$ChatListStateCopyWithImpl<$Res>;
  $Res call(
      {StreamChannelListController individualChannelsListController,
      StreamChannelListController groupChannelsListController});
}

/// @nodoc
class _$ChatListStateCopyWithImpl<$Res>
    implements $ChatListStateCopyWith<$Res> {
  _$ChatListStateCopyWithImpl(this._value, this._then);

  final ChatListState _value;
  // ignore: unused_field
  final $Res Function(ChatListState) _then;

  @override
  $Res call({
    Object? individualChannelsListController = freezed,
    Object? groupChannelsListController = freezed,
  }) {
    return _then(_value.copyWith(
      individualChannelsListController: individualChannelsListController ==
              freezed
          ? _value.individualChannelsListController
          : individualChannelsListController // ignore: cast_nullable_to_non_nullable
              as StreamChannelListController,
      groupChannelsListController: groupChannelsListController == freezed
          ? _value.groupChannelsListController
          : groupChannelsListController // ignore: cast_nullable_to_non_nullable
              as StreamChannelListController,
    ));
  }
}

/// @nodoc
abstract class _$$_ChatListStateCopyWith<$Res>
    implements $ChatListStateCopyWith<$Res> {
  factory _$$_ChatListStateCopyWith(
          _$_ChatListState value, $Res Function(_$_ChatListState) then) =
      __$$_ChatListStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {StreamChannelListController individualChannelsListController,
      StreamChannelListController groupChannelsListController});
}

/// @nodoc
class __$$_ChatListStateCopyWithImpl<$Res>
    extends _$ChatListStateCopyWithImpl<$Res>
    implements _$$_ChatListStateCopyWith<$Res> {
  __$$_ChatListStateCopyWithImpl(
      _$_ChatListState _value, $Res Function(_$_ChatListState) _then)
      : super(_value, (v) => _then(v as _$_ChatListState));

  @override
  _$_ChatListState get _value => super._value as _$_ChatListState;

  @override
  $Res call({
    Object? individualChannelsListController = freezed,
    Object? groupChannelsListController = freezed,
  }) {
    return _then(_$_ChatListState(
      individualChannelsListController: individualChannelsListController ==
              freezed
          ? _value.individualChannelsListController
          : individualChannelsListController // ignore: cast_nullable_to_non_nullable
              as StreamChannelListController,
      groupChannelsListController: groupChannelsListController == freezed
          ? _value.groupChannelsListController
          : groupChannelsListController // ignore: cast_nullable_to_non_nullable
              as StreamChannelListController,
    ));
  }
}

/// @nodoc

class _$_ChatListState implements _ChatListState {
  _$_ChatListState(
      {required this.individualChannelsListController,
      required this.groupChannelsListController});

  @override
  final StreamChannelListController individualChannelsListController;
  @override
  final StreamChannelListController groupChannelsListController;

  @override
  String toString() {
    return 'ChatListState(individualChannelsListController: $individualChannelsListController, groupChannelsListController: $groupChannelsListController)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatListState &&
            const DeepCollectionEquality().equals(
                other.individualChannelsListController,
                individualChannelsListController) &&
            const DeepCollectionEquality().equals(
                other.groupChannelsListController,
                groupChannelsListController));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(individualChannelsListController),
      const DeepCollectionEquality().hash(groupChannelsListController));

  @JsonKey(ignore: true)
  @override
  _$$_ChatListStateCopyWith<_$_ChatListState> get copyWith =>
      __$$_ChatListStateCopyWithImpl<_$_ChatListState>(this, _$identity);
}

abstract class _ChatListState implements ChatListState {
  factory _ChatListState(
      {required final StreamChannelListController
          individualChannelsListController,
      required final StreamChannelListController
          groupChannelsListController}) = _$_ChatListState;

  @override
  StreamChannelListController get individualChannelsListController;
  @override
  StreamChannelListController get groupChannelsListController;
  @override
  @JsonKey(ignore: true)
  _$$_ChatListStateCopyWith<_$_ChatListState> get copyWith =>
      throw _privateConstructorUsedError;
}
