part of 'stock_details_screen_cubit.dart';

enum StockDetailsScreenStatus {
  loading,
  loaded,
  stopLoading,
}

class StockDetailsScreenState extends Equatable {
  const StockDetailsScreenState(
      {required this.data, this.status = StockDetailsScreenStatus.loaded});
  final StockModel data;
  final StockDetailsScreenStatus status;

  @override
  List<Object> get props => [data, status];

  StockDetailsScreenState copyWith({
    StockModel? data,
    StockDetailsScreenStatus? status,
  }) {
    return StockDetailsScreenState(
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }

  @override
  String toString() => 'StockDetailsScreenState(data: $data, status: $status)';
}
