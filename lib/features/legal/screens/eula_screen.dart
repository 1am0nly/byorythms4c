import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';

const _eulaTextRu = '''
ЛИЦЕНЗИОННОЕ СОГЛАШЕНИЕ С КОНЕЧНЫМ ПОЛЬЗОВАТЕЛЕМ (EULA)

Последнее обновление: 06 июля 2026 г.

Настоящее Лицензионное соглашение (далее — «Соглашение») является юридически обязательным договором между вами (далее — «Пользователь») и независимым разработчиком по имени Anton Ignasev (далее — «Лицензиар»), регулирующим использование мобильного приложения «Биоритмы» (Biorhythms) (далее — «Приложение»).

Устанавливая, копируя или иным образом используя Приложение, вы соглашаетесь с условиями настоящего Соглашения. Если вы не согласны, не устанавливайте и не используйте Приложение.

1. ПРЕДМЕТ СОГЛАШЕНИЯ И ПРЕДОСТАВЛЕНИЕ ЛИЦЕНЗИИ
1.1. Лицензиар предоставляет Пользователю ограниченную, неисключительную, непередаваемую, отзывную лицензию на загрузку, установку и использование Приложения на одном мобильном устройстве, принадлежащем Пользователю, исключительно для личного некоммерческого использования.
1.2. Приложение предоставляется Пользователю бесплатно с возможностью приобретения Premium-подписки для доступа к расширенному функционалу (далее — «Подписка»).

8. ПЛАТНАЯ ПОДПИСКА PREMIUM
8.1. Приложение предлагает Premium-подписку (месячную и годовую) с автоматическим продлением и предоставлением бесплатного пробного периода.
8.2. Оплата снимается с аккаунта Пользователя в App Store / Google Play в течение 24 часов до окончания текущего периода. Продление происходит автоматически до отказа от подписки.
8.3. Пользователь может управлять подпиской и отказаться от нее в настройках аккаунта App Store / Google Play не менее чем за 24 часа до окончания текущего периода.
8.4. При отмене подписки доступ к Premium-функциям сохраняется до конца оплаченного периода.
8.5. Бесплатный пробный период: при оформлении годовой подписки Пользователю предоставляется 3-дневный бесплатный доступ ко всем Premium-функциям. Если подписка не будет отменена до истечения пробного периода, она автоматически перейдет в платную. Неиспользованная часть пробного периода аннулируется при покупке.

2. ОГРАНИЧЕНИЕ ИСПОЛЬЗОВАНИЯ
2.1. Пользователь не имеет права:
- Копировать, изменять, адаптировать, переводить или создавать производные работы на основе Приложения.
- Декомпилировать, разбирать, осуществлять реверс-инжиниринг или иным образом пытаться извлечь исходный код Приложения.
- Использовать Приложение в любых коммерческих целях или для предоставления услуг третьим лицам.

3. ОТКАЗ ОТ МЕДИЦИНСКИХ ГАРАНТИЙ И ОГРАНИЧЕНИЕ ОТВЕТСТВЕННОСТИ
3.1. ИСКЛЮЧИТЕЛЬНО РАЗВЛЕКАТЕЛЬНЫЙ ХАРАКТЕР. Пользователь признает и соглашается с тем, что теория классических биоритмов (физического, эмоционального, интеллектуального циклов) является альтернативной и развлекательной концепцией, не признанной доказанной наукой и медициной.
3.2. Приложение НЕ является медицинским устройством, не предназначено для диагностики, лечения, профилактики заболеваний или прогнозирования медицинских состояний. Информация в Приложении не заменяет профессиональную медицинскую консультацию, диагностику или лечение.
3.3. Приложение предоставляется на условиях «КАК ЕСТЬ» (AS IS) и «КАК ДОСТУПНО» (AS AVAILABLE). Лицензиар не гарантирует точность, полноту или полезность расчетов, графиков и уведомлений.
3.4. Лицензиар не несет ответственности за любые прямые, косвенные, случайные или штрафные убытки, возникшие в результате использования или невозможности использования Приложения, включая, помимо прочего, неверную интерпретацию Пользователем данных Приложения.

4. КОНФИДЕНЦИАЛЬНОСТЬ И ДАННЫЕ
4.1. Приложение разработано с приоритетом конфиденциальности. Все вводимые данные (имена, даты рождения, параметры циклов) обрабатываются и хранятся исключительно локально на мобильном устройстве Пользователя.
4.2. Приложение не передает персональные данные Пользователя на внешние серверы Лицензиара или третьих лиц.

5. ПРИМЕНИМОЕ ПРАВО И РАЗРЕШЕНИЕ СПОРОВ
5.1. Настоящее Соглашение регулируется и толкуется в соответствии с законодательством Финляндии, без учета его коллизионных норм.
5.2. Все споры, возникающие из настоящего Соглашения, подлежат разрешению путем переговоров. Если спор не может быть разрешен мирным путем, он передается на рассмотрение в компетентный суд по месту нахождения Лицензиара.

6. ИЗМЕНЕНИЯ СОГЛАШЕНИЯ
6.1. Лицензиар оставляет за собой право изменять настоящее Соглашение в любое время. Обновленная версия Соглашения вступает в силу с момента ее публикации в Приложении или на странице магазина приложений.

7. КОНТАКТНАЯ ИНФОРМАЦИЯ
По всем вопросам, связанным с настоящим Соглашением, вы можете связаться с Лицензиаром по адресу электронной почты: ant.ignasev@gmail.com.
''';

const _eulaTextEn = '''
END USER LICENSE AGREEMENT (EULA)

Last updated: July 6, 2026

This End User License Agreement (the "Agreement") is a legally binding agreement between you ("User") and independent developer Anton Ignasev ("Licensor") governing the use of the mobile application "Biorhythms" (the "App").

By installing, copying, or otherwise using the App, you agree to be bound by this Agreement. If you do not agree, do not install or use the App.

1. SUBJECT OF THE AGREEMENT AND LICENSE GRANT
1.1. The Licensor grants the User a limited, non-exclusive, non-transferable, revocable license to download, install, and use the App on one mobile device owned by the User for personal, non-commercial use only.
1.2. The App is provided free of charge with the option to purchase a Premium subscription for access to extended functionality (the "Subscription").

8. PREMIUM PAID SUBSCRIPTION
8.1. The App offers Premium subscriptions (monthly and yearly) with auto-renewal and a free trial period.
8.2. Payment is charged to the User's App Store / Google Play account within 24 hours before the end of the current period. Renewal is automatic until cancelled.
8.3. The User may manage and cancel the subscription in their App Store / Google Play account settings at least 24 hours before the end of the current period.
8.4. Upon cancellation, access to Premium features remains until the end of the paid period.
8.5. Free trial: when subscribing to the yearly plan, the User receives a 3-day free trial of all Premium features. If not cancelled before the trial ends, it will automatically convert to a paid subscription. Any unused portion of the trial is forfeited upon purchase.

2. RESTRICTIONS ON USE
2.1. The User may not:
- Copy, modify, adapt, translate, or create derivative works based on the App.
- Decompile, disassemble, reverse engineer, or otherwise attempt to derive the source code of the App.
- Use the App for any commercial purpose or to provide services to third parties.

3. MEDICAL DISCLAIMER AND LIMITATION OF LIABILITY
3.1. ENTERTAINMENT PURPOSE ONLY. The User acknowledges and agrees that the theory of classical biorhythms (physical, emotional, intellectual cycles) is an alternative and entertainment concept not recognized by evidence-based science or medicine.
3.2. The App is NOT a medical device and is not intended to diagnose, treat, prevent, or predict medical conditions. Information in the App does not replace professional medical advice, diagnosis, or treatment.
3.3. The App is provided "AS IS" and "AS AVAILABLE". The Licensor does not guarantee the accuracy, completeness, or usefulness of calculations, charts, or notifications.
3.4. The Licensor is not liable for any direct, indirect, incidental, or punitive damages arising from the use or inability to use the App, including but not limited to the User's misinterpretation of App data.

4. PRIVACY AND DATA
4.1. The App is designed with privacy as a priority. All entered data (names, birth dates, cycle parameters) is processed and stored exclusively locally on the User's mobile device.
4.2. The App does not transmit personal data to external servers of the Licensor or third parties.

5. GOVERNING LAW AND DISPUTE RESOLUTION
5.1. This Agreement is governed by and construed in accordance with the laws of Finland, without regard to its conflict of laws provisions.
5.2. Any disputes arising from this Agreement shall be resolved through negotiation. If not resolved amicably, the dispute shall be submitted to the competent court of the Licensor's location.

6. CHANGES TO THE AGREEMENT
6.1. The Licensor reserves the right to modify this Agreement at any time. The updated version takes effect upon publication in the App or on the app store page.

7. CONTACT INFORMATION
For any questions regarding this Agreement, you may contact the Licensor at: ant.ignasev@gmail.com.
''';

String _eulaText(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'en' ? _eulaTextEn : _eulaTextRu;

class EulaScreen extends StatelessWidget {
  const EulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.eula)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _eulaText(context),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
            Center(
              child: FilledButton.icon(
                icon: const Icon(Icons.mail_outline),
                label: Text(s.aboutContact),
                onPressed: () => launchUrl(
                  Uri.parse('mailto:ant.ignasev@gmail.com?subject=Biorhythms%20EULA'),
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
