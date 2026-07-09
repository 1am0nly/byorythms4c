import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';

const _privacyTextRu = '''
ПОЛИТИКА КОНФИДЕНЦИАЛЬНОСТИ МОБИЛЬНОГО ПРИЛОЖЕНИЯ «БИОРИТМЫ»

Последнее обновление: 06 июля 2026 г.

Независимый разработчик Anton Ignasev (далее — «Разработчик») ценит вашу конфиденциальность. Настоящая Политика конфиденциальности (далее — «Политика») описывает, как мобильное приложение «Биоритмы» (Biorhythms) (далее — «Приложение») обрабатывает информацию Пользователей.

1. СБОР И ИСПОЛЬЗОВАНИЕ ИНФОРМАЦИИ
1.1. Данные, вводимые пользователем. Для расчета биоритмов Приложение запрашивает ввод определенных данных: имя (или псевдоним) и дату рождения. При включении женского режима также могут вводиться параметры менструального цикла.
1.2. Локальное хранение. ВСЕ вводимые вами данные обрабатываются и хранятся ИСКЛЮЧИТЕЛЬНО ЛОКАЛЬНО на вашем мобильном устройстве (в защищенной локальной базе данных). Разработчик не имеет доступа к этим данным, не собирает их, не хранит на внешних серверах и не передает третьим лицам.
1.3. Приложение не использует инструменты сторонней аналитики или рекламные сети, собирающие идентификаторы устройств или геолокацию на момент публикации данной версии.

2. РАЗРЕШЕНИЯ УСТРОЙСТВА
Для полноценного функционирования Приложение может запрашивать следующие разрешения (только с вашего явного согласия):
2.1. Локальные уведомления. Используются для отправки ежедневных сводок о состоянии ваших биоритмов. Вы можете отключить их в любой момент в настройках устройства или Приложения.
2.2. Биометрическая аутентификация (локальная). Если вы активируете функцию защиты приватности в настройках Приложения, оно будет запрашивать доступ к Face ID / Touch ID / сканеру отпечатков пальцев. Проверка биометрии происходит на уровне операционной системы вашего устройства; Приложение не получает доступ к вашим биометрическим шаблонам.

3. ПРАВА ПОЛЬЗОВАТЕЛЯ И УДАЛЕНИЕ ДАННЫХ
3.1. Поскольку все данные хранятся локально на вашем устройстве, вы полностью контролируете их.
3.2. Вы можете изменить, исправить или полностью удалить все введенные профили и данные непосредственно внутри Приложения через меню Настроек.
3.3. Полное удаление Приложения с вашего мобильного устройства автоматически и безвозвратно уничтожает все данные, сохраненные Приложением.

4. БЕЗОПАСНОСТЬ ДАННЫХ
Разработчик стремится обеспечить безопасность ваших данных, используя стандартные механизмы защиты операционных систем Android и iOS для изоляции данных приложений.

5. ПЛАТЕЖНЫЕ ДАННЫЕ
5.1. При оформлении Premium-подписки обработка платежей осуществляется исключительно платформами App Store (Apple) и Google Play. Разработчик не получает, не хранит и не обрабатывает платежные данные Пользователя (номера кредитных карт, данные банковских счетов и т.д.).
5.2. Информация о статусе подписки (активна/неактивна, дата истечения) хранится локально на устройстве для корректного отображения доступа к Premium-функциям.
5.3. Разработчик не получает от Apple/Google персональные данные, идентифицирующие Пользователя при совершении покупки, за исключением анонимного идентификатора транзакции.

6. ИЗМЕНЕНИЯ В ПОЛИТИКЕ КОНФИДЕНЦИАЛЬНОСТИ
Разработчик может периодически обновлять настоящую Политику конфиденциальности. Рекомендуется регулярно проверять эту страницу на предмет изменений.

7. КОНТАКТЫ
Если у вас есть какие-либо вопросы или предложения относительно настоящей Политики конфиденциальности, пожалуйста, свяжитесь со мной по электронной почте: ant.ignasev@gmail.com.
''';

const _privacyTextEn = '''
PRIVACY POLICY OF THE BIORHYTHMS MOBILE APPLICATION

Last updated: July 6, 2026

Independent developer Anton Ignasev (the "Developer") values your privacy. This Privacy Policy describes how the Biorhythms mobile application (the "App") handles User information.

1. INFORMATION COLLECTION AND USE
1.1. User-entered data. To calculate biorhythms, the App requests certain data: name (or nickname) and date of birth. When female mode is enabled, menstrual cycle parameters may also be entered.
1.2. Local storage. ALL data you enter is processed and stored EXCLUSIVELY LOCALLY on your mobile device (in a secure local database). The Developer does not have access to this data, does not collect it, does not store it on external servers, and does not share it with third parties.
1.3. The App does not use third-party analytics tools or advertising networks that collect device identifiers or geolocation as of the publication of this version.

2. DEVICE PERMISSIONS
For full functionality, the App may request the following permissions (only with your explicit consent):
2.1. Local notifications. Used to send daily summaries of your biorhythms. You may disable them at any time in your device or App settings.
2.2. Biometric authentication (local). If you enable the privacy protection feature in the App settings, it will request access to Face ID / Touch ID / fingerprint scanner. Biometric verification occurs at the operating system level; the App does not access your biometric templates.

3. USER RIGHTS AND DATA DELETION
3.1. Since all data is stored locally on your device, you have full control over it.
3.2. You may change, correct, or delete all entered profiles and data directly within the App through the Settings menu.
3.3. Complete deletion of the App from your mobile device automatically and irreversibly destroys all data saved by the App.

4. DATA SECURITY
The Developer strives to ensure the security of your data using standard operating system protection mechanisms on Android and iOS for app data isolation.

5. PAYMENT DATA
5.1. When purchasing a Premium subscription, payment processing is handled exclusively by App Store (Apple) and Google Play. The Developer does not receive, store, or process User payment data (credit card numbers, bank account details, etc.).
5.2. Subscription status information (active/inactive, expiration date) is stored locally on the device for correct display of Premium feature access.
5.3. The Developer does not receive from Apple/Google any personal data identifying the User when making a purchase, except for an anonymous transaction identifier.

6. CHANGES TO THE PRIVACY POLICY
The Developer may periodically update this Privacy Policy. It is recommended to check this page regularly for changes.

7. CONTACT
If you have any questions or suggestions regarding this Privacy Policy, please contact me by email: ant.ignasev@gmail.com.
''';

String _privacyText(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'en' ? _privacyTextEn : _privacyTextRu;

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.privacyPolicy)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _privacyText(context),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
            Center(
              child: FilledButton.icon(
                icon: const Icon(Icons.mail_outline),
                label: Text(s.aboutContact),
                onPressed: () => launchUrl(
                  Uri.parse('mailto:ant.ignasev@gmail.com?subject=Biorhythms%20Privacy'),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
