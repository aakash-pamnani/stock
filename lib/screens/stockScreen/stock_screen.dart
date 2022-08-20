import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/screens/StockAddScreen/stock_add_screen.dart';

import '../../constants/extensions.dart';
import '../../constants/style.dart';
import '../../model/stock_model.dart';
import '../../repositories/database_repository.dart';
import '../../screens/StockDetailsScreen/stock_details_screen.dart';
import '../../screens/stockScreen/bloc/stock_screen_bloc.dart';
import '../../utils/utils.dart';
import '../LoginScreen/login_screen.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({
    Key? key,
    required this.category,
  }) : super(key: key);
  final String category;

  @override
  Widget build(BuildContext context) {
    StockScreenBloc bloc = StockScreenBloc(
        category: category,
        databaseRepository: context.read<DatabaseRepository>())
      ..add(StockScreenFetchData());
    return BlocProvider<StockScreenBloc>(
      create: (context) => bloc,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            push<StockModel>(
                    context: context, child: StockAddScreen(category: category))
                .then((value) {
              if (value != null) {
                bloc.add(StockScreenFetchData());
              }
            });
          },
          child: const Icon(Icons.add),
        ),
        body: NestedScrollView(
          body: BlocConsumer<StockScreenBloc, StockScreenState>(
            listener: (context, state) async {
              // push(
              //     context: context,
              //     child: BlocProvider.value(
              //       value: bloc,
              //       child: const StockAddScreen(),
              //     ))
              // .then((value) => context
              //     .read<StockScreenBloc>()
              //     .add(StockScreenFetchData(category: category)));
            },
            buildWhen: (prev, next) {
              return next.status == StockScreenStatus.loaded ||
                  next.status == StockScreenStatus.loading ||
                  next.status == StockScreenStatus.noData ||
                  next.status == StockScreenStatus.error;
            },
            builder: (context, state) {
              if (state.status == StockScreenStatus.loaded) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.data!.length,
                  itemBuilder: (context, index) {
                    return StockDetailTiles(
                      data: state.data![index],
                      index: index,
                      category: category,
                    );
                  },
                );
              } else if (state.status == StockScreenStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.status == StockScreenStatus.error) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              } else if (state.status == StockScreenStatus.noData) {
                return const Center(
                  child: Text("No Stock Found"),
                );
              } else {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
            },
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(category),
                forceElevated: true,
                pinned: true,
                floating: true,
                bottom: AppBar(
                    elevation: 0,
                    primary: false,
                    automaticallyImplyLeading: false,
                    toolbarHeight: kToolbarHeight + 10,
                    title: TextFormField(
                      autofocus: false,
                      onChanged: (text) {
                        bloc.add(StockScreenSearchData(query: text));
                      },
                      decoration: TextFieldDecoration
                          .roundedDecoration.withPadding
                          .copyWith(
                              fillColor: Colors.grey[100],
                              filled: true,
                              prefixIcon: const Icon(Icons.search),
                              hintText: "Search Stocks...",
                              alignLabelWithHint: false,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              label: const Text("Search Stocks...")),
                    )),
              )
            ];
          },
        ),
      ),
    );
  }
}

class StockDetailTiles extends StatelessWidget {
  const StockDetailTiles(
      {Key? key,
      required this.data,
      required this.index,
      required this.category})
      : super(key: key);

  final StockModel data;
  final int index;
  final String category;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () => push<StockModel>(
        context: context,
        child: StockDetailsScreen(
          data: data,
          category: category,
        ),
      ).then((value) {
        if (value != null) {
          context
              .read<StockScreenBloc>()
              .add(StockScreenUpdateData(index: index, data: value));
        }
      }),
      title: Text(data.itemName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            StockModel.getTotalItems(data.itemData).toString(),
            style: TextStyles.mediumText.blue,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "delete") {
                showMyDialog<bool>(context, const LoginScreen(), true)
                    .then((value) {
                  if (value ?? false) {
                    context
                        .read<StockScreenBloc>()
                        .add(StockScreenDelete(index: index));
                  }
                });
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    value: "delete",
                    child: Text(
                      "Delete",
                      style: TextStyles.mediumText.red,
                    ))
              ];
            },
          ),
        ],
      ),
    ));
  }
}
