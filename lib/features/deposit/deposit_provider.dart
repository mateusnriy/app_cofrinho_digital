import 'package:flutter_riverpod/flutter_riverpod.dart';

// Estado de loading do formulário de depósito
final depositLoadingProvider = StateProvider<bool>((ref) => false);
