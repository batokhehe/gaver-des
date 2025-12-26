import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalLoadingCounterProvider = StateProvider<int>((ref) => 0);

Future<T> withGlobalLoading<T>(Ref ref, Future<T> Function() request) async {
  Future.microtask(() {
    ref.read(globalLoadingCounterProvider.notifier).state++;
  });

  try {
    return await request();
  } finally {
    Future.microtask(() {
      ref.read(globalLoadingCounterProvider.notifier).state--;
    });
  }
}
