# Como rodar o Constancia no seu computador

Este projeto foi montado à mão (lib/ + pubspec.yaml), então antes de rodar
você precisa deixar o Flutter gerar as pastas de plataforma (android/, ios/, web/...).

## Passo a passo

1. Extraia este zip em uma pasta, ex: `constancia/`
2. Abra o terminal dentro dela e rode:

   ```bash
   flutter create .
   ```

   Isso gera android/, ios/, web/, etc. **sem sobrescrever** o `lib/main.dart`
   e o `pubspec.yaml` que já existem (o Flutter detecta que já há um projeto
   e só completa o que falta).

3. Baixe as dependências:

   ```bash
   flutter pub get
   ```

4. Rode o app (emulador, dispositivo físico ou Chrome):

   ```bash
   flutter run
   ```

## O que já está implementado

- **Onboarding** — seleção de ciclo de foco (25/5, 50/10, 60/20, personalizado)
- **Board** — cards agrupados por estado (Não iniciada / Em desenvolvimento / Parada), com dados mockados iguais ao design
- **Constancia** — streak, multiplicador, escudos, pontos, gráfico dos últimos 7 dias e ranking do time
- **Travados** — lista de cards bloqueados com o motivo do bloqueio
- Tema completo (cores, tipografia Inter) aplicado via `lib/theme/`

## Ainda não implementado (próximos passos)

- Tela de **Card** (detalhe, comentários, "iniciar ciclo de foco")
- Tela de **Ciclo de foco** (timer circular contando)
- Tela de **Configurações**
- Persistência de dados (hoje é tudo mockado em memória)
