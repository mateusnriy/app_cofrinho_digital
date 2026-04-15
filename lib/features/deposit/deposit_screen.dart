import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/formatters.dart';
import '../../data/models/deposit_model.dart';
import '../../data/models/goal_model.dart';
import '../../core/providers/global_providers.dart';

class DepositScreen extends ConsumerStatefulWidget {
  final GoalModel goal;
  final VoidCallback? onDepositSaved;

  const DepositScreen({
    super.key,
    required this.goal,
    this.onDepositSaved,
  });

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  static const _quickValues = [10.0, 25.0, 50.0, 100.0, 200.0, 500.0];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;
    final goalColor = Color(goal.colorValue);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxAvailableHeight = MediaQuery.of(context).size.height * 0.85;

    return SafeArea(
      // RESPONSIVIDADE: Permite *scroll* se o teclado tapar o conteúdo
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxAvailableHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: goalColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        IconData(goal.iconCodePoint,
                            fontFamily: 'MaterialIcons'),
                        color: goalColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registar depósito',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            goal.name,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _MiniProgressBar(goal: goal, goalColor: goalColor),
                const SizedBox(height: 20),
                Text('Valor depositado',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  autofocus: true,
                  // CORREÇÃO DO TECLADO NO IOS
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                  ],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: '0,00',
                    prefixText: 'R\$ ',
                    prefixStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: goalColor),
                    suffixIcon: _amountController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _amountController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: goalColor, width: 2),
                    ),
                  ),
                  onChanged: (_) => setState(() => _error = null),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _quickValues.map((value) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text('R\$ ${value.toStringAsFixed(0)}'),
                          onPressed: () {
                            _amountController.text =
                                value.toStringAsFixed(2).replaceAll('.', ',');
                            setState(() => _error = null);
                          },
                          backgroundColor: goalColor.withValues(alpha: 0.1),
                          labelStyle: TextStyle(
                              color: goalColor, fontWeight: FontWeight.w500),
                          side: BorderSide(
                              color: goalColor.withValues(alpha: 0.3)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Observação (opcional)',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Ex: Sobras do salário...',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goalColor,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Confirmar depósito'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final text =
        _amountController.text.replaceAll('.', '').replaceAll(',', '.');
    final amount = double.tryParse(text);

    if (amount == null || amount <= 0) {
      setState(() => _error = 'Informe um valor válido');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final deposit = DepositModel(
      id: const Uuid().v4(),
      goalId: widget.goal.id,
      amount: amount,
      date: DateTime.now(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    final depositRepo = ref.read(depositRepositoryProvider);
    final goalRepo = ref.read(goalRepositoryProvider);

    await depositRepo.save(deposit);
    await goalRepo.addDeposit(widget.goal.id, amount);

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.of(context).pop();
      widget.onDepositSaved?.call();

      // CORREÇÃO: Feedback visual da ação de depósito guardado!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text('Depósito de ${AppFormatters.currency(amount)} registado!'),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}

class _MiniProgressBar extends StatelessWidget {
  final GoalModel goal;
  final Color goalColor;

  const _MiniProgressBar({required this.goal, required this.goalColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppFormatters.currency(goal.savedAmount),
              style: TextStyle(
                color: goalColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Text(
              '${AppFormatters.percent(goal.progressPercent)} de ${AppFormatters.currency(goal.targetAmount)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: goal.progress,
            minHeight: 6,
            backgroundColor: goalColor.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(goalColor),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Faltam ${AppFormatters.currency(goal.remainingAmount)}',
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
          ),
        ),
      ],
    );
  }
}
