part of 'add_category_bloc.dart';

enum AddCategoryStatus { initial, loading, close, error }

class AddCategoryState extends Equatable {
  const AddCategoryState({
    this.name,
    this.msg,
  this.status = AddCategoryStatus.initial,
  });

  final String? name;
  final String? msg;
  final AddCategoryStatus status;
  @override
  List<Object?> get props => [name, msg, status];

  AddCategoryState copyWith({
    String? name,
    String? msg,
    AddCategoryStatus? status,
  }) {
    return AddCategoryState(
      name: name ?? this.name,
      msg: msg ?? this.msg,
      status: status ?? this.status,
    );
  }
}
