# Central de Missões (Flutter + Firestore)

## Como rodar
1. Dentro desta pasta, gere as pastas de plataforma (android/ios/web):
   flutter create .
2. Instale o FlutterFire CLI e configure seu projeto Firebase
   (isso SUBSTITUI o lib/firebase_options.dart):
   dart pub global activate flutterfire_cli
   flutterfire configure
3. No Console do Firebase: Build > Firestore Database > Criar banco
   (modo de teste). A collection "missoes" é criada automaticamente.
4. flutter pub get
5. flutter run

## Estrutura
Page -> Provider -> Service -> Firestore
