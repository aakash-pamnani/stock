import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../../repositories/database_repository.dart';

part 'category_screen_event.dart';
part 'category_screen_state.dart';

class CategoryScreenBloc
    extends Bloc<CategoryScreenEvent, CategoryScreenState> {
  final DatabaseRepository _databaseRepository;

  List<String> data = [];
  CategoryScreenBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(const CategoryScreenState._()) {
    on<CategoryScreenFetchData>(_onFetchData);
    on<CategoryScreenDelete>(_onDelete);
  }

  Future<void> _onFetchData(CategoryScreenFetchData event, Emitter emit) async {
    try {
      emit(const CategoryScreenState.loading());
      List<String> data = await _databaseRepository.getCategoryNames();
      if (data.isNotEmpty) {
        this.data = data;
        emit(state.copyWith(status: CategoryScreenStatus.loaded, data: data));
      } else {
        emit(state.copyWith(
          status: CategoryScreenStatus.noData,
        ));
      }
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          status: CategoryScreenStatus.error, errorMsg: e.message));
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _onDelete(CategoryScreenDelete event, Emitter emit) async {
    try {
      emit(const CategoryScreenState.loading());
      await _databaseRepository.deleteCategory(event.name);
      emit(state.copyWith(
          status: CategoryScreenStatus.loaded, data: data..remove(event.name)));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          status: CategoryScreenStatus.error, errorMsg: e.message));
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
