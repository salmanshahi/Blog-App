import 'package:blog_app/core/error/execptions.dart';
import 'package:blog_app/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String pssword,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String pssword,
  });
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoveDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoveDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword(
      {required String email, required String pssword}) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(password: pssword, email: email);
      if (response.user == null) {
        throw ServerException('User is null!.');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String pssword}) async {
    try {
      final response = await supabaseClient.auth
          .signUp(password: pssword, email: email, data: {
        'name': name,
      });
      if (response.user == null) {
        throw ServerException('User is null!.');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
