# constancia.

> Esta árvore é a unificação dos repositórios `constancia_app` (principal) e
> `pomodoro_app` (fork). O registro completo do que foi juntado, como cada
> conflito foi resolvido e o que ainda depende de decisão do grupo está em
> **[MERGE.md](MERGE.md)** — leia antes de commitar.

## O Problema

Quantas vezes você tentou estudar ou trabalhar, mas acabou perdendo o foco rapidamente por causa de notificações, cansaço ou aquela sensação sufocante de ter tarefas demais acumuladas? A rotina atual fragmenta a nossa atenção, gerando frustração, procrastinação constante e a exaustiva impressão de que o dia passou sem que nada produtivo fosse concluído de verdade.

## A Nossa Solução

O **constancia.** surge para transformar essa realidade de forma leve, prática e humanizada. Mais do que um cronômetro comum, o app adapta a técnica Pomodoro para um fluxo intuitivo que divide grandes responsabilidades em ciclos equilibrados de foco e pausas restauradoras. O objetivo é ajudar você a manter um ritmo constante, reduzir a ansiedade do dia a dia e produzir com consistência, sem desgaste mental.

Amigos acompanham e comentam nas suas tarefas, e você mantém uma sequência de dias consecutivos — a constância que dá nome ao app.

## Status atual

O app roda de ponta a ponta **com backend real (Supabase)**, com fallback local
quando não há conexão. Telas implementadas:

- **Cadastro** — formulário com validação de e-mail, regras de senha em tempo real e confirmação.
- **Onboarding** — escolha do ciclo de foco (25/5, 50/10, 60/20 ou personalizado).
- **Tela principal (constancia.)** — streak, multiplicador, escudos, pontos, gráfico dos últimos 7 dias e ranking do time.
- **Board** — cards de tarefas agrupados por status (Não iniciada / Em desenvolvimento / Parada).
- **Detalhe do card** — abre a partir do Board ou da tela principal, com comentários de amigos e opção de iniciar um ciclo de foco.
- **Ciclo de foco** — timer contando o ciclo escolhido.
- **Travados** — lista de cards bloqueados com o motivo do bloqueio.
- **Configurações** — acessível pelo ícone de engrenagem na tela principal.

## Arquitetura de dados

- **Banco: Supabase.** Escolhido em vez do Firebase porque os dados do app são
  relacionais por natureza — tarefas pertencem a um usuário, comentários
  pertencem a uma tarefa, o ranking cruza pontos entre usuários. Isso mapeia
  diretamente para tabelas SQL, e o setup no Flutter é mais simples (só URL e
  chave, sem configuração nativa por plataforma).
- **Schema** (`supabase/schema.sql`): três tabelas — `profiles` (pessoas,
  streak, pontos), `tasks` (tarefas, ligadas a um dono) e `task_comments`
  (comentários de amigos numa tarefa).
- **Modo offline com fallback:** toda tela que busca dados do Supabase
  (`ConstanciaScreen`, `BoardScreen`, `CardDetailScreen`) começa mostrando dados
  locais (`lib/data/sample_tasks.dart`) e troca pelos reais assim que a busca
  termina. Se falhar, a tela segue funcional com os dados locais e exibe um
  aviso discreto — isso evita que a apresentação trave por causa da rede.
- **RLS aberta (protótipo):** as políticas de Row Level Security estão como
  leitura/escrita abertas, já que ainda não há autenticação real. Veja a
  pendência 4 do `MERGE.md` antes de deixar o repositório público.

## Identidade visual

> ⚠️ **Em aberto.** O principal e o fork seguiram direções diferentes — laranja
> com Manrope contra verde escuro com Inter. Esta árvore mantém a versão do
> fork, por ser a mais recente, mas o README do principal documentava a paleta
> laranja como decisão de marca. **Pendência 1 do [MERGE.md](MERGE.md).**

- **Marca:** grafada `constancia.` — minúscula, com ponto. O selo em
  `assets/logo.png` é a fonte única da wordmark e é renderizado pelo widget
  `BrandMark` (`lib/widgets/brand_mark.dart`), hoje sem uso nas telas.
- **Paleta:** `lib/theme/app_colors.dart`
- **Tipografia:** via `google_fonts`, aplicada em `lib/theme/app_theme.dart`

## Estrutura de pastas

```
lib/
  main.dart              inicializa o Supabase e sobe o app
  data/                  fontes de dados: Supabase, fallback local, AppUser
  models/                modelos (TaskCardModel, FocusCycle)
  screens/               uma tela por arquivo
  theme/                 cores e tipografia centralizadas
  widgets/               componentes reutilizáveis
supabase/
  schema.sql             schema + dados mockados
assets/                  logo, ícones e splash
test/                    teste de widget da tela de cadastro
```

## Tecnologias

- **Flutter** 3.47 (stable) · **Dart** 3.13
- **supabase_flutter** para persistência
- **google_fonts** para a tipografia da marca

## Como rodar localmente

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e no `PATH`.

```bash
flutter pub get
flutter run          # dispositivo ou emulador conectado
flutter run -d chrome   # sem Android/iOS configurado
```

As credenciais do Supabase já vêm no projeto (`lib/data/supabase_config.dart`),
então não há configuração extra para testar.

Antes de subir qualquer mudança:

```bash
flutter analyze
flutter test
```

> O teste atual falha nesta árvore — ver pendência 2 do [MERGE.md](MERGE.md).

## Próximos passos

- Resolver as quatro pendências do `MERGE.md`
- Autenticação real (o cadastro ainda não fala com backend)
- Restringir as políticas de RLS quando houver login
- Ciclo "personalizado" com input de minutos
- Representar "tarefa concluída" no schema

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
