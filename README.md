# Quicky DashboardAdmin

A new Flutter project.

## Getting Started

FlutterFlow projects are built to run on the Flutter _stable_ release.

## Deploy web (quicky-dashboard)

Para gerar o build web e fazer deploy no Firebase Hosting do site `quicky-dashboard`, rode (no diretório raiz do projeto):

```bash
deploy_quicky_dashboard.bat
```

O script faz:
- `flutter build web --release`
- copia `build/web` para `firebase/public`
- `firebase deploy --only hosting:quicky-dashboard --project quick-b108e --config firebase.json`
