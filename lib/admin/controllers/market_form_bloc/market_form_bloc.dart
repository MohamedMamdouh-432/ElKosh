import 'dart:async';
import 'dart:io';

import 'package:admin_repository/admin_repository.dart';
import 'package:elkosh/general/shared/functions.dart';
import 'package:elkosh/general/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:models_repository/models_repository.dart';

part 'market_form_event.dart';
part 'market_form_state.dart';

class MarketFormBloc extends Bloc<MarketFormEvent, MarketFormState> {
  MarketFormBloc() : super(MarketFormState.initial) {
    on<MarketFormNameChanged>(_onNameChanged);
    on<MarketFormHotlineChanged>(_onHotlineChanged);
    on<MarketFormDescChanged>(_onDescChanged);
    on<MarketFormImgChanged>(_onImgChanged);
    on<MarketFormBeginTimeChanged>(_onBeginTimeChanged);
    on<MarketFormEndTimeChanged>(_onEndTimeChanged);
    on<MarketFormLocationChanged>(_onLocationChanged);
    on<MarketAddFormSubmitted>(_onMarketAddFormSubmitted);
    on<MarketFormPrepared>(_onMarketFormPrepared);
    on<MarketEditFormSubmitted>(_onMarketFormEditSubmitted);
    on<MarketFormResetRequested>(_onMarketFormReset);
    on<MarketFormStatusResetRequested>(_onMarketFormStatusReset);
  }

  bool validateOthers(String imgPath, String address) =>
      imgPath != '' && address != '';

  FutureOr<void> _onNameChanged(MarketFormNameChanged event, emit) {
    final name = Name.dirty(event.name);
    emit(state.copyWith(
      name: name,
      inputStatus:
          validateOthers(state.marketImg.path, state.location.address) &&
                  Formz.validate([
                    name,
                    state.hotline,
                    state.desc,
                  ])
              ? FormInputStatus.valid
              : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onHotlineChanged(MarketFormHotlineChanged event, emit) {
    final hotline = Hotline.dirty(event.hotline);
    emit(state.copyWith(
      hotline: hotline,
      inputStatus:
          validateOthers(state.marketImg.path, state.location.address) &&
                  Formz.validate([
                    state.name,
                    hotline,
                    state.desc,
                  ])
              ? FormInputStatus.valid
              : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onDescChanged(MarketFormDescChanged event, emit) {
    final desc = Desc.dirty(event.desc);
    emit(state.copyWith(
      desc: desc,
      inputStatus:
          validateOthers(state.marketImg.path, state.location.address) &&
                  Formz.validate([
                    state.name,
                    state.hotline,
                    desc,
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
        marketImg: imageFile,
        isImgChanged: true,
        imgName: imageFile.path.split('/').last,
        inputStatus: validateOthers(imageFile.path, state.location.address) &&
                Formz.validate([
                  state.name,
                  state.hotline,
                  state.desc,
                ])
            ? FormInputStatus.valid
            : FormInputStatus.invalid,
      ));
    }
  }

  FutureOr<void> _onBeginTimeChanged(MarketFormBeginTimeChanged event, emit) {
    emit(state.copyWith(
      beginTime: event.beginTime,
      inputStatus:
          validateOthers(state.marketImg.path, state.location.address) &&
                  Formz.validate([
                    state.name,
                    state.hotline,
                    state.desc,
                  ])
              ? FormInputStatus.valid
              : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onEndTimeChanged(MarketFormEndTimeChanged event, emit) {
    emit(state.copyWith(
      endTime: event.endTime,
      inputStatus:
          validateOthers(state.marketImg.path, state.location.address) &&
                  Formz.validate([
                    state.name,
                    state.hotline,
                    state.desc,
                  ])
              ? FormInputStatus.valid
              : FormInputStatus.invalid,
    ));
  }

  FutureOr<void> _onLocationChanged(MarketFormLocationChanged event, emit) {
    emit(state.copyWith(
      location: event.location,
      inputStatus:
          validateOthers(state.marketImg.path, event.location.address) &&
                  Formz.validate([
                    state.name,
                    state.hotline,
                    state.desc,
                  ])
              ? FormInputStatus.valid
              : FormInputStatus.invalid,
    ));
  }

  Future<void> _onMarketFormPrepared(MarketFormPrepared event, emit) async {
    try {
      emit(state.copyWith(
        id: event.market.id,
        submissionStatus: FormzSubmissionStatus.initial,
        name: Name.dirty(event.market.name),
        hotline: Hotline.dirty(event.market.hotline),
        desc: Desc.dirty(event.market.desc),
        marketImg: File('market_img.png'),
        beginTime: event.market.beginTime,
        endTime: event.market.endTime,
        imgName: 'market_img.png',
        imgUrl: event.market.imgUrl,
        inputStatus: FormInputStatus.initial,
        location: event.market.location,
        active: event.market.active,
      ));
    } catch (e) {
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.initial));
    }
  }

  FutureOr<void> _onMarketAddFormSubmitted(event, emit) async {
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
    final res = await sl.get<AdminRepository>().addMarket(
          name: state.name.value,
          hotline: state.hotline.value,
          desc: state.desc.value,
          imageFile: state.marketImg,
          beginTime: state.beginTime,
          endTime: state.endTime,
          location: state.location,
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

  FutureOr<void> _onMarketFormEditSubmitted(event, emit) async {
    try {
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
      final res = await sl.get<AdminRepository>().editMarket(
            id: state.id,
            name: state.name.value,
            hotline: state.hotline.value,
            desc: state.desc.value,
            isImgChanged: state.isImgChanged,
            originalImgUrl: state.imgUrl,
            imageFile: state.marketImg,
            beginTime: state.beginTime,
            endTime: state.endTime,
            location: state.location,
            active: state.active,
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

  Future<void> _onMarketFormReset(event, emit) async {
    emit(MarketFormState.initial);
  }

  FutureOr<void> _onMarketFormStatusReset(event, emit) {
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.initial));
  }
}
