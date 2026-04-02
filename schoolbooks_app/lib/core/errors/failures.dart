import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  
  const Failure({required this.message, this.statusCode});
  
  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred', super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection', super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred', super.statusCode});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed', super.statusCode});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation failed', super.statusCode});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Resource not found', super.statusCode});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Unauthorized access', super.statusCode});
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({super.message = 'Access forbidden', super.statusCode});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'Request timed out', super.statusCode});
}

class PaymentFailure extends Failure {
  const PaymentFailure({super.message = 'Payment failed', super.statusCode});
}

class InventoryFailure extends Failure {
  const InventoryFailure({super.message = 'Insufficient inventory', super.statusCode});
}
