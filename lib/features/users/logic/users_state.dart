import '../../../core/models/user_model.dart';

sealed class UsersState {
  const UsersState();
}

class UsersInitialState extends UsersState {
  const UsersInitialState();
}

class UsersLoadingState extends UsersState {
  const UsersLoadingState();
}

class UsersLoadedState extends UsersState {
  final List<UserModel> users;

  const UsersLoadedState(this.users);
}

class UsersErrorState extends UsersState {
  final String message;

  const UsersErrorState(this.message);
}
