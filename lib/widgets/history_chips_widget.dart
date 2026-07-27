import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';

/// Reusable History Chips Widget displaying horizontal scrolling recent city search chips.
/// Automatically hides itself when history is empty.
class HistoryChipsWidget extends StatelessWidget {
  final List<String> history;
  final ValueChanged<String> onSelectCity;
  final VoidCallback onClearHistory;

  const HistoryChipsWidget({
    super.key,
    required this.history,
    required this.onSelectCity,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    // Hide widget completely if history is empty
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: "Recent Searches" Title + "Clear All" Action Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 16,
                    color: isDark ? AppColors.accent : AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onClearHistory,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Clear All',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.clear_all_rounded,
                        size: 14,
                        color: AppColors.error,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Horizontal Scrolling Action Chips
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.xs),
            itemBuilder: (context, index) {
              final city = history[index];

              return ActionChip(
                elevation: 0,
                pressElevation: 1,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                backgroundColor: isDark
                    ? const Color(0xFF1E293B)
                    : AppColors.surface,
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : AppColors.border.withValues(alpha: 0.8),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                avatar: const Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                label: Text(
                  city,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                onPressed: () => onSelectCity(city),
              );
            },
          ),
        ),
      ],
    );
  }
}
