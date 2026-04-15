import 'package:flutter/material.dart';
import '../../data/models/goal_model.dart';
import '../../core/utils/formatters.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback onTap;
  final VoidCallback? onAddDeposit;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
    this.onAddDeposit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goalColor = Color(goal.colorValue);
    final progress = goal.progress;
    final isCompleted = goal.isCompleted;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          // Sombra moderna e super suave (Neumorfismo leve)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20), // Mais respiro interno
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ícone maior e mais arredondado
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: goalColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        IconData(goal.iconCodePoint,
                            fontFamily: 'MaterialIcons'),
                        color: goalColor,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.name,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontSize: 17),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isCompleted
                                ? '🎉 Meta atingida!'
                                : AppFormatters.daysRemaining(goal.deadline),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isCompleted
                                  ? const Color(0xFF10B981)
                                  : _deadlineColor(context, goal),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (onAddDeposit != null && !isCompleted)
                      Container(
                        decoration: BoxDecoration(
                          color: goalColor.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: onAddDeposit,
                          icon: const Icon(Icons.add_rounded),
                          color: goalColor,
                          tooltip: 'Adicionar depósito',
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // Textos de valores mais destacados
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Guardado', style: theme.textTheme.bodySmall),
                        const SizedBox(height: 2),
                        Text(
                          AppFormatters.currency(goal.savedAmount),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 22,
                            color: isCompleted
                                ? const Color(0xFF10B981)
                                : theme.textTheme.headlineLarge?.color,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Meta', style: theme.textTheme.bodySmall),
                        const SizedBox(height: 2),
                        Text(
                          AppFormatters.currency(goal.targetAmount),
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Barra de progresso mais moderna (grossa e arredondada)
                Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: goalColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutQuart,
                          height: 10,
                          width: constraints.maxWidth * progress,
                          decoration: BoxDecoration(
                            // Gradiente na barra para dar ideia de movimento
                            gradient: LinearGradient(
                              colors: [
                                goalColor.withValues(alpha: 0.7),
                                isCompleted
                                    ? const Color(0xFF10B981)
                                    : goalColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _deadlineColor(BuildContext context, GoalModel goal) {
    final days = goal.daysRemaining;
    if (days <= 0) return const Color(0xFFEF4444); // Red 500
    if (days <= 7) return const Color(0xFFF59E0B); // Amber 500
    return const Color(0xFF64748B); // Slate 500
  }
}
