# Unificação dos repositórios `constancia_app` + `pomodoro_app`

Registro do que foi juntado, como cada conflito foi resolvido e o que ainda
depende de decisão do grupo.

## Ponto de partida

| | `constancia_app` (principal) | `pomodoro_app` (fork) |
|---|---|---|
| Data dos arquivos | 30/08/2026 | 03/10/2026 |
| Total de arquivos | 156 | 28 |
| Projeto Flutter completo | sim — `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`, `assets/`, `test/` | **não** — só `lib/`, `pubspec`, `supabase/` |
| Backend | nenhum (dados mockados em memória) | **Supabase** (3 tabelas + RLS) |
| Identidade visual | laranja/amarelo, fonte Manrope, selo `BrandMark` | verde escuro, fonte Inter, sem selo |

O fork está **cinco semanas à frente** em código e entregou exatamente o item
nº 1 do roadmap que o próprio README do principal listava em "Próximos passos":
*"Persistência real (hoje tudo é mockado em memória)"*.

Em contrapartida, o fork foi criado a partir de um estado anterior do principal
e **não tem** o scaffold de plataforma, os assets, o teste nem dois arquivos de
`lib/` que o principal passou a usar depois.

## Como cada arquivo foi resolvido

| Item | Origem escolhida | Motivo |
|---|---|---|
| `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` | principal | o fork não tem essas pastas; sem elas o projeto não compila para dispositivo |
| `assets/` (logo, ícones, splash) | principal | o fork não tem nenhum asset |
| `test/widget_test.dart` | principal | único teste do projeto — **ver pendência 2** |
| `.metadata` | principal | exclusivo do principal |
| `lib/` (todo) | **fork** | 5 semanas mais novo, com a camada Supabase e telas reescritas |
| `lib/data/task_completion.dart` | principal | preservado — **ver pendência 3** |
| `lib/widgets/brand_mark.dart` | principal | preservado — **ver pendência 1** |
| `supabase/schema.sql` | fork | exclusivo do fork |
| `pubspec.yaml` | fork **+ ajuste** | mantém `supabase_flutter`; a declaração `assets: - assets/logo.png` foi **restaurada** do principal, porque nesta árvore o arquivo existe e o `BrandMark` depende dele |
| `pubspec.lock` | fork | acompanha as dependências do fork |
| `analysis_options.yaml` | **principal** | o fork havia removido as exclusões de `android/`, `ios/`, `web/`… porque não tinha essas pastas; aqui elas existem, e sem a exclusão o analyzer passaria a varrê-las |
| `.gitignore` | principal | é superconjunto do outro (inclui as linhas de Node/Expo) |
| `SETUP.md` | qualquer um | arquivos idênticos |
| `README.md` | mesclado | ver o arquivo |

## Pendências — decisões que são do grupo

### 1. Identidade visual: há duas direções em conflito

Esta é a única divergência que **não** foi resolvida automaticamente, porque não
é questão técnica.

| | principal (30/08) | fork (03/10) |
|---|---|---|
| Cor primária | `#E2632E` laranja queimado | `#2E5C50` verde escuro |
| Fundo | `#FFF8EF` off-white quente | `#EEECE6` off-white neutro |
| Destaque amarelo | `#F5B942` | *removido* |
| Tipografia | Manrope | Inter |
| Título do app | `'constancia.'` | `'Constancia'` |
| Selo da marca | `BrandMark` em 3 telas | removido |
| Figma citado no código | "constancia." | "Constancia - telas do app" |

O README do principal é categórico: *"**Marca:** sempre grafada `constancia.`
(minúscula, com ponto) — nunca 'Constancia'"*, e documenta a paleta laranja como
decisão de marca. O fork contraria os dois pontos.

**Não dá para saber, a partir dos arquivos, se o fork seguiu um Figma mais novo
aprovado pelo grupo ou se partiu de um estado anterior à decisão da marca.**
Por isso o código do fork foi mantido como está.

**Se a identidade válida for a do principal (laranja/Manrope/`constancia.`)**, a
restauração é segura e pequena. O `AppColors` do principal é superconjunto do do
fork — tem todos os nomes que o fork usa, mais `accentYellow`, que o fork não
referencia. Logo, trocar os dois arquivos de tema **não quebra nenhuma tela**:

```bash
# a partir das duas pastas originais extraídas lado a lado
cp constancia_app-main/lib/theme/app_colors.dart  constancia_app-unificado/lib/theme/
cp constancia_app-main/lib/theme/app_theme.dart   constancia_app-unificado/lib/theme/
```

Falta ainda, nesse caso, reverter o título em `lib/main.dart`
(`'Constancia'` → `'constancia.'`) e reinserir `const BrandMark(logoSize: N)`
em `cadastro_screen.dart`, `onboarding_screen.dart` e `constancia_screen.dart`
— uma linha em cada, com o `import '../widgets/brand_mark.dart';` no topo.

### 2. O teste existente vai falhar

`test/widget_test.dart` termina com:

```dart
expect(find.byType(Image), findsOneWidget);
```

Essa `Image` vinha do `BrandMark` na tela de cadastro. A versão do fork dessa
tela não tem nenhuma `Image`, então **o teste falha nesta árvore unificada**.

Dois caminhos, conforme a decisão da pendência 1: reinserir o `BrandMark` (o
teste volta a passar sem alteração) ou remover essa linha do teste.

> Não foi possível rodar `flutter analyze` nem `flutter test` durante a
> unificação — o SDK do Flutter não estava disponível no ambiente onde o merge
> foi feito. Rode os dois antes de commitar.

### 3. `task_completion.dart` ficou sem referência

`TaskCompletion` era um `Set` em memória que marcava tarefas concluídas no dia.
Era usado por `focus_cycle_screen.dart` e `constancia_screen.dart` no principal,
mas as versões do fork dessas telas não o importam — o fork passou o controle de
estado para o Supabase (`SupabaseService.updateTaskStatus`).

O arquivo foi **preservado, mas está órfão**. Vale notar que os dois conceitos
não são equivalentes: o `TaskStatus` do Supabase tem três valores
(`nao_iniciada`, `em_desenvolvimento`, `parada`) e **nenhum deles representa
"concluída"**. Se o check de tarefa concluída ainda faz parte do produto, ele
precisa de uma coluna nova no schema — não é algo que o Supabase já cubra.

Decidam entre: apagar o arquivo, ou levar o conceito de "concluída" para o banco.

### 4. Segurança: chave e políticas abertas em repositório público

`lib/data/supabase_config.dart` traz a URL e a `anon key` do projeto Supabase
versionadas. O comentário do próprio arquivo está correto ao dizer que a anon key
é pública por design — **desde que o Row Level Security proteja os dados**.

O problema é o `supabase/schema.sql`:

```sql
create policy "Leitura e escrita abertas (protótipo)" on profiles
  for all using (true) with check (true);
```

As três tabelas (`profiles`, `tasks`, `task_comments`) têm RLS **habilitado mas
totalmente aberto**. Na prática, qualquer pessoa que encontre o repositório pode
ler, alterar e **apagar** todos os registros do banco.

Para um protótipo de apresentação isso pode ser aceitável — mas é uma escolha
consciente, não um detalhe. Se o repositório for público e o banco precisar
sobreviver até a entrega, considerem restringir as políticas de escrita ou ter
um backup do `schema.sql` com os dados mockados para repopular.

## Como fazer isso preservando o histórico do Git

A árvore unificada foi montada a partir de **snapshots** (os zips do GitHub), que
não trazem `.git`. Ou seja: ela tem o conteúdo certo, mas **não tem o histórico de
commits nem a autoria** de quem fez o trabalho no fork.

Se o histórico importa — e normalmente importa, porque mostra a contribuição de
cada integrante —, o caminho é fazer o merge com os repositórios de verdade:

```bash
# 1) clone o principal
git clone https://github.com/<org>/constancia_app.git
cd constancia_app

# 2) adicione o fork como um segundo remoto
git remote add fork https://github.com/<integrante>/pomodoro_app.git
git fetch fork

# 3) veja o que diverge antes de juntar
git log --oneline --graph --left-right HEAD...fork/main
git diff --stat HEAD fork/main

# 4) merge numa branch própria, nunca direto na main
git switch -c merge/supabase
git merge fork/main --allow-unrelated-histories
#    resolva os conflitos usando este arquivo como guia
git push -u origin merge/supabase
```

Depois abra um Pull Request de `merge/supabase` para `main`. Assim o grupo revisa
junto, os commits do integrante aparecem com o nome dele, e a decisão da
identidade visual pode ser discutida nos comentários do PR.

Se o fork for de fato um fork do GitHub, há um caminho ainda mais direto: o
próprio integrante abre o PR do fork dele para o repositório principal pela
interface do GitHub, e o `--allow-unrelated-histories` nem é necessário.

A árvore unificada deste pacote serve como **referência da resolução** e como
plano B, caso o histórico não possa ser recuperado.
