<p align="center">
  <img src="lib/assets/icon/logo.png" alt="Cofrinho Digital" width="120"/>
</p>

<h1 align="center">🐷 Cofrinho Digital</h1>

<p align="center">
  Aplicativo móvel de metas financeiras pessoais com foco em educação financeira e planejamento de poupança.
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white"/>
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart&logoColor=white"/>
  <img alt="Hive" src="https://img.shields.io/badge/Hive-2.2.3-FFCA28?style=flat-square"/>
  <img alt="Riverpod" src="https://img.shields.io/badge/Riverpod-2.5.1-00BCD4?style=flat-square"/>
  <img alt="License" src="https://img.shields.io/badge/licença-MIT-green?style=flat-square"/>
</p>

---

## 📋 Sobre o Projeto

O **Cofrinho Digital** é um aplicativo móvel focado em educação financeira e planejamento pessoal. Ele permite criar metas financeiras, acompanhar o progresso das economias e registrar simulações de depósitos, com uma interface intuitiva e cálculos automatizados de projeção de poupança.

O aplicativo opera **100% offline**, garantindo privacidade e rapidez no acesso aos dados. Vale ressaltar que o sistema funciona exclusivamente como um **gerenciador financeiro virtual** — não realiza transações bancárias reais, saques ou custódia de valores.

---

## ✨ Funcionalidades

- **Criação e gerenciamento de metas** — defina ícone, cor, nome, valor alvo, prazo e lembrete diário
- **Projeção de economia** — planos automáticos de economia diária, semanal e mensal
- **Registro de depósitos** — botões de atalho (R$ 10, 25, 50, 100, 200) ou entrada manual
- **Dashboard de patrimônio** — visão geral do total guardado e percentual de conclusão de todas as metas
- **Histórico e gráfico de depósitos por mês** — acompanhe sua evolução ao longo do tempo
- **Conclusão de metas** — estado visual de celebração ao atingir o valor alvo
- **Ordenação de metas** — por mais recentes, prazo ou progresso
- **Lembretes locais** — notificações diárias configuráveis para incentivar a poupança
- **Tema claro e escuro** — alternância visual em tempo real

---

## 🛠️ Tecnologias

| Tecnologia | Versão | Uso |
|---|---|---|
| [Flutter](https://flutter.dev) | 3.x | Framework principal (UI + estado visual) |
| [Dart](https://dart.dev) | ≥ 3.0.0 | Linguagem de programação |
| [Hive](https://pub.dev/packages/hive) + [hive_flutter](https://pub.dev/packages/hive_flutter) | 2.2.3 / 1.1.0 | Banco de dados local NoSQL (offline-first) |
| [Flutter Riverpod](https://riverpod.dev) | 2.5.1 | Gerenciamento de estado |
| [fl_chart](https://pub.dev/packages/fl_chart) | 0.68.0 | Gráficos de depósitos |
| [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) | 17.2.2 | Notificações locais |
| [intl](https://pub.dev/packages/intl) | 0.20.2 | Formatação de datas e moedas |
| [uuid](https://pub.dev/packages/uuid) | 4.4.0 | Geração de IDs únicos |
| [timezone](https://pub.dev/packages/timezone) + [flutter_timezone](https://pub.dev/packages/flutter_timezone) | 0.9.2 / 5.0.2 | Fuso horário para notificações |

---

## 🏗️ Arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)**:

```
lib/
├── models/          # Entidades de dados (Meta, Deposito) e TypeAdapters do Hive
├── viewmodels/      # Regras de negócio, cálculos de projeção e estado das telas
├── views/           # Telas e widgets Flutter (sem lógica de negócio)
├── repositories/    # Abstração do acesso ao banco de dados Hive
└── assets/
    └── icon/        # Ícone do aplicativo
```

- **Model** — entidades de dados e repositórios com operações de leitura/escrita no Hive
- **ViewModel** — regras de negócio, cálculo de projeções (diária/semanal/mensal) e percentuais de progresso
- **View** — telas em Flutter que observam o estado emitido pela ViewModel e redesenham a interface

---

## Desenvolvedores

| Membro | GitHub |
| :--- | :--- |
| **Mateus Neri** | [@mateus](https://github.com/mateusnriy) |
| **Kaio França** | [@kaio](https://github.com/kaiofranca) |

---

## 🚀 Como executar

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.0.0
- Android SDK (min SDK 21) ou Xcode (para iOS)
- Git

### Instalação

```bash
# 1. Clone o repositório
git clone https://github.com/mateusnriy/app_cofrinho_digital.git
cd app_cofrinho_digital

# 2. Instale as dependências
flutter pub get

# 3. Gere os arquivos do Hive e Riverpod
dart run build_runner build --delete-conflicting-outputs

# 4. Execute o aplicativo
flutter run
```
