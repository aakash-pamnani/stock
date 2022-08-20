import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/stock_model.dart';

part 'stock_details_screen_state.dart';

class StockDetailsScreenCubit extends Cubit<StockDetailsScreenState> {
  final StockModel data;
  StockDetailsScreenCubit({required this.data})
      : super(StockDetailsScreenState(data: data..sortItemData()));

  onUpdate(StockModel data) async {
    emit(state.copyWith(
        status: StockDetailsScreenStatus.loaded, data: data..sortItemData()));
  }
}
