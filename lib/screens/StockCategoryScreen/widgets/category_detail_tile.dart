import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/constants/extensions.dart';
import 'package:stock/screens/AddNewCategoryScreen/add_new_category_dialog.dart';
import 'package:stock/screens/LoginScreen/login_screen.dart';
import 'package:stock/screens/StockCategoryScreen/bloc/category_screen_bloc.dart';
import 'package:stock/screens/stockScreen/stock_screen.dart';
import 'package:stock/utils/utils.dart';

import '../../../constants/style.dart';

class CategoryDetailTile extends StatelessWidget {
  const CategoryDetailTile({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          push(context: context, child: StockScreen(category: name));
        },
        title: Text(
          name,
          style: TextStyles.mediumText.bold.black,
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "delete") {
              showMyDialog<bool>(context, const LoginScreen(), true)
                  .then((value) {
                if (value ?? false) {
                  context
                      .read<CategoryScreenBloc>()
                      .add(CategoryScreenDelete(name: name));
                }
              });
            } else if (value == "edit") {
              showMyDialog<bool>(
                      context,
                      AddNewCategoryDailog(
                        name: name,
                      ),
                      true)
                  .then((value) {
                if (value ?? false) {
                  context
                      .read<CategoryScreenBloc>()
                      .add(CategoryScreenFetchData());
                }
              });
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                  value: "edit",
                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      Text(
                        "Edit",
                        style: TextStyles.mediumText.blue,
                      ),
                    ],
                  )),
              PopupMenuItem(
                  value: "delete",
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      Text(
                        "Delete",
                        style: TextStyles.mediumText.red,
                      ),
                    ],
                  ))
            ];
          },
        ),
      ),
    );
  }
}
