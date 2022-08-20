part of 'stock_screen_bloc.dart';

enum StockScreenStatus { loading, loaded, initial, error, noData }

class StockScreenState extends Equatable {
  final StockScreenStatus status;
  final List<StockModel>? data;
  final String? errorMsg;
  const StockScreenState._({
    this.status = StockScreenStatus.initial,
    this.data,
    this.errorMsg,
  });

  const StockScreenState.loading({
    this.status = StockScreenStatus.loading,
    this.data,
    this.errorMsg,
  });

  StockScreenState copyWith({
    StockScreenStatus? status,
    List<StockModel>? data,
    String? errorMsg,
  }) {
    return StockScreenState._(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }

  @override
  String toString() =>
      'StockScreenState(status: $status, data: $data, errorMsg: $errorMsg)';

  @override
  List<Object?> get props => [status, errorMsg, data];
}
