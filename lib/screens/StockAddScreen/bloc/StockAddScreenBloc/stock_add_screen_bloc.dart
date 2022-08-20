import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../repositories/database_repository.dart';
import '../../../../model/stock_model.dart';

part 'stock_add_screen_event.dart';
part 'stock_add_screen_state.dart';

class StockAddScreenBloc
    extends Bloc<StockAddScreenEvent, StockAddScreenState> {
  final DatabaseRepository _databaseRepository;
  StockModel data;
  bool isUpdate;
  final String category;

  StockAddScreenBloc(
      {required DatabaseRepository databaseRepository,
      StockModel? updateData,
      required this.category})
      : _databaseRepository = databaseRepository,
        isUpdate = updateData != null,
        data = updateData ?? StockModel.empty(),
        super(StockAddScreenState(data: StockModel.empty())) {
    on<StockAddScreenAddNewItem>(_onAddItem);
    on<StockAddScreenSubmit>(_onSubmit);
    on<StockAddScreenRemoveItem>(_onRemoveItem);
    on<StockAddScreenFetchSuggestions>(_onFetchSuggestions);
    on<StockAddScreenIncrement>(_onIncrement);
    on<StockAddScreenDecrement>(_onDecrement);
    // on<StockAddScreenChangeCategory>(_onAddCategory);
    on<StockAddScreenCloseDialog>((event, emit) =>
        emit(state.copyWith(status: StockAddScreenStatus.closeDialog)));
  }

  // void _onAddCategory(StockAddScreenChangeCategory event, Emitter emit) {
  //   List<String> categories = state.categorySuggestion ?? [];

  //   if (!categories.contains(event.category)) {
  //     categories.add(event.category);
  //   }

  //   emit(state.copyWith(
  //     status: StockAddScreenStatus.editing,
  //     categorySuggestion: categories.toList(),
  //     data: state.data.copyWith(category: event.category),
  //   ));
  // }

  Future<void> _onSubmit(StockAddScreenSubmit event, Emitter emit) async {
    emit(state.copyWith(
        status: StockAddScreenStatus.loading, msg: "Loading..."));
    if (event.data.itemName.isEmpty) {
      emit(state.copyWith(status: StockAddScreenStatus.closeDialog));

      emit(state.copyWith(
          status: StockAddScreenStatus.error, msg: "Item Name Cant be Empty"));
    } else if (event.data.itemName.contains(RegExp(r'[~*/\[\]]'))) {
      emit(state.copyWith(status: StockAddScreenStatus.closeDialog));

      emit(state.copyWith(
          status: StockAddScreenStatus.error,
          msg: "Item Name should not contain ~,*,/,[ and ]"));
    } else if (event.data.itemData.isEmpty) {
      emit(state.copyWith(status: StockAddScreenStatus.closeDialog));
      emit(state.copyWith(
          status: StockAddScreenStatus.error, msg: "Item Data Cant Be Empty"));
    } else {
      if (isUpdate) {
        StockModel newData = StockModel(
            itemName: event.data.itemName,
            itemData: event.data.itemData,
            history: data.history
              ..addAll([
                "Updated Stock of ${event.data.itemName} qty:${getTotalItems(event.data.itemData)} at ${DateTime.now().toString().substring(0, 19)}"
              ]));
        await _databaseRepository.updateStock(state.data, newData, category);
        data = newData;
      } else {
        await _databaseRepository.addStock(
            StockModel(
                itemName: event.data.itemName,
                itemData: event.data.itemData,
                history: [
                  "Added new Stock of ${event.data.itemName} qty:${getTotalItems(event.data.itemData)} at ${DateTime.now().toString().substring(0, 19)}"
                ]),
            category);
      }
      emit(state.copyWith(status: StockAddScreenStatus.closeDialog));
      emit(state.copyWith(
          data: data,
          status: StockAddScreenStatus.sucess,
          msg: "Stock added succesfully"));
    }
  }

  int getTotalItems(List<ItemData> value) {
    int items = 0;
    for (var element in value) {
      items += element.quantity;
    }
    return items;
  }

  Future<void> _onFetchSuggestions(event, Emitter emit) async {
    emit(state.copyWith(
        status: StockAddScreenStatus.loading, msg: "Fetching Item Names..."));
    var items = await _databaseRepository.getItemNames();
    emit(state.copyWith(status: StockAddScreenStatus.closeDialog));
    // emit(state.copyWith(
    //     status: StockAddScreenStatus.loading,
    //     msg: "Fetching Category Names..."));
    // var categories = await _databaseRepository.getCategoryNames()
    //   ..add("");

    // emit(state.copyWith(status: StockAddScreenStatus.closeDialog));

    emit(state.copyWith(
      status: StockAddScreenStatus.initial,
      data: data..sortItemData(),
      itemSuggestion: items,
    ));
  }

  void _onAddItem(StockAddScreenAddNewItem event, Emitter emit) {
    if (event.size.isEmpty) {
      emit(state.copyWith(
          status: StockAddScreenStatus.error, msg: "Size cannot be empty"));
      return;
    } else if (event.qty <= 0) {
      emit(state.copyWith(
          status: StockAddScreenStatus.error,
          msg: "Quantity should be more than zero"));
      return;
    }
    var data = this.data.itemData.toList();
    data.add(ItemData(size: event.size, quantity: event.qty));

    this.data.itemData = data;

    emit(state.copyWith(
        status: StockAddScreenStatus.editing, data: this.data.copyWith()));
  }

  void _onRemoveItem(StockAddScreenRemoveItem event, Emitter emit) {
    var data = this.data.itemData.toList();
    data.removeAt(event.index);
    this.data.itemData = data;
    emit(state.copyWith(
        status: StockAddScreenStatus.editing, data: this.data.copyWith()));
  }

  _onIncrement(StockAddScreenIncrement event, emit) {
    data.itemData[event.index].quantity++;
    emit(state.copyWith(data: data.copyWith()));
  }

  _onDecrement(StockAddScreenDecrement event, emit) {
    data.itemData[event.index].quantity--;
    emit(state.copyWith(data: data.copyWith()));
  }
}
