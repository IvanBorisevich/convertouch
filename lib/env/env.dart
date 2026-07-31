import 'package:envied/envied.dart';
part 'env.g.dart';

/// Update env variables:
/// 1) update .env
/// 2) dart run build_runner clean
/// 3) dart run build_runner build --delete-conflicting-outputs

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_HOST')
  static const String apiHost = _Env.apiHost;
}