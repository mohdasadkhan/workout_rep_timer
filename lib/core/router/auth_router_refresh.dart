import 'dart:async';

import 'package:fitflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/foundation.dart';

/// Notifies [GoRouter] when auth state changes so redirects re-run.
class AuthRouterRefresh extends ChangeNotifier {
  AuthRouterRefresh(AuthCubit authCubit) {
    _subscription = authCubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
