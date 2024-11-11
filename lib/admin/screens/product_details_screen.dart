import 'package:elkosh/admin/controllers/product_form_bloc/product_form_bloc.dart';
import 'package:elkosh/admin/controllers/products_bloc/admin_products_bloc.dart';
import 'package:elkosh/admin/widgets/admin_image_item.dart';
import 'package:elkosh/general/shared/services/context_media.dart';
import 'package:elkosh/general/shared/widgets/auth_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdminProductDetailsScreen extends StatelessWidget {
  const AdminProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminProductsBloc, AdminProductsState>(
      builder: (context, state) {
        final curPrice = state.curProduct.updatedPrice == 0
            ? state.curProduct.price
            : state.curProduct.updatedPrice;
        return SafeArea(
          child: Scaffold(
            body: Skeletonizer(
              enabled: state.status == LoadingStatus.inProgress,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: const Color(0xffF2F3F2),
                    leading: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        CupertinoIcons.back,
                        size: 35,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  AdminImageItem(imageUrl: state.curProduct.imgUrl),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.curProduct.name,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${state.curProduct.unitVal} ${state.curProduct.unit}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            '$curPrice جنيه',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(10),
                          const Divider(),
                          const Gap(10),
                          const Text(
                            "الوصف",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            state.curProduct.desc,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const Gap(10),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: context.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<ProductFormBloc>()
                      .add(ProductFormPrepared(state.curProduct));
                  showModalBottomSheet(
                    context: context,
                    elevation: 20,
                    useSafeArea: true,
                    showDragHandle: true,
                    builder: (context) => Container(
                      height: 200,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: BlocBuilder<ProductFormBloc, ProductFormState>(
                        builder: (context, formState) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: InputFormField(
                                      labelText: 'السعر الحالى',
                                      isEnabled: false,
                                      initialValue:
                                          state.curProduct.price.toString(),
                                    ),
                                  ),
                                  const Gap(40),
                                  Expanded(
                                    child: InputFormField(
                                      labelText: 'السعر الجديد',
                                      inputType: TextInputType.number,
                                      errorText: formState.price.isPure
                                          ? null
                                          : formState.price.isNotValid
                                              ? formState.price.error
                                                  ?.toString()
                                              : null,
                                      onChange: (price) => context
                                          .read<ProductFormBloc>()
                                          .add(ProductFormPriceChanged(
                                              double.parse(price))),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(30),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<ProductFormBloc>()
                                      .add(ProductAddDiscountFormSubmitted());
                                  context.pop();
                                  context.read<AdminProductsBloc>().add(
                                      AdminProductUpdatingEvent(
                                          formState.price.value));
                                },
                                icon: const Icon(Icons.add_task_rounded),
                                label: const Text(
                                  'تأكيد الخصم',
                                  textScaler: TextScaler.linear(1.5),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const Text(
                  "أضف خصم",
                  textScaler: TextScaler.linear(1.6),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
