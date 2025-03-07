part of 'ads_cubit.dart';

class AdsState extends Equatable {
  final List<Ad> ads;
  final String errMsg;
  final LoadStatus status;

  const AdsState({
    required this.ads,
    required this.errMsg,
    required this.status,
  });

  static AdsState initial = const AdsState(
    ads: [],
    errMsg: '',
    status: LoadStatus.initial,
  );

  AdsState copyWith({
    List<Ad>? ads,
    Ad? curAd,
    String? errMsg,
    LoadStatus? status,
  }) {
    return AdsState(
      ads: ads ?? this.ads,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }

  @override
  String toString() => '''AdsState ::
        Ads: ${ads.length}
        Status: ${status.name}
        Error: $errMsg
      ''';

  @override
  List<Object> get props => [ads, errMsg, status];
}
