import 'package:elkosh/admin/controllers/category_bloc/admin_category_bloc.dart';
import 'package:elkosh/admin/widgets/admin_category_item.dart';
import 'package:elkosh/user/home/controllers/categorys_bloc/categorys_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddCategoryForm extends StatelessWidget {
  const AddCategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCategoryBloc, AdminCategoryState>(
      listener: (context, state) {
        if (state.addingStatus == AddingStatus.failure) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'خطأ',
            text: state.errMsg,
            borderRadius: 20,
            animType: QuickAlertAnimType.scale,
          );
          context.read<AdminCategoryBloc>().add(AdminCategoryResetEvent());
        } else if (state.addingStatus == AddingStatus.success) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'نجاح',
            text: 'تم اضافة الصنف بنجاح',
            borderRadius: 20,
            animType: QuickAlertAnimType.scale,
          );
          context.pop();
          context.read<AdminCategoryBloc>().add(AdminCategoryResetEvent());
          context.read<CategorysBloc>().add(const CategorysLoadingEvent());
          context.read<AdminCategoryBloc>().add(AdminCategorysLoadingEvent());
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: AppBar(
            title: const Text(
              "اضافة صنف جديد",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: state.addingStatus == AddingStatus.inProgress,
            child: GridView.builder(
              itemCount: cats.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 7 / 12,
              ),
              itemBuilder: (_, i) =>
                  AdminCategoryItem(cats.entries.elementAt(i)),
            ),
          ),
        );
      },
    );
  }
}
