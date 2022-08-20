part of 'category_screen_bloc.dart';

enum CategoryScreenStatus { loading, loaded, initial, error, noData, addData }

class CategoryScreenState extends Equatable {
  final CategoryScreenStatus status;
  final List<String>? data;
  final String? errorMsg;
  const CategoryScreenState._({
    this.status = CategoryScreenStatus.initial,
    this.data,
    this.errorMsg,
  });

  const CategoryScreenState.loading({
    this.status = CategoryScreenStatus.loading,
    this.data,
    this.errorMsg,
  });

  CategoryScreenState copyWith({
    CategoryScreenStatus? status,
    List<String>? data,
    String? errorMsg,
  }) {
    return CategoryScreenState._(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }

  @override
  String toString() =>
      'CategoryScreenState(status: $status, data: $data, errorMsg: $errorMsg)';

  @override
  List<Object?> get props => [status, errorMsg, data];
}
