part of 'add_item_bloc.dart';

abstract class AddItemEvent extends Equatable {
  const AddItemEvent();


}

class AddItemSubmit extends AddItemEvent {
  final String size;
  final int qty;
  const AddItemSubmit({
    required this.size,
    required this.qty,
  });
  
  @override
  List<Object?> get props => [size,qty];
}
