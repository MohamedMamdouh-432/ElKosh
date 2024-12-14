import 'dart:developer';

import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/settings/bloc/profile_bloc.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:models_repository/models_repository.dart';

class DeliveryLocationPickerScreen extends StatelessWidget {
  const DeliveryLocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return Scaffold(
      body: FlutterLocationPicker(
        // general
        initZoom: 12,
        mapLanguage: 'ar',
        trackMyPosition: true,
        initPosition: const LatLong(23, 89),
        // selected location button
        selectLocationButtonWidth: context.width * 0.8,
        selectLocationButtonText: 'تحديد الموقع الحالى',
        selectLocationButtonLeadingIcon: const Icon(
          Icons.location_on,
          size: 28,
        ),
        selectLocationButtonStyle: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(ColorManager.primary.withOpacity(0.8)),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          elevation: const WidgetStatePropertyAll(15),
        ),
        // selectedLocationButtonTextstyle: TextStyle(
        //   fontSize: 15.sp,
        //   fontWeight: FontWeight.bold,
        // ),
        // search bar
        searchBarHintText: 'ابحث عن موقع التوصيل',
        searchbarBorderRadius: BorderRadius.circular(20),
        searchbarInputBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        searchBarHintColor: Colors.black54,
        searchBarTextColor: Colors.deepOrange,
        searchBarBackgroundColor: Colors.grey.shade200,
        // other buttons
        locationButtonBackgroundColor: ColorManager.primary.withOpacity(0.8),
        zoomButtonsBackgroundColor: ColorManager.primary.withOpacity(0.8),
        locationButtonsColor: Colors.grey.shade300,
        zoomButtonsColor: Colors.grey.shade300,
        markerIcon: Icon(
          Icons.location_on,
          size: 50.sp,
          color: ColorManager.primary,
        ),
        showCurrentLocationPointer: false,
        onError: (e) => log(e.toString()),
        onPicked: (pickedData) {
          final location = Location.fromMapPicker(
            pickedData.latLong.latitude,
            pickedData.latLong.longitude,
            getAddress(pickedData.addressData),
          );
          final profileState = BlocProvider.of<ProfileBloc>(context).state;
          context.read<CartBloc>().add(CartPlaceOrderEvent(
                profileState.user,
                location,
              ));
          context.pop();
          context.pop();
        },
      ),
    );
  }
}
