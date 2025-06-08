📱 Aplicación Móvil de Buenas Prácticas de Salud

Esta aplicación móvil ha sido desarrollada en Android Studio con Flutter y Firebase. Su objetivo es brindar apoyo a personas con problemas de adicciones como alcoholismo, drogadicción y ludopatía mediante un sistema educativo, un chatbot de ayuda, foros de discusión y actividades saludables.

🧹 Características

Registro e inicio de sesión de usuarios.

Chatbot de ayuda para orientación inicial.

Foros interactivos para discusión y soporte.

Actividades anti-adicciones con seguimiento.

Diseño responsivo e intuitivo.

🤪 Pruebas y Monitoreo

Se implementaron pruebas automatizadas utilizando el paquete flutter_test. Las pruebas se dividen en dos grupos principales:

🔹 ForumScreen Tests

✅ Validación de URLs vacías o no válidas para imágenes de usuario (getUserImage)

✅ Conversión automática de URLs de Google de http a https

✅ Verificación de carga de imágenes locales y remotas

✅ Renderizado del widget sin errores

✅ Inicialización correcta de controladores (TextEditingController, ScrollController)

✅ Validación de mensajes vacíos

✅ Comprobación de estados booleanos (isLiked, isAuthor, isPostingMessage)

🔹 CommentsDialog Tests

✅ Lógica de carga de imágenes por URL o asset

✅ Inicialización correcta de variables (isLoading, isPosting, comments)

🔍 Ejemplo de test (fragmento):

  testWidgets('getUserImage returns default asset for empty URL',
      (WidgetTester tester) async {
    final state = _ForumScreenTestHelper();
    final imageProvider = state.testGetUserImage('');
    expect(imageProvider, isA<AssetImage>());
    expect((imageProvider as AssetImage).assetName, 'assets/images/user.jpg');
  });

📈 Herramientas complementarias usadas

flutter_test: para pruebas de widgets y unidad.

TextEditingController, ScrollController: para pruebas de estado y comportamiento.

expect, isA, find: funciones para validaciones.

Estas pruebas permiten asegurar la estabilidad y funcionalidad de los componentes visuales y lógicos del sistema, especialmente útiles en entornos móviles donde el rendimiento y la confiabilidad son cruciales.

🛠️ Tecnologías utilizadas

Flutter: Framework de UI

Firebase: Backend (Auth, Firestore)

Android Studio: IDE de desarrollo

Git + GitHub/GitLab: Control de versiones

🧐 Refactorización y Mejores Prácticas

Durante el desarrollo se aplicaron principios SOLID y buenas prácticas como:

Modularización del código.

Reutilización de componentes.

Separación de lógica y vista.

🧾 Documentación

Documentación automática con comentarios ///

Capturas de pantalla del sistema

Informe técnico dividido en 3 fases

👥 Autores

[Tu Nombre Aquí] – Desarrollo móvil y pruebas

Equipo completo – Investigación, diseño y documentación

🏑 Estado del Proyecto

🚧 Proyecto en desarrollo. Algunas funciones están en etapa de pruebas.


