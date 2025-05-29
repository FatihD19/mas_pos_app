import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mas_pos_app/feature/auth/data/datasource/auth_local_datasource.dart';
import 'package:mas_pos_app/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:mas_pos_app/feature/auth/data/model/login_request_model.dart';
import 'package:mas_pos_app/feature/auth/data/model/login_response_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;

  AuthBloc({
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource,
        super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<AutoLoginEvent>(_onAutoLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final request = LoginRequestModel(
        email: event.email,
        password: event.password,
      );

      final response = await _remoteDatasource.login(request: request);

      // Save credentials for auto login
      await _localDatasource.saveCredentials(event.email, event.password);

      emit(AuthAuthenticated(response));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAutoLogin(
      AutoLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final credentials = await _localDatasource.getCredentials();
      final email = credentials['email'];
      final password = credentials['password'];

      if (email != null && password != null) {
        final request = LoginRequestModel(
          email: email,
          password: password,
        );

        final response = await _remoteDatasource.login(request: request);
        emit(AuthAuthenticated(response));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _localDatasource.clearCredentials();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
