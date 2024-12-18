part of 'ads_bloc.dart';

class AdsState extends Equatable {
  final List<Advertisment> ads;
  final Advertisment curAd;
  final String errMsg;
  final LoadingStatus status;

  const AdsState({
    required this.ads,
    required this.curAd,
    required this.errMsg,
    required this.status,
  });

  static AdsState initial = AdsState(
    ads: const [],
    curAd: Advertisment.empty,
    errMsg: '',
    status: LoadingStatus.initial,
  );

  AdsState copyWith({
    List<Advertisment>? ads,
    Advertisment? curAd,
    String? errMsg,
    LoadingStatus? status,
  }) {
    return AdsState(
      ads: ads ?? this.ads,
      curAd: curAd ?? this.curAd,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }

  @override
  String toString() =>
      'OffersState ::\nAds: ${ads.length}\nCurrent Ad: $curAd\nStatus: ${status.name}\nError: $errMsg';

  @override
  List<Object> get props => [ads, curAd, errMsg, status];
}
