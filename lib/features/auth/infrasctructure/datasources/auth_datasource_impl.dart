import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environments.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrasctructure/infrasctructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final Dio dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));
  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioErrorType.connectionTimeout) throw ConnectionTimeout();
      throw CustomError(
          e.response?.data['message'] ?? 'Algo desconocido ocurrio');
    } catch (e) {
      throw CustomError('Algo desconocido ocurrio');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio
          .post('/auth/login', data: {'email': email, 'password': password});
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioErrorType.connectionTimeout) throw ConnectionTimeout();
      throw CustomError(
          e.response?.data['message'] ?? 'Algo desconocido ocurrio');
    } catch (e) {
      throw CustomError('Algo desconocido ocurrio');
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
