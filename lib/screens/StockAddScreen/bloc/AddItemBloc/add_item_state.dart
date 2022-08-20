part of 'add_item_bloc.dart';

enum AddItemStatus { initial, close, sizeError, qtyError }

class AddItemState extends Equatable {
  const AddItemState({
    this.status = AddItemStatus.initial,
    this.size,
    this.qty,
    this.msg,
  });

  final String? size;
  final int? qty;
  final AddItemStatus status;
  final String? msg;

  @override
  List<Object?> get props => [size, qty, status, msg];

  AddItemState copyWith({
    String? size,
    int? qty,
    AddItemStatus? status,
    String? msg,
  }) {
    return AddItemState(
      size: size ?? this.size,
      qty: qty ?? this.qty,
      status: status ?? this.status,
      msg: msg ?? this.msg,
    );
  }
}
