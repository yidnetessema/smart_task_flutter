import 'package:equatable/equatable.dart';

abstract class AppCubitStates extends Equatable{}

class InitialState extends AppCubitStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadingUserState extends AppCubitStates {
  @override
  List<Object> get props => [];
}

class WelcomeState extends AppCubitStates {
  @override
  List<Object> get props => [];
}

class LoadedUserState extends AppCubitStates {
  LoadedUserState(this.user);
  final Map? user;

  @override
  List<Object?> get props => [user];
}

class LoadingState extends AppCubitStates {
  LoadingState();
  @override
  List<Object?> get props => [];
}

class LoginState extends AppCubitStates {
  String message;
  LoginState(this.message);

  @override
  List<Object> get props => [];
}

class UserAliasLoaded extends AppCubitStates {
  final String userAlias;
  UserAliasLoaded(this.userAlias);

  @override
  List<Object?> get props => [userAlias];
}

class UserNotFoundState extends AppCubitStates {
  @override
  List<Object> get props => [];
}

class ErrorState extends AppCubitStates {
  final String? message;
  ErrorState(this.message);
  @override
  List<Object> get props => [];
}

class SearchButtonState extends AppCubitStates {
  final bool isSearchButtonClicked;

  SearchButtonState({required this.isSearchButtonClicked});

  @override
  List<Object?> get props => [isSearchButtonClicked];
}
