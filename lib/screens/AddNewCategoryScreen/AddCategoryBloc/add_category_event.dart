part of 'add_category_bloc.dart';

abstract class AddCategoryEvent extends Equatable {
  const AddCategoryEvent();
}

class AddCategorySubmit extends AddCategoryEvent {
  final String name;
  
  const AddCategorySubmit({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}


class AddCategoryUpdate extends AddCategoryEvent {
  final String oldName;
  final String newName;
  
  const AddCategoryUpdate({
    required this.oldName, required this.newName
  });

  @override
  List<Object?> get props => [oldName,newName];
}
