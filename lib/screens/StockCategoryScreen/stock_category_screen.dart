import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/screens/AddNewCategoryScreen/add_new_category_dialog.dart';
import 'package:stock/screens/StockCategoryScreen/widgets/category_detail_tile.dart';

import '../../repositories/database_repository.dart';
import '../../utils/utils.dart';
import 'bloc/category_screen_bloc.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CategoryScreenBloc bloc = CategoryScreenBloc(
        databaseRepository: context.read<DatabaseRepository>())
      ..add(CategoryScreenFetchData());
    return BlocProvider<CategoryScreenBloc>(
      create: (context) => bloc,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showMyDialog(context, const AddNewCategoryDailog(), true)
                .then((value) {
              if (value != null) bloc.add(CategoryScreenFetchData());
            });
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("Category"),
        ),
        body: BlocBuilder<CategoryScreenBloc, CategoryScreenState>(
          buildWhen: (prev, next) {
            return next.status == CategoryScreenStatus.loaded ||
                next.status == CategoryScreenStatus.loading ||
                next.status == CategoryScreenStatus.noData ||
                next.status == CategoryScreenStatus.error;
          },
          builder: (context, state) {
            if (state.status == CategoryScreenStatus.loaded) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: state.data!.length,
                itemBuilder: (context, index) {
                  return CategoryDetailTile(
                    name: state.data![index],
                  );
                },
              );
            } else if (state.status == CategoryScreenStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == CategoryScreenStatus.error) {
              return const Center(
                child: Text("Something went wrong"),
              );
            } else if (state.status == CategoryScreenStatus.noData) {
              return const Center(
                child: Text("No Data Found"),
              );
            } else {
              return const Center(
                child: Text("Something went wrong"),
              );
            }
          },
        ),
      ),
    );
  }
}
