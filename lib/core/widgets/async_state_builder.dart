import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncStateBuilder<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final Widget? loading;
  final Widget? error;

  const AsyncStateBuilder({
    super.key,
    required this.value,
    required this.builder,
    this.loading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () =>
          loading ?? const Center(child: CircularProgressIndicator()),
      error: (e, _) => error ?? const Center(child: Text('Terjadi kesalahan')),
      data: builder,
    );
  }
}
