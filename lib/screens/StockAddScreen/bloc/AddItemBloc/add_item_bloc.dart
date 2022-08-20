import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_item_event.dart';
part 'add_item_state.dart';

class AddItemBloc extends Bloc<AddItemEvent, AddItemState> {
  AddItemBloc() : super(const AddItemState()) {
    on<AddItemSubmit>(_onAddItemSubmit);
  }

  void _onAddItemSubmit(AddItemSubmit event, Emitter emit) {
    if (event.size.isEmpty) {
      emit(state.copyWith(
          status: AddItemStatus.sizeError, msg: "Size cannot be empty"));
      return;
    } else if (event.qty <= 0) {
      emit(state.copyWith(
          status: AddItemStatus.qtyError,
          msg: "Quantity should be more than zero"));
      return;
    }
    emit(state.copyWith(status: AddItemStatus.close));
  }
}
