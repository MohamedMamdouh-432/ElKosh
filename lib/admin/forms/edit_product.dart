import 'package:elkosh/admin/controllers/product_form_bloc/product_form_bloc.dart';
import 'package:elkosh/admin/controllers/products_bloc/admin_products_bloc.dart';
import 'package:elkosh/general/shared/services/context_media.dart';
import 'package:elkosh/general/shared/widgets/auth_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EditProductForm extends StatelessWidget {
  const EditProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductFormBloc, ProductFormState>(
      listener: (context, state) {
        if (state.submissionStatus.isFailure) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'خطأ',
            text: state.errMsg,
            borderRadius: 20,
            animType: QuickAlertAnimType.scale,
          );
          context
              .read<ProductFormBloc>()
              .add(ProductFormStatusResetRequested());
        } else if (state.submissionStatus.isSuccess) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'نجاح',
            text: 'تم تعديل بيانات المنتج بنجاح',
            borderRadius: 20,
            animType: QuickAlertAnimType.scale,
          );
          context.pop();
          context.read<ProductFormBloc>().add(ProductFormResetRequested());
          context.read<AdminProductsBloc>().add(AdminProductsLoadingEvent());
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: AppBar(
            title: const Text(
              "تعديل بيانات المنتج",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: state.submissionStatus.isInProgress,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Gap(10),
                  InputFormField(
                    labelText: 'الأسم',
                    initialValue: state.name.value,
                    errorText: state.name.isPure
                        ? null
                        : state.name.isNotValid
                            ? state.name.error?.toString()
                            : null,
                    onChange: (name) => context
                        .read<ProductFormBloc>()
                        .add(ProductFormNameChanged(name)),
                  ),
                  const Gap(10),
                  InputFormField(
                    labelText: 'عن المنتج',
                    initialValue: state.desc.value,
                    errorText: state.desc.isPure
                        ? null
                        : state.desc.isNotValid
                            ? state.desc.error?.toString()
                            : null,
                    onChange: (desc) => context
                        .read<ProductFormBloc>()
                        .add(ProductFormDescChanged(desc)),
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40.h,
                          child: InputFormField(
                            labelText: 'قيمة الوحدة',
                            inputType: TextInputType.number,
                            initialValue: state.unitVal.value.toString(),
                            errorText: state.unitVal.isPure
                                ? null
                                : state.unitVal.isNotValid
                                    ? state.unitVal.error?.toString()
                                    : null,
                            onChange: (unitVal) => context
                                .read<ProductFormBloc>()
                                .add(ProductFormUnitValChanged(
                                    double.parse(unitVal))),
                          ),
                        ),
                      ),
                      const Gap(40),
                      Expanded(
                        child: DropdownButton<String>(
                          value: state.unit.value,
                          elevation: 20,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight: 200.h,
                          underline: Container(
                            height: 1,
                            color: Colors.black,
                          ),
                          onChanged: (unit) => context
                              .read<ProductFormBloc>()
                              .add(ProductFormUnitChanged(unit!)),
                          items: units
                              .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  InputFormField(
                    labelText: 'السعر',
                    inputType: TextInputType.number,
                    initialValue: state.price.value.toString(),
                    errorText: state.price.isPure
                        ? null
                        : state.price.isNotValid
                            ? state.price.error?.toString()
                            : null,
                    onChange: (price) => context
                        .read<ProductFormBloc>()
                        .add(ProductFormPriceChanged(double.parse(price))),
                  ),
                  const Gap(10),
                  InputFormField(
                      labelText: 'الكمية الموجوده',
                      inputType: TextInputType.number,
                      initialValue: state.quantity.value.toString(),
                      errorText: state.quantity.isPure
                          ? null
                          : state.quantity.isNotValid
                              ? state.quantity.error?.toString()
                              : null,
                      onChange: (quantity) => context
                          .read<ProductFormBloc>()
                          .add(ProductFormQuantityChanged(
                              double.parse(quantity)))),
                  const Gap(30),
                  SizedBox(
                    width: context.width * 0.8,
                    child: ElevatedButton.icon(
                      onPressed: state.submissionStatus.isInProgress
                          ? null
                          : () => context
                              .read<ProductFormBloc>()
                              .add(ProductFormImgChanged()),
                      icon: const Icon(Icons.image_outlined),
                      label: Text(
                        'اختر صورة للمنتج',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    state.imgName,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: SizedBox(
            width: context.width * 0.8,
            child: ElevatedButton(
              onPressed: state.inputStatus == FormInputStatus.invalid ||
                      state.inputStatus == FormInputStatus.initial
                  ? null
                  : () {
                      context
                          .read<ProductFormBloc>()
                          .add(ProductAddFormSubmitted());
                    },
              child: state.submissionStatus.isInProgress
                  ? const LinearProgressIndicator()
                  : const Text(
                      'تعديل المنتج',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
