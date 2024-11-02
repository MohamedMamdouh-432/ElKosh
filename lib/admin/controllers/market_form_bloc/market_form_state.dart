part of 'market_form_bloc.dart';

class MarketFormState extends Equatable {
  final String id;
  final Name name;
  final Hotline hotline;
  final Desc desc;
  final File marketImg;
  final TimeOfDay beginTime;
  final TimeOfDay endTime;
  final Location location;
  final bool isImgChanged;
  final FormInputStatus inputStatus;
  final FormzSubmissionStatus submissionStatus;
  final String errMsg;
  final String imgName;
  final String imgUrl;
  final bool active;

  const MarketFormState({
    required this.id,
    required this.submissionStatus,
    required this.name,
    required this.hotline,
    required this.desc,
    required this.beginTime,
    required this.endTime,
    required this.location,
    required this.isImgChanged,
    required this.marketImg,
    required this.errMsg,
    required this.imgName,
    required this.inputStatus,
    required this.imgUrl,
    required this.active,
  });

  static MarketFormState initial = MarketFormState(
    id: '',
    isImgChanged: false,
    name: const Name.pure(),
    hotline: const Hotline.pure(),
    desc: const Desc.pure(),
    beginTime: const TimeOfDay(hour: 6, minute: 0),
    endTime: const TimeOfDay(hour: 20, minute: 0),
    location: Location.empty,
    marketImg: File(''),
    errMsg: '',
    imgName: 'لم يتم اختيار صوره',
    imgUrl: '',
    inputStatus: FormInputStatus.initial,
    submissionStatus: FormzSubmissionStatus.initial,
    active: false,
  );

  MarketFormState copyWith(
      {String? id,
      FormzSubmissionStatus? submissionStatus,
      Name? name,
      Hotline? hotline,
      Desc? desc,
      TimeOfDay? beginTime,
      TimeOfDay? endTime,
      Location? location,
      bool? isImgChanged,
      String? errMsg,
      String? imgUrl,
      String? imgName,
      FormInputStatus? inputStatus,
      File? marketImg,
      bool? active}) {
    return MarketFormState(
        id: id ?? this.id,
        submissionStatus: submissionStatus ?? this.submissionStatus,
        name: name ?? this.name,
        hotline: hotline ?? this.hotline,
        desc: desc ?? this.desc,
        beginTime: beginTime ?? this.beginTime,
        imgUrl: imgUrl ?? this.imgUrl,
        endTime: endTime ?? this.endTime,
        location: location ?? this.location,
        isImgChanged: isImgChanged ?? this.isImgChanged,
        errMsg: errMsg ?? this.errMsg,
        imgName: imgName ?? this.imgName,
        inputStatus: inputStatus ?? this.inputStatus,
        marketImg: marketImg ?? this.marketImg,
        active: active ?? this.active);
  }

  @override
  String toString() =>
      "Market Form State::\nInput Status: ${inputStatus.name}\nSubmission Status: ${submissionStatus.name}\nName: ${name.value}\nHotline: ${hotline.value}\nDescription: ${desc.value}\nActive: $active\nBeginTime: $beginTime\nEndTime: $endTime\nAddress: ${location.address}\nIsImgChanged: $isImgChanged\nMarketImg: $imgName\nError: $errMsg";

  @override
  List<Object> get props => [
        submissionStatus,
        name,
        hotline,
        imgUrl,
        desc,
        beginTime,
        endTime,
        location,
        id,
        isImgChanged,
        marketImg,
        errMsg,
        imgName,
        inputStatus,
        active,
      ];
}
