part of 'category_screen_bloc.dart';

abstract class CategoryScreenEvent extends Equatable {}

class CategoryScreenFetchData extends CategoryScreenEvent {
  @override
  List<Object?> get props => [];
}

class CategoryScreenDelete extends CategoryScreenEvent {
  final String name;
  CategoryScreenDelete({
    required this.name,
  });
  @override
  List<Object?> get props => [name];

  @override
  String toString() => 'CategoryScreenDelete(name: $name)';
}
