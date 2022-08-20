part of 'stock_screen_bloc.dart';

abstract class StockScreenEvent extends Equatable {}

class StockScreenFetchData extends StockScreenEvent {
  StockScreenFetchData();
  @override
  List<Object?> get props => [];

  @override
  String toString() => 'StockScreenFetchData()';
}

class StockScreenUpdateData extends StockScreenEvent {
  final int index;
  final StockModel data;
  StockScreenUpdateData({required this.index, required this.data});
  @override
  List<Object?> get props => [data, index];

  @override
  String toString() => 'StockScreenUpdateData(index: $index, data: $data)';
}

class StockScreenSearchData extends StockScreenEvent {
  final String query;
  StockScreenSearchData({
    required this.query,
  });

  @override
  List<Object?> get props => [query];
}

class StockScreenDelete extends StockScreenEvent {
  final int index;
  
  StockScreenDelete({
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}
