import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../../repositories/database_repository.dart';

import '../../../model/stock_model.dart';

part 'stock_screen_event.dart';
part 'stock_screen_state.dart';

class StockScreenBloc extends Bloc<StockScreenEvent, StockScreenState> {
  final DatabaseRepository _databaseRepository;

  List<StockModel> data = [];
  final String category;
  StockScreenBloc(
      {required this.category, required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(const StockScreenState._()) {
    on<StockScreenFetchData>(_onFetchData);
    on<StockScreenSearchData>(_onSearchData);
    on<StockScreenUpdateData>(_onUpdateData);
    on<StockScreenDelete>(_onDelete);
  }

  Future<void> _onDelete(StockScreenDelete event, Emitter emit) async {
    try {
      emit(const StockScreenState.loading());
      await _databaseRepository.deleteStock(
          category, data.elementAt(event.index).itemName);
      emit(state.copyWith(
          status: StockScreenStatus.loaded, data: data..removeAt(event.index)));
    } on FirebaseException catch (e) {
      emit(
          state.copyWith(status: StockScreenStatus.error, errorMsg: e.message));
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _onSearchData(StockScreenSearchData event, Emitter emit) {
    if (event.query.isEmpty) {
      emit(state.copyWith(status: StockScreenStatus.loaded, data: this.data));
      return;
    }
    var data = state.data!;
    data = data.where(
      (element) {
        return element.itemName
            .toLowerCase()
            .startsWith(event.query.toLowerCase());
      },
    ).toList();
    emit(state.copyWith(status: StockScreenStatus.loaded, data: data));
  }

  Future<void> _onFetchData(StockScreenFetchData event, Emitter emit) async {
    try {
      emit(const StockScreenState.loading());

      List<StockModel> data =
          await _databaseRepository.getStockFromCategory(category);
      if (data.isNotEmpty) {
        this.data = data;
        emit(state.copyWith(status: StockScreenStatus.loaded, data: data));
      } else {
        emit(state.copyWith(
          status: StockScreenStatus.noData,
        ));
      }
    } on FirebaseException catch (e) {
      emit(
          state.copyWith(status: StockScreenStatus.error, errorMsg: e.message));
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _onUpdateData(StockScreenUpdateData event, Emitter emit) {
    emit(state.copyWith(status: StockScreenStatus.loading));
    data.removeAt(event.index);
    data.insert(event.index, event.data);
    emit(state.copyWith(status: StockScreenStatus.loaded, data: data.toList()));
  }
}
