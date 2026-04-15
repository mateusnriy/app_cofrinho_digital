import 'package:flutter/material.dart';
import '../../core/utils/economy_calculator.dart';

class EconomySuggestionsCard extends StatelessWidget {
  final List<EconomyModality> modalities;

  const EconomySuggestionsCard({
    super.key,
    required this.modalities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Como chegar lá',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 12),
        ...modalities.asMap().entries.map(
              (entry) => _ModalityTile(
                modality: entry.value,
                index: entry.key,
              ),
            ),
      ],
    );
  }
}

class _ModalityTile extends StatelessWidget {
  final EconomyModality modality;
  final int index;

  const _ModalityTile({required this.modality, required this.index});

  static const _icons = [
    Icons.today_rounded,
    Icons.date_range_rounded,
    Icons.calendar_month_rounded,
  ];

  static const _colors = [
    Color(0xFF2D6A4F),
    Color(0xFF1B6CA8),
    Color(0xFF9B5DE5),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[index % _colors.length];
    final icon = _icons[index % _icons.length];
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modality.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    modality.description,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  modality.formattedAmount,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  modality.period,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
