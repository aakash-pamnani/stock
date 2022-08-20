import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock/repositories/database_repository.dart';

part 'add_category_event.dart';
part 'add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final DatabaseRepository _database;
  AddCategoryBloc({required DatabaseRepository database})
      : _database = database,
        super(const AddCategoryState()) {
    on<AddCategorySubmit>((event, emit) async {
      emit(state.copyWith(status: AddCategoryStatus.loading));
      if (event.name.isEmpty) {
        emit(state.copyWith(
            status: AddCategoryStatus.error,
            msg: "Category Name Cannot be Empty"));
      } else {
        emit(state.copyWith(status: AddCategoryStatus.loading));
        await _database.addCategory(event.name);
        emit(state.copyWith(status: AddCategoryStatus.close, name: event.name));
      }
    });

    on<AddCategoryUpdate>((event, emit) async {
      emit(state.copyWith(status: AddCategoryStatus.loading));
      if (event.newName.isEmpty) {
        emit(state.copyWith(
            status: AddCategoryStatus.error,
            msg: "Category Name Cannot be Empty"));
      } else {
        emit(state.copyWith(status: AddCategoryStatus.loading));
        await _database.updateCategory(event.oldName, event.newName);
        emit(state.copyWith(
            status: AddCategoryStatus.close, name: event.newName));
      }
    });
  }
}
