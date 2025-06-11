import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EventShimmerWidget extends StatelessWidget {
  final double sizeHeight, sizeWidth;
  const EventShimmerWidget({
    super.key,
    required this.sizeHeight,
    required this.sizeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sizeHeight * 0.02),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image shimmer
            Container(
              height: sizeHeight * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(sizeHeight * 0.02),
                  topRight: Radius.circular(sizeHeight * 0.02),
                ),
              ),
            ),

            SizedBox(height: sizeHeight * 0.01),

            // Title and participants shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.03),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: sizeWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: sizeWidth * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: sizeHeight * 0.008),

            // Owner shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.03),
              child: Container(
                height: 16,
                width: sizeWidth * 0.3,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            SizedBox(height: sizeHeight * 0.008),

            // Description shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.03),
              child: Column(
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    height: 14,
                    width: sizeWidth * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: sizeHeight * 0.01),

            // Button shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeWidth * 0.03),
              child: Container(
                height: sizeHeight * 0.04,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(sizeHeight * 0.008),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
