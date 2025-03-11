import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/core/services/functions.dart';
import 'package:elkosh/core/theme/themes.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/repos/submodels/submodels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geodesy/geodesy.dart';
import 'package:go_router/go_router.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class DeliveryLocationPickerScreen extends StatelessWidget {
  DeliveryLocationPickerScreen({super.key});

  final Geodesy geodesy = Geodesy(); // ✅ Create a geodesy instance

// Define the polygon for Dessouq & Mahallet Dyay
  final List<LatLng> allowedArea = [
    const LatLng(31.07260724788931, 30.726538054796629), // Point 1
    const LatLng(31.07030987075852, 30.722160689703298), // Point 2
    const LatLng(31.04054266966147, 30.726012011563757), // Point 3
    const LatLng(31.02479960431465, 30.719769764598176), // Point 4
    const LatLng(31.02022735590357, 30.722776930641807), // Point 5
    const LatLng(31.014321980162496, 30.730394381960235), // Point 6
    const LatLng(31.010954005306676, 30.742030414736846), // Point 7
    const LatLng(31.044133762797884, 30.768804414381712), // Point 8
    const LatLng(31.0711364629584, 30.735888346204142), // Point 9
    const LatLng(31.07260724788931, 30.726538054796629), // Point 10
  ];

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 247, 234, 250),
            Color.fromARGB(255, 250, 240, 236),
            Color.fromARGB(255, 235, 244, 251),
            Color.fromARGB(255, 246, 237, 233),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FlutterLocationPicker(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=${Constants.mapboxkey}",
          // general
          initZoom: 12,

          mapLanguage: 'ar',
          trackMyPosition: true,
          initPosition: const LatLong(31.033110408222704, 30.73117720658826),
          // selected location button
          selectLocationButtonWidth: context.width * 0.8,
          selectLocationButtonText: 'تحديد الموقع الحالى',
          selectLocationButtonLeadingIcon: const Icon(
            Icons.location_on,
            size: 28,
          ),

          selectLocationButtonStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
                ColorManager.primary.withValues(alpha: 0.9)),
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
          locationButtonBackgroundColor:
              ColorManager.primary.withValues(alpha: 0.9),
          zoomButtonsBackgroundColor:
              ColorManager.primary.withValues(alpha: 0.9),
          locationButtonsColor: Colors.grey.shade300,
          zoomButtonsColor: Colors.grey.shade300,
          markerIcon: Icon(
            Icons.location_on,
            size: 50.sp,
            color: ColorManager.primary,
          ),
          showCurrentLocationPointer: false,
          onError: (e) => Logger.error('Cart Delivery Location Picker: $e'),

          onPicked: (pickedData) {
            final double lat = pickedData.latLong.latitude;
            final double lng = pickedData.latLong.longitude;
            final LatLng selectedLocation = LatLng(lat, lng);

            // ✅ Check if the point is inside the polygon using Geodesy
            bool isInside =
                geodesy.isGeoPointInPolygon(selectedLocation, allowedArea);

            if (isInside) {
              final location = Location.fromMapPicker(
                lat,
                lng,
                getAddress(pickedData.addressData),
              );
              context.read<CartCubit>().placeOrder(location);
              context.pop();
              context.pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                      '🚫 الرجاء اختيار موقع داخل نطاق التوصيل',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.green),
              );
            }
          },
        ),
      ),
    );
  }
}
