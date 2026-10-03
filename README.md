# constancia.

App de produtividade que une gestão de tarefas, hábitos e foco no estilo Pomodoro.
Você mantém uma sequência de dias consecutivos — a constância que dá nome ao app —
enquanto amigos acompanham e comentam nas suas tarefas.

## O problema

Quantas vezes você tentou estudar ou trabalhar, mas acabou perdendo o foco rapidamente por causa de notificações, cansaço ou aquela sensação sufocante de ter tarefas demais acumuladas? A rotina atual fragmenta a nossa atenção, gerando frustração, procrastinação constante e a exaustiva impressão de que o dia passou sem que nada produtivo fosse concluído de verdade.

## A nossa solução

O **constancia.** surge para transformar essa realidade de forma leve, prática e humanizada. Mais do que um cronômetro comum, o app adapta a técnica Pomodoro para um fluxo intuitivo que divide grandes responsabilidades em ciclos equilibrados de foco e pausas restauradoras. O objetivo é ajudar você a manter um ritmo constante, reduzir a ansiedade do dia a dia e produzir com consistência, sem desgaste mental.

---

## Como rodar o projeto

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e no `PATH`.
Confira com `flutter doctor` antes de começar.

```bash
git clone https://github.com/lucrilhos/constancia_app.git
cd constancia_app
flutter pub get
```

### No navegador (caminho mais rápido)

```bash
flutter run -d chrome
```

Não exige Android Studio nem emulador. É o caminho recomendado para uma
demonstração rápida.

### No emulador Android

1. Abra o Android Studio e vá em **Tools → Device Manager**.
2. Crie um dispositivo virtual (qualquer Pixel com API 33 ou superior serve).
3. Inicie o emulador e confirme que o Flutter o enxerga:

```bash
flutter devices
flutter run            # usa o dispositivo conectado
```

### No desktop

```bash
flutter run -d windows   # ou -d linux, -d macos
```

As credenciais do Supabase já vêm no projeto (`lib/data/supabase_config.dart`),
então não há nenhuma configuração extra. **O app roda mesmo sem internet**: toda
tela que busca dados do banco começa exibindo os dados locais de
`lib/data/sample_tasks.dart` e só troca pelos reais quando a busca termina. Se a
busca falhar, a tela continua funcional e mostra um aviso discreto.

### Antes de subir qualquer mudança

```bash
flutter analyze
flutter test
```

---

## Decisões técnicas desde o CP4

### Banco de dados: Supabase

Escolhido em vez do Firebase porque os dados do app são relacionais por natureza —
tarefas pertencem a um usuário, comentários pertencem a uma tarefa, o ranking cruza
pontos entre usuários. Isso mapeia diretamente para tabelas SQL. O setup no Flutter
também é mais simples: só URL e chave, sem configuração nativa por plataforma.

O schema (`supabase/schema.sql`) tem três tabelas: `profiles` (pessoas, streak,
pontos), `tasks` (tarefas, ligadas a um dono) e `task_comments` (comentários de
amigos numa tarefa).

### Modo offline com fallback local

`ConstanciaScreen`, `BoardScreen` e `CardDetailScreen` começam com os dados de
`sample_tasks.dart` e trocam pelos do Supabase assim que a busca termina. Isso
garante que a tela nunca fique em branco e que uma apresentação não trave por
causa da rede — requisito direto do CP5, que pede protótipo funcional com dados
mockados **e** integração de banco.

### Unificação dos repositórios

O trabalho do CP5 foi feito num repositório separado, sem ancestral comum com este.
A união exigiu `git merge --allow-unrelated-histories`, e os 20 arquivos que existiam
dos dois lados entraram como conflito. O registro completo de como cada um foi
resolvido está em **[MERGE.md](MERGE.md)**.

### Identidade visual restaurada

O repositório do CP5 havia adotado uma paleta verde escuro com tipografia Inter.
O grupo decidiu manter a identidade documentada aqui — laranja queimado e Manrope —
e ela foi restaurada após o merge.

### Desempenho

- `assets/logo.png` tem 2000 × 2000 px. O Flutter decodifica imagens na resolução
  do arquivo, não na do widget, então o selo da marca ocupava cerca de **15 MB de
  memória** para ser desenhado a 30–48 px, em três telas. `BrandMark` agora passa
  `cacheWidth`/`cacheHeight` calculados pelo tamanho pedido vezes o
  `devicePixelRatio`, derrubando o custo para menos de 0,1 MB sem perder nitidez.
- `CardDetailScreen` criava um `TextEditingController` sem `dispose()`, vazando um
  controller a cada abertura de tarefa. Corrigido.

### Estado de tarefa concluída

`TaskCompletion` guarda, em memória, quais tarefas foram concluídas no dia. É
compartilhado entre a tela principal e a de ciclo de foco: terminar um ciclo marca
a tarefa como feita na lista. A marcação é **apenas visual** neste MVP — o status
no Supabase não muda, porque o enum do schema (`nao_iniciada`,
`em_desenvolvimento`, `parada`) não tem um valor para "concluída".

---

## Fluxo de telas

```
Cadastro → Onboarding (escolha do ciclo) → Constancia (tela principal)
                                              ├── Card (detalhe + comentários)
                                              │     └── Ciclo de foco (timer)
                                              ├── Board (aba)
                                              └── Travados (aba)
```

- **Cadastro** — validação de e-mail, regras de senha em tempo real e confirmação.
- **Onboarding** — escolha do ciclo de foco (25/5, 50/10, 60/20 ou personalizado).
- **Constancia** — streak, multiplicador, escudos, pontos, gráfico dos últimos 7
  dias, tarefas do dia e ranking do time.
- **Board** — cards agrupados por status (Não iniciada / Em desenvolvimento / Parada).
- **Detalhe do card** — comentários de amigos e início de um ciclo de foco.
- **Ciclo de foco** — timer com fases de foco e descanso.
- **Travados** — cards bloqueados com o motivo.
- **Configurações** — pelo ícone de engrenagem na tela principal.

## Estrutura de pastas

```
lib/
  main.dart              inicializa o Supabase e sobe o app
  data/                  Supabase, fallback local, AppUser, TaskCompletion
  models/                TaskCardModel, FocusCycle
  screens/               uma tela por arquivo
  theme/                 cores e tipografia centralizadas
  widgets/               BrandMark, TaskCard, CycleOptionCard
supabase/
  schema.sql             schema + dados mockados
assets/                  logo, ícones e splash
test/                    teste de widget da tela de cadastro
```

## Identidade visual

- **Marca:** sempre grafada `constancia.` — minúscula, com ponto. Nunca
  "Constancia" ou "ConstânciaPomodoro". O selo em `assets/logo.png` é a fonte
  única da wordmark e é renderizado pelo widget `BrandMark`.
- **Tipografia:** [Manrope](https://fonts.google.com/specimen/Manrope) via `google_fonts`.
- **Paleta** (`lib/theme/app_colors.dart`):

  | Uso | Hex |
  |---|---|
  | Primária / marca | `#E2632E` |
  | Primária escura | `#B84A1F` |
  | Destaque amarelo | `#F5B942` |
  | Destaque laranja (streak/gráfico) | `#F08A3C` |
  | Fundo | `#FFF8EF` |
  | Superfície (cards) | `#FFFFFF` |
  | Texto primário | `#2B211C` |
  | Texto secundário | `#7A6F63` |
  | Divisor | `#E9DFD1` |
  | Status: parada | `#D9534F` |
  | Status: em desenvolvimento | `#4C6FA0` |
  | Status: não iniciada | `#9B9B93` |

## Tecnologias

- **Flutter** / **Dart**
- **supabase_flutter** — persistência
- **google_fonts** — tipografia da marca

## Próximos passos

- Autenticação real (o cadastro ainda não fala com backend)
- Restringir as políticas de RLS quando houver login — ver pendência 4 do `MERGE.md`
- Representar "tarefa concluída" no schema, para a marcação sair da memória
- Ciclo "personalizado" com input de minutos

## Vídeo demonstrativo

https://drive.google.com/file/d/1a-1LEiulSzd3r_bb58UxhtTSvMCIxYIN/view?usp=drive_link

## Integrantes do grupo

| Integrante | RM |
|---|---|
| Antônio Santana | 565516 |
| Bento Garcia | 561621 |
| Enzo Ribeiro | 564216 |
| Guilherme Domingues | 565157 |
| Gustavo Braga | 562247 |
| Kaio Correa | 563443 |
| Lucas Mendes | 563667 |
