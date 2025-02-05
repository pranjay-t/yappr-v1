import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yappr/core/Theme/app_pallete.dart';

class Loader extends ConsumerStatefulWidget {
  final bool toShow;
  const Loader({super.key, this.toShow = true});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoaderState();
}

class _LoaderState extends ConsumerState<Loader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.toShow
        ? Center(
            child: CircularProgressIndicator(color: AppPallete.primaryColor),
          )
        : const SizedBox();
  }
}
