import 'package:google_sign_in/google_sign_in.dart';
import 'package:rental_car/core/config/app_config.dart';

abstract interface class GoogleAuthService {
  /// Kích hoạt giao diện popup đăng nhập Google và trả về ID Token
  Future<GoogleSignInAuthentication?> signIn();

  /// Đăng xuất tài khoản khỏi phiên Google trên thiết bị
  Future<void> signOut();
}

class GoogleAuthServiceImpl implements GoogleAuthService {
  GoogleAuthServiceImpl({GoogleSignIn? googleSignIn})
    : _googleSignIn =
          googleSignIn ??
          GoogleSignIn(
            serverClientId: AppConfig.googleServerClientId,
            scopes: const ['email', 'profile'],
          );

  final GoogleSignIn _googleSignIn;

  @override
  Future<GoogleSignInAuthentication?> signIn() async {
    // Luôn đăng xuất phiên cũ trước khi đăng nhập để người dùng có thể chọn lại tài khoản
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }

    final account = await _googleSignIn.signIn();
    if (account == null) {
      return null;
    }

    return account.authentication;
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Bỏ qua lỗi nếu Google Sign In chưa được khởi tạo
    }
    try {
      await _googleSignIn.disconnect();
    } catch (_) {
      // Bỏ qua lỗi nếu disconnect thất bại khi chưa liên kết
    }
  }
}
