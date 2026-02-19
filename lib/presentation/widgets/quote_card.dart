// lib/presentation/widgets/quote_card.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_helper.dart';

class QuoteCard extends StatelessWidget {
  final String quote;
  final String author;

  const QuoteCard({
    Key? key,
    required this.quote,
    required this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.sp(24)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade400,
            Colors.pink.shade400,
            Colors.orange.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(responsive.r(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative quote marks
          Positioned(
            top: -10,
            right: -10,
            child: Icon(
              Icons.format_quote,
              size: responsive.sp(80),
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: -10,
            left: -10,
            child: Icon(
              Icons.format_quote,
              size: responsive.sp(80),
              color: Colors.white.withOpacity(0.1),
            ),
          ),

          // Content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quote text
              Text(
                '"$quote"',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.sp(16),
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: responsive.hp(2)),

              // Author with decorative lines
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: responsive.wp(8),
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.wp(3)),
                  Text(
                    author,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.sp(14),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: responsive.wp(3)),
                  Container(
                    width: responsive.wp(8),
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}