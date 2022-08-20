part of 'stock_add_screen_bloc.dart';

enum StockAddScreenStatus {
  initial,
  editing,
  loading,
  closeDialog,
  error,
  sucess
}

class StockAddScreenState extends Equatable {
  const StockAddScreenState({
    this.itemSuggestion,
    // this.categorySuggestion,
    required this.data,
    this.status = StockAddScreenStatus.initial,
    this.msg,
  });

  final List<String>? itemSuggestion;
  // final List<String>? categorySuggestion;
  final StockModel data;
  final StockAddScreenStatus status;
  final String? msg;

  @override
  List<Object?> get props {
    return [itemSuggestion, status, msg, data];
  }

  StockAddScreenState copyWith({
    List<String>? itemSuggestion,
    List<String>? categorySuggestion,
    StockModel? data,
    StockAddScreenStatus? status,
    String? msg,
  }) {
    return StockAddScreenState(
      itemSuggestion: itemSuggestion ?? this.itemSuggestion,
      // categorySuggestion: categorySuggestion ?? this.categorySuggestion,
      data: data ?? this.data,
      status: status ?? this.status,
      msg: msg ?? this.msg,
    );
  }

  @override
  String toString() {
    return 'StockAddScreenState(itemSuggestion: $itemSuggestion, data: $data, status: $status, msg: $msg)';
  }
}
