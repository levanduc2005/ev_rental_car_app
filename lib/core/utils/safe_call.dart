import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';

/// Hàm bọc an toàn dùng chung cho mọi Repository trong toàn bộ dự án:
/// Chuyển đổi mọi Exception thành `Result<T>` và Failure tương ứng.
Future<Result<T>> safeCall<T>(Future<T> Function() action) async {
  try {
    return Result.ok(await action());
  } on NetworkException catch (e) {
    return Result.err(NetworkFailure(message: e.message, cause: e));
  } on ServerException catch (e) {
    return Result.err(
      ServerFailure(message: e.message, statusCode: e.statusCode, cause: e),
    );
  } on CacheException catch (e) {
    return Result.err(CacheFailure(message: e.message, cause: e));
  } catch (e) {
    return Result.err(UnknownFailure(message: e.toString(), cause: e));
  }
}
