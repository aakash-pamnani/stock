part of 'stock_add_screen_bloc.dart';

abstract class StockAddScreenEvent extends Equatable {
  const StockAddScreenEvent();
}

class StockAddScreenAddNewItem extends StockAddScreenEvent {
  final String size;
  final int qty;
  const StockAddScreenAddNewItem({
    required this.size,
    required this.qty,
  });

  @override
  List<Object?> get props => [size, qty];
}

class StockAddScreenFetchSuggestions extends StockAddScreenEvent {
  @override
  List<Object?> get props => [];
}

class StockAddScreenRemoveItem extends StockAddScreenEvent {
  final int index;
  
  const StockAddScreenRemoveItem({
    required this.index,
    
  });

  @override
  List<Object?> get props => [index];

  @override
  String toString() => 'StockAddScreenRemoveItem(index: $index)';
}

class StockAddScreenSubmit extends StockAddScreenEvent {
  final StockModel data;
  const StockAddScreenSubmit({
    required this.data,
  });

  @override
  List<Object?> get props => [data];

  @override
  String toString() => 'StockAddScreenSubmit(data: $data)';
}

class StockAddScreenCloseDialog extends StockAddScreenEvent {
  @override
  List<Object?> get props => [];
}

// class StockAddScreenChangeCategory extends StockAddScreenEvent {
//   final String category;
//   const StockAddScreenChangeCategory({
//     required this.category,
//   });
  
//   @override
//   List<Object?> get props => [category];

//   @override
//   String toString() => 'StockAddScreenAddNewCategory(category: $category)';
// }







class StockAddScreenIncrement extends StockAddScreenEvent {
  final int index;
  const StockAddScreenIncrement({
    required this.index,
  });

  @override
  List<Object?> get props => [index];

  @override
  String toString() => 'StockAddScreenIncrement(index: $index)';
}

class StockAddScreenDecrement extends StockAddScreenEvent {
  final int index;
  const StockAddScreenDecrement({
    required this.index,
  });

  @override
  List<Object?> get props => [index];

  @override
  String toString() => 'StockAddScreenDecrement(index: $index)';
}



