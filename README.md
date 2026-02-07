# Quicky Dashboard (Next.js)

Este repositório foi migrado de Flutter para Next.js. O projeto Flutter original foi preservado em `flutter_legacy/`.

## Requisitos

- Node.js 18+ (recomendado 20+)
- npm (ou pnpm/yarn/bun)

## Como rodar

```bash
npm install
npm run dev
```

Acesse `http://localhost:3000`.

## Estrutura

- `src/app/` -> rotas e páginas (App Router)
- `public/` -> arquivos estáticos
- `public/flutter_assets/` -> assets migrados do Flutter
- `flutter_legacy/` -> projeto Flutter original (somente referência)

## Rotas principais (quicky_dashboard)

- `/quickysolutionsllcdashboard`
- `/dashboardQuickyTasks`
- `/dashboardQuickyTasksCopyCopy`
- `/alluserapage`
- `/taskspreprontas`
- `/createPreTasks`
- `/createPreTasksCopy`
- `/edittask`
- `/events`
- `/appAnalystics`
- `/quickyTestRealTime`
