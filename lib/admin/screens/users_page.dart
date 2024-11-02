import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/admin/components/empty_users_view.dart';
import 'package:elkosh/admin/controllers/users_bloc/admin_users_bloc.dart';
import 'package:elkosh/admin/widgets/admin_user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminUsersBloc(),
      child: BlocConsumer<AdminUsersBloc, AdminUsersState>(
        listener: (context, state) {
          if (state.status == LoadingStatus.failure) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'حدث خطأ ما',
              text: 'حدث خطأ أثناء تحميل المستخدمين',
              borderRadius: 25,
              barrierDismissible: false,
              confirmBtnText: "أعد المحاولة",
              onConfirmBtnTap: () {
                context.pop();
                context.read<AdminUsersBloc>().add(AdminUsersLoadingEvent());
              },
            );
          }
        },
        builder: (context, state) => Skeletonizer(
          enabled: state.status == LoadingStatus.inProgress,
          child: ConditionalBuilder(
            condition: state.users.isEmpty,
            builder: (_) => const EmptyUsersView(),
            fallback: (_) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.users.length,
              itemBuilder: (_, i) => AdminUserItem(user: state.users[i]),
              separatorBuilder: (_, __) => const Divider(
                thickness: 0.5,
                color: Colors.black38,
              ),
              padding: const EdgeInsets.only(right: 16),
            ),
          ),
        ),
      ),
    );
  }
}
