import 'dart:async';
import 'dart:io';

import 'package:admin_repository/admin_repository.dart';
import 'package:elkosh/general/shared/functions.dart';
import 'package:elkosh/general/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:models_repository/models_repository.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  ProductFormBloc() : super(ProductFormState.initial) {
    on<ProductFormNameChanged>(_onNameChanged);
    on<ProductFormDescChanged>(_onDescChanged);
    on<ProductFormPriceChanged>(_onPriceChanged);
    on<ProductFormQuantityChanged>(_onQuantityChanged);
    on<ProductFormUnitChanged>(_onUnitChanged);
    on<ProductFormUnitValChanged>(_onUnitValChanged);
    on<ProductFormImgChanged>(_onImgChanged);
    on<ProductAddFormSubmitted>(_onProductAddFormSubmitted);
    on<ProductFormPrepared>(_onProductFormPrepared);
    on<ProductEditFormSubmitted>(_onProductFormEditSubmitted);
    on<ProductFormResetRequested>(_onProductFormReset);
    on<ProductFormStatusResetRequested>(_onProductFormStatusReset);
    on<ProductAddDiscountFormSubmitted>(_onAddDiscountFormSubmitted);
  }

  FutureOr<void> _onNameChanged(ProductFormNameChanged event, emit) {
    final name = Name.dirty(event.name);
    emit(state.copyWith(
      name: name,
      inputStatus: state.productImg.path != '' &&
              Formz.validate([
                name,
                state.desc,
                state.price,
                state.quantity,
                state.unit,
                state.unitVal,
              ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onDescChanged(ProductFormDescChanged event, emit) {
    final desc = Desc.dirty(event.desc);
    emit(state.copyWith(
      desc: desc,
      inputStatus: state.productImg.path != '' &&
              Formz.validate([
                state.name,
                desc,
                state.price,
                state.quantity,
                state.unit,
                state.unitVal,
              ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onPriceChanged(ProductFormPriceChanged event, emit) {
    final price = Price.dirty(event.price);
    emit(state.copyWith(
      price: price,
      inputStatus: state.productImg.path != '' &&
              Formz.validate([
                state.name,
                state.desc,
                price,
                state.quantity,
                state.unit,
                state.unitVal,
              ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onQuantityChanged(ProductFormQuantityChanged event, emit) {
    final quantity = Quantity.dirty(event.quantity);
    emit(state.copyWith(
      quantity: quantity,
      inputStatus: state.productImg.path != '' &&
              Formz.validate([
                state.name,
                state.desc,
                state.price,
                quantity,
                state.unit,
                state.unitVal,
              ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onUnitChanged(ProductFormUnitChanged event, emit) {
    final unit = Unit.dirty(event.unit);
    emit(state.copyWith(
      unit: unit,
      inputStatus: state.productImg.path != '' &&
              Formz.validate([
                state.name,
                state.desc,
                state.price,
                state.quantity,
                unit,
                state.unitVal,
              ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onUnitValChanged(ProductFormUnitValChanged event, emit) {
    final unitVal = UnitValue.dirty(event.unitVal);
    emit(state.copyWith(
      unitVal: unitVal,
      inputStatus: state.productImg.path != '' &&
              Formz.validate([
                state.name,
                state.desc,
                state.price,
                state.quantity,
                state.unit,
                unitVal,
              ])
          ? FormInputStatus.valid
          : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onImgChanged(event, emit) async {
    final imageFile = await fetchImage();
    if (imageFile == null) {
      emit(state.copyWith(
        imgName: 'لم يتم اختيار صوره',
        inputStatus: FormInputStatus.invalid,
      ));
    } else {
      emit(state.copyWith(
        productImg: imageFile,
        isImgChanged: true,
        imgName: imageFile.path.split('/').last,
        inputStatus: imageFile.path != '' &&
                Formz.validate([
                  state.name,
                  state.desc,
                  state.price,
                  state.quantity,
                  state.unit,
                  state.unitVal,
                ])
            ? FormInputStatus.valid
            : FormInputStatus.invalid,
      ));
    }
  }

  Future<void> _onProductFormPrepared(ProductFormPrepared event, emit) async {
    try {
      emit(state.copyWith(
        id: event.product.id,
        submissionStatus: FormzSubmissionStatus.initial,
        name: Name.dirty(event.product.name),
        desc: Desc.dirty(event.product.desc),
        imgName: 'product_img.png',
        imgUrl: event.product.imgUrl,
        inputStatus: FormInputStatus.initial,
        price: Price.dirty(event.product.price),
        quantity: Quantity.dirty(event.product.quantity),
        unit: Unit.dirty(event.product.unit),
        unitVal: UnitValue.dirty(event.product.unitVal),
      ));
    } catch (e) {
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.initial));
    }
  }

  FutureOr<void> _onProductAddFormSubmitted(event, emit) async {
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
    final res = await sl.get<AdminRepository>().addProduct(
          name: state.name.value,
          desc: state.desc.value,
          price: state.price.value,
          quantity: state.quantity.value,
          unit: state.unit.value,
          unitVal: state.unitVal.value,
          imageFile: state.productImg,
        );

    res.fold((left) {
      emit(state.copyWith(
        errMsg: left.message,
        submissionStatus: FormzSubmissionStatus.failure,
      ));
    }, (right) {
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
    });
  }

  FutureOr<void> _onProductFormEditSubmitted(event, emit) async {
    try {
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
      final res = await sl.get<AdminRepository>().editProduct(
            id: state.id,
            name: state.name.value,
            desc: state.desc.value,
            isImgChanged: state.isImgChanged,
            originalImgUrl: state.imgUrl,
            imageFile: state.productImg,
            price: state.price.value,
            quantity: state.quantity.value,
            unit: state.unit.value,
            unitVal: state.unitVal.value,
          );
      res.fold((left) {
        emit(state.copyWith(
          errMsg: left.message,
          submissionStatus: FormzSubmissionStatus.failure,
        ));
      }, (right) {
        emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        submissionStatus: FormzSubmissionStatus.failure,
      ));
    }
  }

  Future<void> _onProductFormReset(event, emit) async {
    emit(ProductFormState.initial);
  }

  FutureOr<void> _onProductFormStatusReset(event, emit) {
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.initial));
  }

  FutureOr<void> _onAddDiscountFormSubmitted(
      ProductAddDiscountFormSubmitted event, emit) async {
    final res =
        await sl.get<AdminRepository>().addProductDiscount(state.price.value);
    res.fold(
        (l) => emit(state.copyWith(
              errMsg: l.message,
              submissionStatus: FormzSubmissionStatus.failure,
            )),
        (r) => emit(state.copyWith(
              submissionStatus: FormzSubmissionStatus.success,
            )));
  }
}
