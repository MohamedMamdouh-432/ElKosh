import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/seller/controllers/market_form_bloc/market_form_bloc.dart';
import 'package:elkosh/seller/controllers/markets_bloc/seller_markets_bloc.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:elkosh/shared/widgets/auth_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class AddMarketForm extends StatelessWidget {
  const AddMarketForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketFormBloc, MarketFormState>(
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
          context.read<MarketFormBloc>().add(MarketFormStatusResetRequested());
        } else if (state.submissionStatus.isSuccess) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'نجاح',
            text: 'تم اضافة المتجر بنجاح',
            borderRadius: 20,
            animType: QuickAlertAnimType.scale,
          );
          context.pop();
          context.read<MarketFormBloc>().add(MarketFormResetRequested());
          context
              .read<SellerMarketsBloc>()
              .add(const SellerMarketsLoadingEvent());
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: AppBar(
            title: const Text(
              "اضافة متجر جديد",
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
                    labelText: 'ألاسم',
                    errorText: state.name.isPure
                        ? null
                        : state.name.isNotValid
                            ? state.name.error?.toString()
                            : null,
                    onChange: (name) => context
                        .read<MarketFormBloc>()
                        .add(MarketFormNameChanged(name)),
                  ),
                  const Gap(10),
                  InputFormField(
                    labelText: 'الخط الساخن',
                    inputType: TextInputType.number,
                    errorText: state.hotline.isPure
                        ? null
                        : state.hotline.isNotValid
                            ? state.hotline.error?.toString()
                            : null,
                    onChange: (hotline) => context
                        .read<MarketFormBloc>()
                        .add(MarketFormHotlineChanged(hotline)),
                  ),
                  const Gap(10),
                  InputFormField(
                    labelText: 'عن المتجر',
                    errorText: state.desc.isPure
                        ? null
                        : state.desc.isNotValid
                            ? state.desc.error?.toString()
                            : null,
                    onChange: (desc) => context
                        .read<MarketFormBloc>()
                        .add(MarketFormDescChanged(desc)),
                  ),
                  const Gap(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: state.submissionStatus.isInProgress
                            ? null
                            : () {
                                showTimePicker(
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 6, minute: 0),
                                ).then((beginTime) {
                                  if (beginTime == null)
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      title: 'تنبيه',
                                      text: 'لم تقم بتحديد الوقت',
                                      borderRadius: 20,
                                      animType: QuickAlertAnimType.scale,
                                    );
                                  else
                                    context.read<MarketFormBloc>().add(
                                        MarketFormBeginTimeChanged(beginTime));
                                });
                              },
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: Text(
                          'بداية العمل',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${toArNumber(state.beginTime.hour.toString().padLeft(2, '0'))}:${toArNumber(state.beginTime.minute.toString().padLeft(2, '0'))} ${toArabicPeriod(state.beginTime.period.name)}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: state.submissionStatus.isInProgress
                            ? null
                            : () {
                                showTimePicker(
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 12, minute: 0),
                                ).then((value) {
                                  if (value == null)
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      title: 'تنبيه',
                                      text: 'لم تقم بتحديد الوقت',
                                      borderRadius: 20,
                                      animType: QuickAlertAnimType.scale,
                                    );
                                  else
                                    context
                                        .read<MarketFormBloc>()
                                        .add(MarketFormEndTimeChanged(value));
                                });
                              },
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: Text(
                          'انتهاء العمل',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Gap(5),
                      Text(
                        "${toArNumber(state.endTime.hour.toString().padLeft(2, '0'))}:${toArNumber(state.endTime.minute.toString().padLeft(2, '0'))} ${toArabicPeriod(state.endTime.period.name)}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(30),
                  SizedBox(
                    width: context.width * 0.8,
                    child: ElevatedButton.icon(
                      onPressed: state.submissionStatus.isInProgress
                          ? null
                          : () => context
                              .read<MarketFormBloc>()
                              .add(MarketFormImgChanged()),
                      icon: const Icon(Icons.image_outlined),
                      label: Text(
                        'اختر صورة للمتجر',
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
                  const Gap(30),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: context.width * 0.8,
                    child: ElevatedButton.icon(
                      onPressed: state.submissionStatus.isInProgress
                          ? null
                          : () async {
                              context
                                  .push(RouteManager.marketLocationPickerRoute);
                              SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.edgeToEdge);
                            },
                      icon: const Icon(Icons.location_on),
                      label: Text(
                        'قم بتحديد موقع المتجر',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    state.location.address,
                    softWrap: true,
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 12),
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
                          .read<MarketFormBloc>()
                          .add(MarketAddFormSubmitted());
                    },
              child: state.submissionStatus.isInProgress
                  ? const LinearProgressIndicator()
                  : const Text(
                      'إضافة المتجر',
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
