// lib/presentation/widgets/loading_widget.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive_helper.dart';

class LoadingWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const LoadingWidget({
    Key? key,
    this.height,
    this.width,
    this.borderRadius = 8,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDark ? Colors.grey[800]! : Colors.grey[300]!),
      highlightColor: highlightColor ?? (isDark ? Colors.grey[700]! : Colors.grey[100]!),
      period: const Duration(milliseconds: 1200), // Slower shimmer for better effect
      child: Container(
        height: height ?? responsive.hp(12),
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.r(borderRadius)),
        ),
      ),
    );
  }
}

// Compact Weather Card Loading
class WeatherCardLoading extends StatelessWidget {
  const WeatherCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Container(
      height: responsive.hp(30), // Smaller height
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(responsive.r(30)),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        period: const Duration(milliseconds: 1200),
        child: Padding(
          padding: EdgeInsets.all(responsive.sp(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location shimmer
              Container(
                width: responsive.wp(30),
                height: responsive.hp(3),
                color: Colors.white,
              ),
              const Spacer(),
              // Temperature shimmer
              Container(
                width: responsive.wp(25),
                height: responsive.hp(6),
                color: Colors.white,
              ),
              SizedBox(height: responsive.hp(1)),
              // Condition shimmer
              Container(
                width: responsive.wp(35),
                height: responsive.hp(2.5),
                color: Colors.white,
              ),
              SizedBox(height: responsive.hp(2)),
              // Stats row shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) => Container(
                  width: responsive.wp(15),
                  height: responsive.hp(5),
                  color: Colors.white,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Compact Forecast Card Loading
class ForecastCardLoading extends StatelessWidget {
  const ForecastCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Container(
      padding: EdgeInsets.all(responsive.sp(16)),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(responsive.r(24)),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        period: const Duration(milliseconds: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              height: responsive.hp(2.5),
              width: responsive.wp(30),
              color: Colors.white,
            ),
            SizedBox(height: responsive.hp(2)),

            // Horizontal forecast items
            SizedBox(
              height: responsive.hp(12),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (_, __) => SizedBox(width: responsive.wp(2)),
                itemBuilder: (context, index) => Container(
                  width: responsive.wp(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(responsive.r(16)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Compact Quote Card Loading
class QuoteCardLoading extends StatelessWidget {
  const QuoteCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Container(
      height: responsive.hp(15), // Smaller height
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(responsive.r(24)),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        period: const Duration(milliseconds: 1200),
        child: Padding(
          padding: EdgeInsets.all(responsive.sp(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Quote icon
              Container(
                width: responsive.wp(8),
                height: responsive.wp(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: responsive.hp(1)),
              // Quote line 1
              Container(
                width: double.infinity,
                height: responsive.hp(1.8),
                color: Colors.white,
              ),
              SizedBox(height: responsive.hp(0.5)),
              // Quote line 2
              Container(
                width: responsive.wp(60),
                height: responsive.hp(1.8),
                color: Colors.white,
              ),
              SizedBox(height: responsive.hp(1)),
              // Author
              Container(
                width: responsive.wp(30),
                height: responsive.hp(1.5),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Location Loading Shimmer
class LocationLoadingShimmer extends StatelessWidget {
  const LocationLoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            period: const Duration(milliseconds: 1200),
            child: Container(
              width: responsive.wp(20),
              height: responsive.wp(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: responsive.hp(2)),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            period: const Duration(milliseconds: 1200),
            child: Container(
              width: responsive.wp(40),
              height: responsive.hp(2.5),
              color: Colors.white,
            ),
          ),
          SizedBox(height: responsive.hp(1)),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            period: const Duration(milliseconds: 1200),
            child: Container(
              width: responsive.wp(50),
              height: responsive.hp(2),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Combined Weather Loading State
class WeatherLoadingWidget extends StatelessWidget {
  const WeatherLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Column(
      children: [
        const WeatherCardLoading(),
        SizedBox(height: responsive.hp(1.5)),
        const ForecastCardLoading(),
        SizedBox(height: responsive.hp(1.5)),
        const QuoteCardLoading(),
      ],
    );
  }
}