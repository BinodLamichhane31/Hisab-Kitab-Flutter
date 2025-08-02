import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/change_password_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/delete_account_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/get_profile_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/update_profile_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/upload_profile_image_usecase.dart';

// Events
abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String fname;
  final String lname;

  UpdateProfileEvent({required this.fname, required this.lname});
}

class ChangePasswordEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordEvent({required this.oldPassword, required this.newPassword});
}

class DeleteAccountEvent extends ProfileEvent {}

class UploadProfileImageEvent extends ProfileEvent {
  final String imagePath;

  UploadProfileImageEvent({required this.imagePath});
}

// States
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;

  ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileSuccess extends ProfileState {
  final String message;
  final UserEntity? user;

  ProfileSuccess(this.message, {this.user});
}

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase _getProfileUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final ChangePasswordUsecase _changePasswordUsecase;
  final DeleteAccountUsecase _deleteAccountUsecase;
  final UploadProfileImageUsecase _uploadProfileImageUsecase;

  UserEntity? _lastLoadedUser;

  ProfileViewModel({
    required GetProfileUsecase getProfileUsecase,
    required UpdateProfileUsecase updateProfileUsecase,
    required ChangePasswordUsecase changePasswordUsecase,
    required DeleteAccountUsecase deleteAccountUsecase,
    required UploadProfileImageUsecase uploadProfileImageUsecase,
  }) : _getProfileUsecase = getProfileUsecase,
       _updateProfileUsecase = updateProfileUsecase,
       _changePasswordUsecase = changePasswordUsecase,
       _deleteAccountUsecase = deleteAccountUsecase,
       _uploadProfileImageUsecase = uploadProfileImageUsecase,
       super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ChangePasswordEvent>(_onChangePassword);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<UploadProfileImageEvent>(_onUploadProfileImage);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _getProfileUsecase();
    result.fold((failure) => emit(ProfileError(failure.message)), (user) {
      _lastLoadedUser = user;
      emit(ProfileLoaded(user));
    });
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _updateProfileUsecase(
      UpdateProfileParams(fname: event.fname, lname: event.lname),
    );
    result.fold((failure) => emit(ProfileError(failure.message)), (user) {
      _lastLoadedUser = user;
      emit(ProfileSuccess('Profile updated successfully', user: user));
    });
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _changePasswordUsecase(
      ChangePasswordParams(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      ),
    );
    result.fold((failure) => emit(ProfileError(failure.message)), (_) {
      emit(
        ProfileSuccess('Password changed successfully', user: _lastLoadedUser),
      );
    });
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _deleteAccountUsecase();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(ProfileSuccess('Account deleted successfully')),
    );
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _uploadProfileImageUsecase(
      UploadProfileImageParams(imagePath: event.imagePath),
    );
    result.fold((failure) => emit(ProfileError(failure.message)), (user) {
      _lastLoadedUser = user;
      emit(ProfileSuccess('Profile image uploaded successfully', user: user));
    });
  }
}
