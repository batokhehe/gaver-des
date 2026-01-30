import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export '../features/auth/providers/auth_provider.dart';
export '../features/auth/data/auth_repository.dart';

export '../features/user/providers/user_provider.dart';
export '../features/user/providers/user_api_provider.dart';
export '../features/user/providers/user_repository_provider.dart';
export '../features/user/data/user_repository.dart';

export 'router.dart';

final globalLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

final sessionExpiredDialogShownProvider = StateProvider<bool>((ref) => false);

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((_) {
  return GlobalKey<NavigatorState>();
});
