import '../repos/users_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepository _usersRepository;

  UsersCubit({required UsersRepository usersRepository})
      : _usersRepository = usersRepository,
        super(const UsersInitialState());

  Future<void> fetchAllUsers() async {
    emit(const UsersLoadingState());
    final result = await _usersRepository.fetchAllUsers();
    result.fold(
      (failure) => emit(UsersErrorState(failure.message)),
      (users) => emit(UsersLoadedState(users)),
    );
  }
}
