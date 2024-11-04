part of 'offers_bloc.dart';

class OffersState extends Equatable {
  final List<Offer> offers;
  final Offer curOffer;
  final String errMsg;
  final LoadingStatus status;

  const OffersState({
    required this.offers,
    required this.curOffer,
    required this.errMsg,
    required this.status,
  });

  static OffersState initial = OffersState(
    offers: const [],
    curOffer: Offer.empty,
    errMsg: '',
    status: LoadingStatus.initial,
  );

  OffersState copyWith({
    List<Offer>? offers,
    Offer? curOffer,
    String? errMsg,
    LoadingStatus? status,
  }) {
    return OffersState(
      offers: offers ?? this.offers,
      curOffer: curOffer ?? this.curOffer,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }

  @override
  String toString() =>
      'OffersState ::\nOffers: ${offers.length}\nCurrent Offer: $curOffer\nStatus: ${status.name}\nError: $errMsg';

  @override
  List<Object> get props => [offers, curOffer, errMsg, status];
}
