import 'package:elkosh/admin/controllers/users_bloc/admin_users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AdminUserItem extends StatelessWidget {
  final User user;
  const AdminUserItem({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: user.active ? 1 : 0.45,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              child: Center(
                child: Text(
                  user.name[0].toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.phone,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () => user.active
                  ? QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: 'هل تريد توقيف هذا المستخدم ؟',
                      borderRadius: 25,
                      barrierDismissible: false,
                      showConfirmBtn: true,
                      showCancelBtn: true,
                      confirmBtnText: 'توقيف',
                      onConfirmBtnTap: () {
                        context.pop();
                        context
                            .read<AdminUsersBloc>()
                            .add(AdminUserBlockingEvent(user.id));
                      },
                      confirmBtnColor: Colors.deepPurple,
                      cancelBtnText: 'رجوع',
                      onCancelBtnTap: () => context.pop(),
                    )
                  : QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: 'هل تريد الغاء توقيف هذا المستخدم ؟',
                      borderRadius: 25,
                      barrierDismissible: false,
                      showConfirmBtn: true,
                      showCancelBtn: true,
                      confirmBtnText: 'الغاء',
                      onConfirmBtnTap: () {
                        context.pop();
                        context
                            .read<AdminUsersBloc>()
                            .add(AdminUserUnBlockingEvent(user.id));
                      },
                      confirmBtnColor: Colors.deepPurple,
                      cancelBtnText: 'رجوع',
                      onCancelBtnTap: () => context.pop(),
                    ),
              icon: Icon(
                user.active ? Icons.lock : Icons.lock_open,
                size: 30.sp,
                color: Colors.deepPurple.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
