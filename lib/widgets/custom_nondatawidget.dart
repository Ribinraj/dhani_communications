import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String title;
  final String assetIcon;
  final VoidCallback? onRefresh;

  const NoDataWidget({
    super.key,
    required this.title,
    required this.assetIcon,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4F8FDF);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circles with asset icon
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withAlpha(25),
                ),
              ),
              // Middle circle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withAlpha(51),
                ),
              ),
              // Inner circle with asset icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withAlpha(76),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    assetIcon,
                    color: primaryColor,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Decorative dots
              Positioned(
                top: 0,
                right: 20,
                child: _Dot(color: Colors.green, size: 12),
              ),
              Positioned(
                top: 50,
                right: 0,
                child: _Dot(color: primaryColor, size: 10),
              ),
              Positioned(
                bottom: 20,
                left: 15,
                child: _Dot(color: Colors.amber, size: 8),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),

          // Refresh hint
          if (onRefresh != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(13),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh, size: 18, color: primaryColor),
                  const SizedBox(width: 8),
                  const Text(
                    'Pull down to refresh',
                    style: TextStyle(
                      fontSize: 13,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;

  const _Dot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(76),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}