import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/constants/extensions.dart';
import 'package:stock/repositories/database_repository.dart';

import '../../constants/style.dart';
import '../../utils/utils.dart';
import './AddCategoryBloc/add_category_bloc.dart';

class AddNewCategoryDailog extends StatelessWidget {
  const AddNewCategoryDailog({
    Key? key,
    this.name,
  }) : super(key: key);
  final String? name;
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: name);
    return BlocProvider(
      create: (context) =>
          AddCategoryBloc(database: context.read<DatabaseRepository>()),
      child: AlertDialog(
        title: Text(name != null ? "Update Category" : "Add New Category"),
        content: BlocConsumer<AddCategoryBloc, AddCategoryState>(
          listener: (context, state) {
            if (state.status == AddCategoryStatus.close) {
              pop<bool>(context, result: true);
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: TextFieldDecoration.roundedDecoration.withPadding
                      .copyWith(
                          hintText: "Category Name",
                          errorText: state.status == AddCategoryStatus.error
                              ? state.msg
                              : null),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (name == null) {
                        context
                            .read<AddCategoryBloc>()
                            .add(AddCategorySubmit(name: controller.text));
                      } else {
                        context.read<AddCategoryBloc>().add(AddCategoryUpdate(
                            oldName: name!, newName: controller.text));
                      }
                    },
                    child: state.status == AddCategoryStatus.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                        : Text(name != null ? "Update" : "Add"))
              ],
            );
          },
        ),
      ),
    );
  }
}
