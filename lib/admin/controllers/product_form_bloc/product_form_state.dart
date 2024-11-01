part of 'product_form_bloc.dart';

class ProductFormState extends Equatable {
  final String id;
  final Name name;
  final Desc desc;
  final Price price;
  final Unit unit;
  final UnitValue unitVal;
  final Quantity quantity;
  final File productImg;
  final bool isImgChanged;
  final FormInputStatus inputStatus;
  final FormzSubmissionStatus submissionStatus;
  final String errMsg;
  final String imgName;
  final String imgUrl;

  const ProductFormState({
    required this.id,
    required this.name,
    required this.desc,
    required this.productImg,
    required this.isImgChanged,
    required this.inputStatus,
    required this.submissionStatus,
    required this.errMsg,
    required this.imgName,
    required this.imgUrl,
    required this.price,
    required this.unit,
    required this.unitVal,
    required this.quantity,
  });

  static ProductFormState initial = ProductFormState(
    id: '',
    isImgChanged: false,
    name: const Name.pure(),
    desc: const Desc.pure(),
    productImg: File(''),
    errMsg: '',
    imgName: 'لم يتم اختيار صوره',
    imgUrl: '',
    inputStatus: FormInputStatus.initial,
    submissionStatus: FormzSubmissionStatus.initial,
    price: const Price.pure(),
    unit: const Unit.pure(),
    unitVal: const UnitValue.pure(),
    quantity: const Quantity.pure(),
  );

  ProductFormState copyWith({
    String? id,
    Name? name,
    Desc? desc,
    File? productImg,
    bool? isImgChanged,
    FormInputStatus? inputStatus,
    FormzSubmissionStatus? submissionStatus,
    String? errMsg,
    String? imgName,
    String? imgUrl,
    Price? price,
    Unit? unit,
    UnitValue? unitVal,
    Quantity? quantity,
  }) {
    return ProductFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      productImg: productImg ?? this.productImg,
      isImgChanged: isImgChanged ?? this.isImgChanged,
      inputStatus: inputStatus ?? this.inputStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errMsg: errMsg ?? this.errMsg,
      imgName: imgName ?? this.imgName,
      imgUrl: imgUrl ?? this.imgUrl,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      unitVal: unitVal ?? this.unitVal,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() =>
      "Product Form State::\nInput Status: ${inputStatus.name}\nSubmission Status: ${submissionStatus.name}\nName: ${name.value}\nDescription: ${desc.value}\nPrice: ${price.value}\nUnit: ${unit.value}\nUnit Val: ${unitVal.value}\nQuantity: ${quantity.value}\nIsImgChanged: $isImgChanged\nProductImg: $imgName\nError: $errMsg";

  @override
  List<Object> get props {
    return [
      id,
      name,
      desc,
      productImg,
      isImgChanged,
      inputStatus,
      submissionStatus,
      errMsg,
      imgName,
      imgUrl,
      price,
      unit,
      unitVal,
      quantity,
    ];
  }
}
