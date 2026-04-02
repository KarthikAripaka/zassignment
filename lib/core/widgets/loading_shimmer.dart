// ─── lib/core/widgets/loading_shimmer.dart ───
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
    this.itemCount = 1,
  });

  final double? width;
  final double height;
  final double borderRadius;
  final int itemCount;

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkSurface : AppColors.border;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Column(
          children: List.generate(widget.itemCount, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < widget.itemCount - 1 ? 12 : 0,
              ),
              child: _ShimmerItem(
                width: widget.width,
                height: widget.height,
                borderRadius: widget.borderRadius,
                baseColor: baseColor,
                offset: _controller.value,
              ),
            );
          }),
        );
      },
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
  }) : super(listenable: animation);

  final Widget Function(BuildContext context, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}

class _ShimmerItem extends StatelessWidget {
  const _ShimmerItem({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.baseColor,
    required this.offset,
  });

  final double? width;
  final double height;
  final double borderRadius;
  final Color baseColor;
  final double offset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final highlightColor =
        isDark ? AppColors.darkSurface.withOpacity(0.6) : Colors.white;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [baseColor, highlightColor, baseColor],
          stops: [
            (offset - 0.3).clamp(0.0, 1.0),
            offset.clamp(0.0, 1.0),
            (offset + 0.3).clamp(0.0, 1.0),
          ],
        ),
      ),
    );
  }
}

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingShimmer(width: 200, height: 20),
          SizedBox(height: 24),
          LoadingShimmer(
            width: double.infinity,
            height: 140,
            borderRadius: 16,
          ),
          SizedBox(height: 24),
          LoadingShimmer(
            width: double.infinity,
            height: 200,
            borderRadius: 16,
          ),
          SizedBox(height: 24),
          LoadingShimmer(width: 120, height: 18),
          SizedBox(height: 16),
          LoadingShimmer(
            width: double.infinity,
            height: 72,
            borderRadius: 12,
            itemCount: 3,
          ),
        ],
      ),
    );
  }
}
