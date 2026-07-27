import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';
import 'primary_button.dart';

/// Enum representing distinct error types for tailored UX feedback.
enum AppErrorType {
  noInternet,
  serverError,
  invalidCity,
  apiError,
  general,
}

/// Reusable Error Widget displaying contextual icons, title, description, and action button.
class AppErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final AppErrorType type;

  const AppErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    this.type = AppErrorType.general,
  });

  /// Helper factory to automatically detect error type based on message content.
  factory AppErrorWidget.fromMessage({
    Key? key,
    required String message,
    required VoidCallback onRetry,
  }) {
    final lower = message.toLowerCase();
    AppErrorType detectedType = AppErrorType.general;

    if (lower.contains('internet') || lower.contains('network') || lower.contains('socket')) {
      detectedType = AppErrorType.noInternet;
    } else if (lower.contains('server') || lower.contains('500') || lower.contains('502') || lower.contains('503')) {
      detectedType = AppErrorType.serverError;
    } else if (lower.contains('not found') || lower.contains('spelling') || lower.contains('city')) {
      detectedType = AppErrorType.invalidCity;
    } else if (lower.contains('api') || lower.contains('unauthorized')) {
      detectedType = AppErrorType.apiError;
    }

    return AppErrorWidget(
      key: key,
      errorMessage: message,
      onRetry: onRetry,
      type: detectedType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _getErrorConfig();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon Container with soft background badge
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: config.iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                config.icon,
                size: 56,
                color: config.iconColor,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Error Context Title
            Text(
              config.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),

            // Friendly User Message
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Primary Retry Button
            PrimaryButton(
              label: config.buttonLabel,
              icon: config.buttonIcon,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }

  _ErrorConfig _getErrorConfig() {
    switch (type) {
      case AppErrorType.noInternet:
        return const _ErrorConfig(
          title: 'No Internet Connection',
          icon: Icons.wifi_off_rounded,
          iconColor: AppColors.error,
          buttonLabel: 'Check & Try Again',
          buttonIcon: Icons.refresh_rounded,
        );

      case AppErrorType.serverError:
        return const _ErrorConfig(
          title: 'Server Temporarily Down',
          icon: Icons.dns_rounded,
          iconColor: AppColors.sunny,
          buttonLabel: 'Retry Request',
          buttonIcon: Icons.refresh_rounded,
        );

      case AppErrorType.invalidCity:
        return const _ErrorConfig(
          title: 'City Not Found',
          icon: Icons.location_off_rounded,
          iconColor: AppColors.sunny,
          buttonLabel: 'Try Another City',
          buttonIcon: Icons.search_rounded,
        );

      case AppErrorType.apiError:
        return const _ErrorConfig(
          title: 'API Service Issue',
          icon: Icons.api_rounded,
          iconColor: AppColors.error,
          buttonLabel: 'Try Again',
          buttonIcon: Icons.refresh_rounded,
        );

      case AppErrorType.general:
        return const _ErrorConfig(
          title: 'Unable to Load Weather',
          icon: Icons.error_outline_rounded,
          iconColor: AppColors.error,
          buttonLabel: 'Try Again',
          buttonIcon: Icons.refresh_rounded,
        );
    }
  }
}

class _ErrorConfig {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String buttonLabel;
  final IconData buttonIcon;

  const _ErrorConfig({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.buttonLabel,
    required this.buttonIcon,
  });
}
