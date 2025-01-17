part of 'ad_details_bloc.dart';

class AdDetailsState extends Equatable {
  final Ad ad;
  final LoadStatus status;
  final String errMsg;

  const AdDetailsState({
    required this.ad,
    required this.status,
    required this.errMsg,
  });

  static AdDetailsState initial = AdDetailsState(
    ad: Ad.empty,
    errMsg: '',
    status: LoadStatus.initial,
  );

  AdDetailsState copyWith({
    Ad? ad,
    LoadStatus? status,
    String? errMsg,
  }) {
    return AdDetailsState(
      ad: ad ?? this.ad,
      status: status ?? this.status,
      errMsg: errMsg ?? this.errMsg,
    );
  }

  @override
  String toString() => '''
    Ad: ${ad.title}
    Status: ${status.name}
    Error: $errMsg
  ''';

  @override
  List<Object> get props => [
        ad,
        status,
        errMsg,
      ];
}
