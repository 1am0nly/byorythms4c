import 'package:flutter/material.dart';
import 'strings_en.dart';

class AppStrings {
  AppStrings._();

  static const String appTitle = 'Биоритмы';
  static const String appVersion = '0.2.0';
  static const String homeTab = 'Дом';
  static const String infoTab = 'Инфо';
  static const String settingsTab = 'Настройки';
  static const String settings = 'Настройки';
  static const String physical = 'Физический';
  static const String emotional = 'Эмоциональный';
  static const String intellectual = 'Интеллектуальный';
  static const String intuitive = 'Интуитивный';
  static const String today = 'Сегодня';
  static const String days = 'дней';
  static const String biorhythmInfo = 'Информация о биоритмах';
  static const String addProfile = 'Добавить профиль';
  static const String developerName = 'Anton Ignasev';
  static const String developerEmail = 'ant.ignasev@gmail.com';

  static AppStringsLocale of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return AppStringsLocale(locale.languageCode);
  }
}

class AppStringsLocale {
  final String _lang;

  AppStringsLocale(this._lang);

  bool get _isEn => _lang == 'en';

  String get appTitle => _isEn ? AppStringsEn.appTitle : AppStrings.appTitle;
  String get homeTab => _isEn ? AppStringsEn.homeTab : AppStrings.homeTab;
  String get infoTab => _isEn ? AppStringsEn.infoTab : AppStrings.infoTab;
  String get settingsTab => _isEn ? AppStringsEn.settingsTab : AppStrings.settingsTab;
  String get settings => _isEn ? AppStringsEn.settings : AppStrings.settings;
  String get physical => _isEn ? AppStringsEn.physical : AppStrings.physical;
  String get emotional => _isEn ? AppStringsEn.emotional : AppStrings.emotional;
  String get intellectual => _isEn ? AppStringsEn.intellectual : AppStrings.intellectual;
  String get intuitive => _isEn ? AppStringsEn.intuitive : AppStrings.intuitive;
  String get today => _isEn ? AppStringsEn.today : AppStrings.today;
  String get days => _isEn ? AppStringsEn.days : AppStrings.days;
  String get month => _isEn ? 'month' : 'мес.';
  String get addProfile => _isEn ? AppStringsEn.addProfile : AppStrings.addProfile;
  String get biorhythmInfo => _isEn ? AppStringsEn.biorhythmInfo : AppStrings.biorhythmInfo;
  String get compatibility => _isEn ? AppStringsEn.compatibility : 'Совместимость';
  String get yearOverview => _isEn ? AppStringsEn.yearOverview : 'Обзор года';
  String get unlockPremium => _isEn ? AppStringsEn.unlockPremium : 'Все возможности';
  String get delete => _isEn ? 'Delete' : 'Удалить';
  String get cancel => _isEn ? 'Cancel' : 'Отмена';
  String get save => _isEn ? 'Save' : 'Сохранить';
  String get add => _isEn ? 'Add' : 'Добавить';
  String get edit => _isEn ? 'Edit' : 'Редактировать';
  String get name => _isEn ? 'Name' : 'Имя';
  String get birthDate => _isEn ? 'Birth Date' : 'Дата рождения';
  String get profileManagement => _isEn ? 'Profile Management' : 'Управление профилями';
  String get noProfiles => _isEn ? 'No profiles. Add your first!' : 'Нет профилей. Добавьте первый!';
  String get addProfileDialog => _isEn ? 'Add Profile' : 'Добавить профиль';
  String get editProfile => _isEn ? 'Edit Profile' : 'Редактировать профиль';
  String get deleteProfileTitle => _isEn ? 'Delete Profile' : 'Удалить профиль';
  String get deleteProfileConfirm => _isEn ? 'Delete profile «{name}»?' : 'Удалить профиль «{name}»?';
  String get femaleMode => _isEn ? 'Female Mode' : 'Женский режим';
  String get biometricProtection => _isEn ? 'Biometric Protection' : 'Биометрическая защита';
  String get notificationTime => _isEn ? 'Notification Time' : 'Время уведомлений';
  String get dailyPush => _isEn ? 'Daily Push' : 'Ежедневный пуш';
  String get time => _isEn ? 'Time' : 'Время';
  String get forWhom => _isEn ? 'For Whom' : 'Для кого';
  String get theme => _isEn ? 'Appearance' : 'Внешний вид';
  String get system => _isEn ? 'System' : 'Системная';
  String get light => _isEn ? 'Light' : 'Светлая';
  String get dark => _isEn ? 'Dark' : 'Тёмная';
  String get inviteFriend => _isEn ? 'Invite a Friend' : 'Пригласить друга';
  String get yourReferralCode => _isEn ? 'Your Referral Code' : 'Ваш реферальный код';
  String get share => _isEn ? 'Share' : 'Поделиться';
  String get friendsInvited => _isEn ? 'Friends Invited' : 'Приглашено друзей';
  String get premiumDaysEarned => _isEn ? '{count} days of Premium earned' : '{count} дней Premium заработано';
  String get todaySummary => _isEn ? 'Today' : 'Сегодня';
  String get phaseRising => _isEn ? 'Rising' : 'Подъём';
  String get phaseFalling => _isEn ? 'Falling' : 'Спад';
  String get criticalDay => _isEn ? 'Critical Day!' : 'Критический день!';
  String get cycleVisibilitySub => _isEn ? 'Show on chart and summary' : 'Показывать на графике и в сводке';
  String get currentProfile => _isEn ? 'Current Profile' : 'Текущий профиль';
  String get profileSection => _isEn ? 'Profile' : 'ПРОФИЛЬ';
  String get compatibilitySub => _isEn ? 'Compare biorhythms with a partner' : 'Сравнение биоритмов с партнёром';
  String get premiumCard => _isEn ? 'Biorhythms Premium' : 'Биоритмы Premium';
  String get premiumSub => _isEn ? 'All features without limits' : 'Все функции без ограничений';
  String get tryLabel => _isEn ? 'Try' : 'Попробовать';
  String get femaleOn => _isEn ? 'On' : 'Включить';
  String get femaleOff => _isEn ? 'Off' : 'Отключить';
  String get cycleSub => _isEn ? 'Menstrual cycle tracking' : 'Отслеживание менструального цикла';
  String get cycleSettings => _isEn ? 'Cycle Settings' : 'Настройки цикла';
  String get biometricSection => _isEn ? 'Biometrics' : 'БИОМЕТРИЯ';
  String get biometricSubTitle => _isEn ? 'Profile protection' : 'Защита профилей';
  String get biometricOn => _isEn ? 'Enabled' : 'Включена';
  String get biometricOff => _isEn ? 'Disabled' : 'Выключена';
  String get biometricSetupTitle => _isEn ? 'Biometric Setup' : 'Биометрическая защита';
  String get notificationsSection => _isEn ? 'Notifications' : 'УВЕДОМЛЕНИЯ';
  String get aboutSection => _isEn ? 'About' : 'О ПРИЛОЖЕНИИ';
  String get biorhythmEncyclopedia => _isEn ? 'Biorhythm Encyclopedia' : 'Энциклопедия биоритмов';
  String get eula => _isEn ? 'End User License Agreement' : 'Пользовательское соглашение';
  String get privacyPolicy => _isEn ? 'Privacy Policy' : 'Политика конфиденциальности';
  String get feedback => _isEn ? 'Feedback' : 'Обратная связь';
  String get aboutDeveloper => _isEn ? 'About Developer' : 'О разработчике';
  String get version => _isEn ? 'Version' : 'Версия';
  String get pickNotificationTime => _isEn ? 'Pick notification time' : 'Выберите время для ежедневного пуша';
  String get changeTime => _isEn ? 'Change Time' : 'Изменить время';
  String get protectProfilesBiometric => _isEn ? 'Protect profiles with biometrics' : 'Защитите доступ к профилям с помощью биометрии';
  String get biometricDescription => _isEn ? 'When enabled, the app will request fingerprint or Face ID at each launch to access profile data.' : 'При включении приложение будет запрашивать отпечаток пальца или Face ID при каждом запуске для доступа к данным профилей.';
  String get biometricNotSupported => _isEn ? 'Biometrics not supported on this device' : 'Биометрия не поддерживается на этом устройстве';
  String get biometricAuthReason => _isEn ? 'Authenticate to enable biometric protection' : 'Подтвердите личность для включения защиты';
  String get biometricSetup => _isEn ? 'Biometric Setup' : 'Биометрическая защита';
  String get biometricError => _isEn ? 'Biometric verification error' : 'Ошибка проверки биометрии';
  String get biometricErrorSub => _isEn ? 'Please try again later' : 'Попробуйте позже';
  String get close => _isEn ? 'Close' : 'Закрыть';
  String get premiumTitle => _isEn ? 'Biorhythms Premium' : 'Биоритмы Premium';
  String get premiumSubtitle => _isEn ? 'Unlock all app features' : 'Раскройте все возможности приложения';
  String get featureUnlimitedProfiles => _isEn ? 'Unlimited profiles' : 'Безлимитное количество профилей';
  String get feature30Days => _isEn ? '30-day chart instead of 7' : 'График на 30 дней вместо 7';
  String get featureFemaleMode => _isEn ? 'Female mode (menstrual cycle)' : 'Женский режим (менструальный цикл)';
  String get featureBiometric => _isEn ? 'Biometric protection' : 'Биометрическая защита';
  String get featureExport => _isEn ? 'Export charts to PNG/PDF' : 'Экспорт графиков в PNG/PDF';
  String get featureCompatibility => _isEn ? 'Partner compatibility' : 'Совместимость с партнёром';
  String get monthly => _isEn ? 'Month' : 'Месяц';
  String get yearly => _isEn ? 'Year' : 'Год';
  String get badge => _isEn ? 'BEST VALUE' : 'ВЫГОДА';
  String get subscribeButton => _isEn ? 'Start subscription' : 'Начать подписку';
  String trialButtonText(int days) => _isEn
      ? AppStringsEn.trialButtonText(days)
      : 'Попробовать $days ${_dayWord(days)} бесплатно';
  String yearlySubtextText(String price) => _isEn
      ? AppStringsEn.yearlySubtextText(price)
      : 'Далее $price/год. Отмена в любое время.';
  String monthlySubtextText(String price) => _isEn
      ? AppStringsEn.monthlySubtextText(price)
      : 'Далее $price/мес. Отмена в любое время.';

  String _dayWord(int d) {
    if (d >= 11 && d <= 19) return 'дней';
    final mod = d % 10;
    if (mod == 1) return 'день';
    if (mod >= 2 && mod <= 4) return 'дня';
    return 'дней';
  }
  String get privacyLink => _isEn ? 'Privacy Policy' : 'Политика конфиденциальности';
  String get termsLink => _isEn ? 'Terms of Use' : 'Условия использования';
  String get restoreLink => _isEn ? 'Restore' : 'Восстановить';
  String get premiumActivated => _isEn ? 'Premium activated!' : 'Premium активирован!';
  String get onboardingWelcomeTitle => _isEn ? 'Welcome!' : 'Добро пожаловать!';
  String get onboardingWelcomeBody => _isEn ? 'Discover the hidden rhythms of your body. The Biorhythms app helps you visualize physical, emotional, intellectual, and intuitive phases based on your birth date to better plan each day.' : 'Откройте для себя скрытые ритмы своего организма. Приложение «Биоритмы» поможет визуализировать физическую, эмоциональную, интеллектуальную и интуитивную фазы на основе даты рождения, чтобы лучше планировать каждый день.';
  String get onboardingCycleTitle => _isEn ? 'Sine Wave of Life' : 'Синусоида жизни';
  String get onboardingCycleBody => _isEn ? "Human life moves through four biorhythm cycles. Track energy peaks, rest phases, intuition shifts, and critical transition days on an interactive chart. Set up convenient daily summary notifications." : 'Жизнь человека движется по четырем биоритмическим циклам. Следите за подъемами энергии, фазами отдыха, изменениями интуиции и «критическими днями» на интерактивном графике. Настраивайте удобные ежедневные уведомления-сводки.';
  String get onboardingPrivacyTitle => _isEn ? 'Privacy First' : 'Приватность в приоритете';
  String get onboardingPrivacyBody => _isEn ? 'Your personal life stays yours. Names and birth dates are stored exclusively on your device and never sent to the internet. You can protect profile access with biometrics.' : 'Ваша личная жизнь остается только вашей. Имена и даты рождения хранятся исключительно на вашем устройстве и никогда не передаются в интернет. Вы можете защитить доступ к профилям с помощью биометрии.';
  String get next => _isEn ? 'Next' : 'Далее';
  String get addFirstProfile => _isEn ? 'Add First Profile' : 'Добавить первый профиль';
  String get skip => _isEn ? 'Skip' : 'Пропустить';
  String get pageNotFound => _isEn ? 'Page not found' : 'Страница не найдена';
  String get goHome => _isEn ? 'Go to home' : 'На главный экран';
  String get aboutTitle => _isEn ? 'About' : 'О приложении';
  String get aboutAppName => _isEn ? 'Biorhythms' : 'Биоритмы (Biorhythms)';
  String get aboutDeveloperLabel => _isEn ? 'Developer' : 'Разработчик';
  String get aboutAiCredit => _isEn ? 'Artificial intelligence made a significant contribution to creating this app: architecture design, code generation, and UI optimization were done with modern AI tools.' : 'Искусственный интеллект внес значительный вклад в создание этого приложения: проектирование архитектуры, генерация программного кода и оптимизация пользовательского интерфейса выполнены с помощью современных ИИ-инструментов.';
  String get aboutPrivacyNote => _isEn ? 'The app is completely free and respects your privacy: all calculations happen locally on your device and personal data is never sent over the internet.' : 'Приложение является полностью бесплатным и уважает вашу конфиденциальность: все расчеты происходят локально на вашем смартфоне, а персональные данные не передаются в сеть интернет.';
  String get aboutDisclaimer => _isEn ? 'Disclaimer: Classical biorhythm calculations are for entertainment and informational purposes only and are not a medical or diagnostic tool.' : 'Внимание: Расчет классических биоритмов носит исключительно ознакомительный и развлекательный характер и не является медицинским или диагностическим инструментом.';
  String get aboutContact => _isEn ? 'Contact Developer' : 'Написать разработчику';
  String get feedbackTitle => _isEn ? 'Feedback' : 'Обратная связь';
  String get feedbackBody => _isEn ? "Have a suggestion for improving charts, found a bug, or want to suggest a new feature? I'm open to feedback!" : 'У вас есть предложение по улучшению графиков, нашли баг или хотите предложить новую функцию? Я открыт к обратной связи!';
  String get feedbackSubtitle => _isEn ? 'Write to me directly via email. Your opinion will help make Biorhythms even better and more useful.' : 'Напишите мне напрямую на электронную почту. Ваше мнение поможет сделать «Биоритмы» еще удобнее и полезнее.';
  String get feedbackButton => _isEn ? 'Email Developer' : 'Написать разработчику';
  String get compatibilityTitle => _isEn ? 'Compatibility' : 'Совместимость';
  String get compatibilityPerson1 => _isEn ? 'Birth Date — Person 1' : 'Дата рождения — человек 1';
  String get compatibilityPerson2 => _isEn ? 'Birth Date — Person 2' : 'Дата рождения — человек 2';
  String get compatibilityCalculate => _isEn ? 'Calculate Compatibility' : 'Рассчитать совместимость';
  String get compatibilityScore => _isEn ? 'compatibility' : 'совместимость';
  String get compatibilityExcellent => _isEn ? 'Excellent compatibility' : 'Отличная совместимость';
  String get compatibilityGood => _isEn ? 'Good compatibility' : 'Хорошая совместимость';
  String get compatibilityAverage => _isEn ? 'Average compatibility' : 'Средняя совместимость';
  String get compatibilityLow => _isEn ? 'Low compatibility' : 'Низкая совместимость';
  String get yearOverviewTitle => _isEn ? 'Year Overview' : 'Обзор года';
  String get noProfile => _isEn ? 'Add a profile' : 'Добавьте профиль';
  String get mon => _isEn ? 'Mon' : 'Пн';
  String get tue => _isEn ? 'Tue' : 'Вт';
  String get wed => _isEn ? 'Wed' : 'Ср';
  String get thu => _isEn ? 'Thu' : 'Чт';
  String get fri => _isEn ? 'Fri' : 'Пт';
  String get sat => _isEn ? 'Sat' : 'Сб';
  String get sun => _isEn ? 'Sun' : 'Вс';
  String get cycleCalendar => _isEn ? 'Cycle Calendar' : 'Календарь цикла';
  String get cyclePhaseMenstrual => _isEn ? 'Period' : 'Менструация';
  String get cyclePhaseFertile => _isEn ? 'Fertile' : 'Фертильное окно';
  String get cyclePhaseOvulation => _isEn ? 'Ovulation' : 'Овуляция';
  String get cyclePhaseFollicular => _isEn ? 'Follicular phase' : 'Фолликулярная фаза';
  String get cyclePhaseLuteal => _isEn ? 'Luteal phase' : 'Лютеиновая фаза';
  String get cycleLengthLabel => _isEn ? 'Cycle Length' : 'Длина цикла';
  String get periodLengthLabel => _isEn ? 'Period Length' : 'Длина месячных';
  String get lastPeriodLabel => _isEn ? 'Last Period' : 'Последние месячные';
  String get notSet => _isEn ? 'Not set' : 'Не указано';
  String get currentPhaseLabel => _isEn ? 'Current Phase' : 'Текущая фаза';
  String get cycleDayLabel => _isEn ? 'Cycle Day' : 'День цикла';
  String get jan => _isEn ? 'Jan' : 'Январь';
  String get feb => _isEn ? 'Feb' : 'Февраль';
  String get mar => _isEn ? 'Mar' : 'Март';
  String get apr => _isEn ? 'Apr' : 'Апрель';
  String get may => _isEn ? 'May' : 'Май';
  String get jun => _isEn ? 'Jun' : 'Июнь';
  String get jul => _isEn ? 'Jul' : 'Июль';
  String get aug => _isEn ? 'Aug' : 'Август';
  String get sep => _isEn ? 'Sep' : 'Сентябрь';
  String get oct => _isEn ? 'Oct' : 'Октябрь';
  String get nov => _isEn ? 'Nov' : 'Ноябрь';
  String get dec => _isEn ? 'Dec' : 'Декабрь';
  String get infoDescTheory => _isEn ? 'Origin theory and scientific context' : 'Теория происхождения и научный контекст';
  String get infoDescPhysical => _isEn ? 'Strength, endurance, body energy' : 'Сила, выносливость, энергия тела';
  String get infoDescEmotional => _isEn ? 'Mood, intuition, sensitivity' : 'Настроение, интуиция, чувствительность';
  String get infoDescIntellectual => _isEn ? 'Memory, logic, learning ability' : 'Память, логика, способность к обучению';
  String get infoDescIntuitive => _isEn ? AppStringsEn.infoDescIntuitive : 'Интуиция, вдохновение, шестое чувство';
  String get infoDescCritical => _isEn ? 'Zero-crossing transition points' : 'Моменты перехода через ноль';
  String get infoDescCompatibility => _isEn ? 'Comparing phases of different people' : 'Сравнение фаз разных людей';
  String get shareSubject => _isEn ? 'My Biorhythms' : 'Мои биоритмы';
  String shareSubjectWithDate(String dateStr) => _isEn ? '$shareSubject for $dateStr' : '$shareSubject на $dateStr';
  String get yearOverviewTooltip => _isEn ? 'Year Overview' : 'Обзор года';
  String get fertilityLabel => _isEn ? 'Fertility' : 'Фертильность';
  String get fertileWindow => _isEn ? 'Fertile Window' : 'Фертильное окно';
  String get ovulationLabel => _isEn ? 'Ovulation' : 'Овуляция';
  String get todayLabel => _isEn ? 'Today!' : 'Сегодня!';
  String get inDays => _isEn ? 'In {n} days' : 'Через {n} дней';
  String get physicalTitle => _isEn ? 'Physical' : 'Физический';
  String get emotionalTitle => _isEn ? 'Emotional' : 'Эмоциональный';
  String get intellectualTitle => _isEn ? 'Intellectual' : 'Интеллектуальный';
  String get intuitiveTitle => _isEn ? 'Intuitive' : 'Интуитивный';
  String get notificationTitle => _isEn ? AppStringsEn.notificationTitle : 'Ваши биоритмы на сегодня';
  String get notificationChannelName => _isEn ? AppStringsEn.notificationChannelName : 'Ежедневный биоритм';
  String get notificationChannelDesc => _isEn ? AppStringsEn.notificationChannelDesc : 'Ежедневная сводка ваших биоритмов';
  String get notificationPhysical => _isEn ? AppStringsEn.notificationPhysical : 'Физический:';
  String get notificationEmotional => _isEn ? AppStringsEn.notificationEmotional : 'Эмоциональный:';
  String get notificationIntellectual => _isEn ? AppStringsEn.notificationIntellectual : 'Интеллектуальный:';
  String get notificationIntuitive => _isEn ? AppStringsEn.notificationIntuitive : 'Интуитивный:';
  String get notificationCritical => _isEn ? AppStringsEn.notificationCritical : 'Внимание: критические дни!';
  String get showSummaryNow => _isEn ? AppStringsEn.showSummaryNow : 'Показать сводку сейчас';
  String get showSummaryNowSub => _isEn ? AppStringsEn.showSummaryNowSub : 'Мгновенное уведомление с биоритмами';
  String get notificationSentSnack => _isEn ? AppStringsEn.notificationSentSnack : 'Уведомление отправлено — проверь шторку';
  String get visibleCyclesSection => _isEn ? AppStringsEn.visibleCyclesSection : 'Отображаемые циклы';
  String get notificationsEnabled => _isEn ? AppStringsEn.notificationsEnabled : 'Ежедневные уведомления';
  String get notificationsEnabledSub => _isEn ? AppStringsEn.notificationsEnabledSub : 'Ежедневная сводка биоритмов';
  String get notificationTimingNote => _isEn ? AppStringsEn.notificationTimingNote : 'Уведомление приходит примерно раз в 24 часа';
  String get languageLabel => _isEn ? AppStringsEn.languageLabel : 'Язык';
  String premiumExpiryUntil(String date) => _isEn
      ? AppStringsEn.premiumExpiryUntil.replaceFirst('{date}', date)
      : 'до $date';
  String get biometricAccessReason => _isEn ? AppStringsEn.biometricAccessReason : 'Подтвердите личность для доступа к приложению';
  String get accessDenied => _isEn ? AppStringsEn.accessDenied : 'Доступ заблокирован';
  String get unlock => _isEn ? 'Unlock' : 'Разблокировать';
  String get noPurchasesFound => _isEn ? AppStringsEn.noPurchasesFound : 'Покупок для восстановления не найдено';
  String get storeUnavailable => _isEn ? AppStringsEn.storeUnavailable : 'Магазин недоступен, попробуйте позже';
  String get premiumActive => _isEn ? AppStringsEn.premiumActive : 'Premium активен';
  String get premiumSection => _isEn ? AppStringsEn.premiumSection : 'PREMIUM';
  String get manage => _isEn ? AppStringsEn.manage : 'Управление';
  String shareInviteText(String code) => _isEn
      ? 'Track your biorhythms with me! '
          'Biorhythms is your daily tracker of energy, '
          'emotions, intellect, and intuition. '
          'Download and use my code: $code\n'
          'https://biorhythms.app/invite/$code'
      : 'Следи за своими биоритмами вместе со мной! '
          'Приложение «Биоритмы» — твой ежедневный трекер энергии, '
          'эмоций, интеллекта и интуиции. '
          'Скачай по ссылке и используй мой код: $code\n'
          'https://biorhythms.app/invite/$code';
}
