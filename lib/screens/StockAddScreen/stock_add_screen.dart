import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/extensions.dart';
import '../../repositories/database_repository.dart';
import '../../screens/StockAddScreen/bloc/StockAddScreenBloc/stock_add_screen_bloc.dart';
import '../../screens/StockAddScreen/widgets/add_item_dialog.dart';
import '../../screens/StockAddScreen/widgets/item_list_tile.dart';
import '../../model/stock_model.dart';
import '../../utils/utils.dart';

import '../../constants/style.dart';

class StockAddScreen extends StatelessWidget {
  const StockAddScreen({Key? key, required this.category, this.data})
      : super(key: key);
  final String category;
  final StockModel? data;

  @override
  Widget build(BuildContext context) {
    StockAddScreenBloc bloc = StockAddScreenBloc(
        databaseRepository: context.read<DatabaseRepository>(),
        category: category,
        updateData: data?.copyWith())
      ..add(StockAddScreenFetchSuggestions());

    TextEditingController itemName = TextEditingController();
    List<TextEditingController> sizeController = [];
    List<TextEditingController> qtyController = [];

    return Scaffold(
      appBar: AppBar(title: const Text("Add Stock")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) => bloc,
          child: BlocConsumer<StockAddScreenBloc, StockAddScreenState>(
            listener: (context, state) {
              if (state.status == StockAddScreenStatus.error) {
                showScaffoldError(context, state.msg!);
              } else if (state.status == StockAddScreenStatus.closeDialog) {
                pop(context);
              } else if (state.status == StockAddScreenStatus.sucess) {
                showScaffoldSucess(context, state.msg ?? "");
                pop<StockModel>(context,result: state.data);
              } else if (state.status == StockAddScreenStatus.initial) {
                itemName.text = state.data.itemName;
              } else if (state.status == StockAddScreenStatus.loading) {
                showMyDialog(
                    context,
                    AlertDialog(
                      content: Row(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(state.msg ?? "")
                        ],
                      ),
                    ),
                    false);
              }
            },
            listenWhen: (prev, next) {
              return next.status == StockAddScreenStatus.error ||
                  next.status == StockAddScreenStatus.closeDialog ||
                  next.status == StockAddScreenStatus.initial ||
                  next.status == StockAddScreenStatus.sucess ||
                  next.status == StockAddScreenStatus.loading;
            },
            buildWhen: (prev, next) {
              return next.status == StockAddScreenStatus.initial ||
                  next.status == StockAddScreenStatus.editing;
            },
            builder: (context, state) {
              FocusManager.instance.primaryFocus?.unfocus();
              sizeController = state.data.itemData
                  .map<TextEditingController>(
                      (e) => TextEditingController(text: e.size))
                  .toList();
              qtyController = state.data.itemData
                  .map<TextEditingController>((e) => TextEditingController(
                      text: e.quantity == 0 ? "" : e.quantity.toString()))
                  .toList();

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Autocomplete<String>(
                      optionsBuilder: ((textEditingValue) {
                        return state.itemSuggestion
                                ?.where((element) =>
                                    element.startsWith(textEditingValue.text))
                                .toList() ??
                            [];
                      }),
                      fieldViewBuilder:
                          (context, controller, node, onFieldSubmitted) {
                        itemName = controller;
                        return TextFormField(
                            controller: controller,
                            textInputAction: TextInputAction.next,
                            focusNode: node,
                            autofocus: false,
                            decoration: TextFieldDecoration
                                .roundedDecoration.withPadding
                                .copyWith(label: const Text("Item Name")));
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Category : $category",
                          style: TextStyles.mediumText.bold,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        // DropdownButton<String>(
                        //   onChanged: (value) {
                        //     bloc.add(StockAddScreenChangeCategory(
                        //         category: value ?? ""));
                        //     category.text = value!;
                        //   },
                        //   value: state.data.category.isNotEmpty
                        //       ? state.data.category
                        //       : "",
                        //   items: (state.categorySuggestion ?? [])
                        //       .map<DropdownMenuItem<String>>((e) {
                        //     return DropdownMenuItem<String>(
                        //       value: e,
                        //       child: Text(e.isEmpty ? "NONE" : e),
                        //     );
                        //   }).toList(),
                        // optionsBuilder: ((textEditingValue) {
                        //   return state.categorySuggestion
                        //           ?.where((element) =>
                        //               element.startsWith(textEditingValue.text))
                        //           .toList() ??
                        //       [];
                        // }),
                        //   fieldViewBuilder:
                        //       (context, controller, node, onFieldSubmitted) {
                        //     category = controller;
                        //     return TextFormField(
                        //         focusNode: node,
                        //         onTap: () => category.text = "",
                        //         controller: category,
                        //         showCursor: false,
                        //         textInputAction: TextInputAction.next,
                        //         autofocus: false,
                        //         keyboardType: TextInputType.none,
                        //         decoration: TextFieldDecoration
                        //             .roundedDecoration.withPadding
                        //             .copyWith(
                        //           label: const Text("Category"),
                        //         ));
                        //   },
                        // ),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: MyColors.primaryColor,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Size", style: TextStyles.mediumText.white),
                          Text("Quantity", style: TextStyles.mediumText.white)
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ItemListView(data: state.data.itemData),
                    ElevatedButton(
                        onPressed: () {
                          bloc.add(StockAddScreenSubmit(
                              data: StockModel(
                                  itemName: itemName.text,
                                  
                                  itemData: List.generate(
                                      state.data.itemData.length,
                                      (index) => ItemData(
                                          size: sizeController[index].text,
                                          quantity: int.parse(
                                              qtyController[index].text.isEmpty
                                                  ? "0"
                                                  : qtyController[index]
                                                      .text))),
                                  history: [])));
                        },
                        child: const Text("Done"))
                  ]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ItemListView extends StatelessWidget {
  const ItemListView({Key? key, required this.data}) : super(key: key);

  final List<ItemData>? data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: (data!.length + 1),
        itemBuilder: ((context, index) {
          if (index == data!.length) {
            return ElevatedButton(
              onPressed: () async {
                showMyDialog(
                    context,
                    BlocProvider.value(
                      value: context.read<StockAddScreenBloc>(),
                      child: const AddNewItemDailog(),
                    ),
                    true);
              },
              style: ButtonStyles
                  .elevatedButtonHolo.withPadding.withBorder.noElevation,
              child: const Center(
                  child: Icon(
                Icons.add,
                color: Colors.blue,
              )),
            );
          }
          return ItemListTile(
            index: index,
            size: data![index].size,
            qty: data![index].quantity,
          );
        }));
  }
}
