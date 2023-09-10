import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user not found ') {
        emit(LoginFailure(errorMsg: 'user not found '));
      } else if (e.code == 'wrong password ') {
        emit(LoginFailure(errorMsg: 'wrong password'));
      }
    } catch (e) {
      emit(LoginFailure(errorMsg: 'something went wrong  '));
    }
  }

  Future<void> registerUser(
      {required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(errorMsg: 'weak-password'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errorMsg: 'email already exists'));
      }
    } catch (e) {
      emit(RegisterFailure(errorMsg: 'there was an error'));
    }
  }
}
