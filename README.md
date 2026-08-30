# constancia.

## O Problema
Quantas vezes você tentou estudar ou trabalhar, mas acabou perdendo o foco rapidamente por causa de notificações, cansaço ou aquela sensação sufocante de ter tarefas demais acumuladas? A rotina atual fragmenta a nossa atenção, gerando frustração, procrastinação constante e a exaustiva impressão de que o dia passou sem que nada produtivo fosse concluído de verdade.

## A Nossa Solução
O **constancia.** surge para transformar essa realidade de forma leve, prática e humanizada. Mais do que um cronômetro comum, o app adapta a técnica Pomodoro para um fluxo intuitivo que divide grandes responsabilidades em ciclos equilibrados de foco e pausas restauradoras. O objetivo é ajudar você a manter um ritmo constante, reduzir a ansiedade do dia a dia e produzir com consistência, sem desgaste mental.

## Status atual do MVP

O app já roda de ponta a ponta com dados mockados (sem backend ainda). Telas implementadas:

- **Cadastro** — formulário com validação de e-mail, regras de senha em tempo real e confirmação.
- **Onboarding** — escolha do ciclo de foco (25/5, 50/10, 60/20 ou personalizado).
- **Tela principal (constancia.)** — streak, multiplicador, escudos, pontos, gráfico dos últimos 7 dias e ranking do time.
- **Board** — cards de tarefas agrupados por status (Não iniciada / Em desenvolvimento / Parada).
- **Detalhe do card** — abre a partir do Board ou da tela principal, com opção de iniciar um ciclo de foco.
- **Ciclo de foco** — timer contando o ciclo escolhido.
- **Travados** — lista de cards bloqueados com o motivo do bloqueio.
- **Configurações** — acessível pelo ícone de engrenagem na tela principal.

## Identidade visual

- **Marca:** sempre grafada `constancia.` (minúscula, com ponto) — nunca "Constancia" ou "ConstânciaPomodoro". O selo em `assets/logo.png` é a fonte única da wordmark e é renderizado pelo widget `BrandMark` (`lib/widgets/brand_mark.dart`).
- **Paleta** (`lib/theme/app_colors.dart`) — tons quentes de laranja e amarelo como marca, mantendo neutros e cores de status:

  | Uso | Cor | Hex |
  |---|---|---|
  | Primária / marca | 🟧 laranja queimado | `#E2632E` |
  | Primária escura | 🟧 | `#B84A1F` |
  | Destaque amarelo | 🟨 | `#F5B942` |
  | Destaque laranja (streak/gráfico) | 🟧 | `#F08A3C` |
  | Fundo | ⬜ off-white quente | `#FFF8EF` |
  | Superfície (cards) | ⬜ branco | `#FFFFFF` |
  | Texto primário | ⬛ | `#2B211C` |
  | Texto secundário | ⬛ | `#7A6F63` |
  | Divisor | ⬜ | `#E9DFD1` |
  | Status: parada | 🟥 | `#D9534F` |
  | Status: em desenvolvimento | 🟦 | `#4C6FA0` |
  | Status: não iniciada | ⬜ cinza | `#9B9B93` |

- **Tipografia:** [Manrope](https://fonts.google.com/specimen/Manrope) via `google_fonts`, aplicada em `lib/theme/app_theme.dart`.

## Tecnologias Utilizadas
* **Flutter** 3.47 (stable)
* **Dart** 3.13
* **google_fonts** para a tipografia da marca

## Como rodar localmente

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e no `PATH`.

```bash
git clone https://github.com/lucrilhos/pomodoro_app.git
cd pomodoro_app
flutter pub get
flutter run          # abre no dispositivo/emulador conectado
# ou, sem Android/iOS configurado:
flutter run -d chrome
```

Para checar que está tudo saudável antes de subir uma mudança:

```bash
flutter analyze
flutter test
```

## Próximos passos

- Persistência real (hoje tudo é mockado em memória — `lib/data/`)
- Autenticação de verdade (cadastro hoje não fala com nenhum backend)
- Ciclo "personalizado" com input de minutos
- Ranking e board com dados reais de outros usuários

## Integrantes do Grupo
* Antônio Santana — RM: 565516
* Bento Garcia — RM: 561621
* Enzo Ribeiro — RM: 564216
* Guilherme Domingues — RM: 565157
* Gustavo Braga — RM: 562247
* Kaio Correa — RM: 563443
* Lucas Mendes — RM: 563667
