Отличный, четко структурированный документ. Стратегия монетизации выглядит зрелой, а акцент на локальное хранение данных и строгий комплаенс избавит от головной боли с GDPR и регуляторами.

Давай пошагово закроем все 6 пунктов, которые ты зафиксировал в разделе 14.

---

## 1. Тексты онбординга (Onboarding Copy)

В США упор делаем на **личную эффективность, достижение целей и продуктивность**. В Европе (ЕС) смещаем фокус на **осознанность, баланс жизни и предотвращение выгорания**.

### Вариант США (Фокус: Productivity & Peak Performance)

* **Экран 1 (Welcome):** "Unlock Your Peak Potential. Discover the hidden biological cycles that drive your energy, focus, and emotional strength every single day."
* **Экран 2 (Value Prop):** "Hack Your Schedule. Know exactly when to crush demanding tasks, schedule critical meetings, or hit the gym based on your physical and intellectual peaks."
* **Экран 3 (Social Proof/Urgency):** "Data-Driven Success. Join thousands of high-achievers using biorhythms to optimize their daily routine and eliminate burnout."

### Вариант ЕС (Фокус: Balance, Well-being & Mindfulness)

* **Экран 1 (Welcome):** "Live in Harmony with Your Body. Understand your natural physical, emotional, and intellectual rhythms to better navigate your daily life."
* **Экран 2 (Value Prop):** "Listen to Your Inner Clock. Recognize your high-energy days and learn when your body demands rest, helping you maintain perfect work-life balance."
* **Экран 3 (Privacy & Trust):** "Your Data Stays Yours. Completely private, secure, and stored locally on your device. Zero tracking, just pure insight into your well-being."

---

## 2. Юридические дисклеймеры (Disclaimers)

Строгие формулировки для предотвращения банов со стороны модераторов App Store/Google Play в категориях Health/Lifestyle.

* **English:**
> "For entertainment purposes only. This application does not provide medical advice, diagnosis, or treatment. The calculations provided are based on mathematical models and should not be used as a substitute for professional medical consultation."
* **Deutsch:**
> "Nur zu Unterhaltungszwecken. Diese Anwendung bietet keine medizinische Beratung, Diagnose oder Behandlung. Die bereitgestellten Berechnungen basieren auf mathematischen Modellen und sollten nicht als Ersatz für eine professionelle medizinische Beratung verwendet werden."
* **Français:**
> "À des fins de divertissement uniquement. Cette application ne fournit pas de conseils médicaux, de diagnostic ou de traitement. Les calculs fournis sont basés sur des modèles mathématiques et ne doivent pas remplacer une consultation médicale professionnelle."
* **Español:**
> "Solo para fines de entretenimiento. Esta aplicación no proporciona asesoramiento médico, diagnóstico ni tratamiento. Los cálculos proporcionados se basan en modelos matemáticos y no deben utilizarse como sustituto de una consulta médica profesional."

---

## 3. JSON-структура локализованных цен

```json
{
  "products": {
    "premium_monthly": {
      "id": "com.biorhythms.premium.monthly",
      "type": "subscription",
      "pricing": {
        "US": { "currency": "USD", "amount": 9.99, "display": "$9.99" },
        "DE": { "currency": "EUR", "amount": 9.99, "display": "9,99 €" },
        "FR": { "currency": "EUR", "amount": 9.99, "display": "9,99 €" },
        "GB": { "currency": "GBP", "amount": 8.99, "display": "£8.99" }
      }
    },
    "premium_yearly": {
      "id": "com.biorhythms.premium.yearly",
      "type": "subscription",
      "pricing": {
        "US": {
          "currency": "USD",
          "amount": 49.99,
          "display": "$49.99",
          "breakdown_monthly": "$4.17/mo"
        },
        "DE": {
          "currency": "EUR",
          "amount": 44.99,
          "display": "44,99 €",
          "breakdown_monthly": "3,75 €/Monat"
        },
        "FR": {
          "currency": "EUR",
          "amount": 44.99,
          "display": "44,99 €",
          "breakdown_monthly": "3,75 €/mois"
        },
        "GB": {
          "currency": "GBP",
          "amount": 39.99,
          "display": "39.99 £",
          "breakdown_monthly": "£3.33/mo"
        }
      }
    },
    "family_yearly": {
      "id": "com.biorhythms.family.yearly",
      "type": "subscription",
      "pricing": {
        "US": { "currency": "USD", "amount": 69.99, "display": "$69.99" },
        "DE": { "currency": "EUR", "amount": 64.99, "display": "64,99 €" },
        "FR": { "currency": "EUR", "amount": 64.99, "display": "64,99 €" },
        "GB": { "currency": "GBP", "amount": 55.99, "display": "£55.99" }
      }
    }
  }
}
```

---

## 4. Макет Paywall-экрана (ASCII Wireframe)

```
+-----------------------------------------------------------+
|  [ X ]                                                    |
|                        UNLOCK PREMIUM                     |
|             Track unlimited profiles & sync cycles        |
|                                                           |
|  +---------------+    +-------------------+    +-------+  |
|  |    MONTHLY    |    |   YEARLY (SAVE)   |    | FAMILY|  |
|  |               |    |    ⭐ BEST VALUE   |    |       |  |
|  |     $9.99     |    |      $49.99       |    | $69.99|  |
|  |    / month    |    |   ($4.17/month)   |    | / year|  |
|  |               |    |                   |    |       |  |
|  |  [ Select ]   |    |    [ Selected ]   |    | [Sel] |  |
|  +---------------+    +-------------------+    +-------+  |
|                                                           |
|  • Unlimited Profiles     • Female & Fertility Mode       |
|  • 60-day Chart View      • High-Res PDF/PNG Export       |
|                                                           |
|             [   START MY 7-DAY FREE TRIAL   ]             |
|             (Then $49.99/year. Cancel anytime.)           |
|                                                           |
|  Terms of Service   |   Restore Purchases   |   Privacy   |
+-----------------------------------------------------------+
```

---

## 5. Тексты Push-уведомлений

* **Утренний триггер (08:30) — Физический пик:**
*EN:* "Physical Peak Alert! Your body is operating at 92% efficiency today. Perfect time for an intense workout or finishing heavy tasks."
*DE:* "Körperliches Hoch! Dein Körper läuft heute auf 92%. Die perfekte Zeit für Sport oder anstrengende Aufgaben."

* **Вечерний триггер (20:00) — Интеллектуальный/Эмоциональный спад:**
*EN:* "Intellectual Cycle Dipping. Your brain capacity enters a recharge phase tomorrow. Avoid late-night overthinking and get some quality rest."
*DE:* "Intellektuelles Tief voraus. Dein Geist geht morgen in die Erholungsphase. Vermeide spätes Grübeln und gönn dir Ruhe."

* **Критический день (09:00) — Переход фазы через ноль:**
*EN:* "Transition Day. Your emotional cycle is shifting today. You might feel slightly unstable—take a deep breath and stay mindful."
*DE:* "Wechseltag. Dein emotionaler Zyklus stellt sich heute um. Du könntest dich etwas unausgeglichen fühlen — nimm dir einen Moment Zeit für dich."

---

## 6. Код экрана «Совместимость» (SwiftUI / Kotlin Jetpack Compose)

### SwiftUI (iOS)

```swift
import SwiftUI

struct CompatibilityView: View {
    @State private var myBirthDate = Date()
    @State private var partnerBirthDate = Date()
    @State private var compatibilityResult: Double? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Compatibility Check")
                    .font(.title).bold()
                
                VStack(alignment: .leading) {
                    DatePicker("Your Birthday", selection: $myBirthDate, displayedComponents: .date)
                    DatePicker("Partner's Birthday", selection: $partnerBirthDate, displayedComponents: .date)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                Button(action: calculateCompatibility) {
                    Text("Compare Rhythms")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if let result = compatibilityResult {
                    VStack(spacing: 12) {
                        Text("Total Sync")
                            .font(.headline)
                        Text(String(format: "%.0f%%", result * 100))
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
    
    private func calculateCompatibility() {
        let diff = abs(myBirthDate.timeIntervalSince(partnerBirthDate))
        let days = diff / (24 * 3600)
        let physicalSync = cos((2 * .pi * days) / 23)
        let emotionalSync = cos((2 * .pi * days) / 28)
        let intellectualSync = cos((2 * .pi * days) / 33)
        
        withAnimation {
            compatibilityResult = (physicalSync + emotionalSync + intellectualSync) / 3.0
            if compatibilityResult! < 0 { compatibilityResult = abs(compatibilityResult!) }
        }
    }
}
```

### Jetpack Compose (Android)

```kotlin
@Composable
fun CompatibilityScreen() {
    var myDays by remember { mutableStateOf(0) }
    var partnerDays by remember { mutableStateOf(0) }
    var score by remember { mutableStateOf<Double?>(null) }

    Column(modifier = Modifier.padding(16.dp).fillMaxWidth(), halignment = Alignment.CenterHorizontally) {
        Text("Compatibility Analyzer", style = MaterialTheme.typography.h5)
        
        OutlinedTextField(value = myDays.toString(), onValueChange = { myDays = it.toIntOrNull() ?: 0 }, label = { Text("Your Days Alive") })
        OutlinedTextField(value = partnerDays.toString(), onValueChange = { partnerDays = it.toIntOrNull() ?: 0 }, label = { Text("Partner's Days Alive") })
        
        Button(
            onClick = {
                val diff = kotlin.math.abs(myDays - partnerDays).toDouble()
                val phys = kotlin.math.cos((2 * kotlin.math.PI * diff) / 23)
                val emot = kotlin.math.cos((2 * kotlin.math.PI * diff) / 28)
                val intel = kotlin.math.cos((2 * kotlin.math.PI * diff) / 33)
                score = ((phys + emot + intel) / 3.0).absoluteValue * 100
            },
            modifier = Modifier.fillMaxWidth().padding(top = 16.dp)
        ) {
            Text("Calculate")
        }

        score?.let {
            Text("Harmony Score: ${it.toInt()}%", style = MaterialTheme.typography.h4, color = Color.Green, modifier = Modifier.padding(top = 24.dp))
        }
    }
}
```

---

Вот готовый текстовый и концептуальный пакет для немедленного запуска обновленной воронки приложения «Биоритмы». Текст полностью очищен от медицинской терминологии и астрологии, строго сфокусирован на математических моделях и адаптирован под требования App Store / Google Play.

---

## 1. ASO Texts

### US App Store & Google Play (Focus: Productivity & Peak Performance)

* **Title (Max 30 chars):** BioMaps: Energy & Productivity
* **Subtitle (Max 30 chars):** Peak Performance Tracker
* **Description (Excerpt):**
> "Optimize your daily schedule with BioMaps. Using exact 23, 28, and 33-day mathematical cycles, BioMaps provides a personalized estimate of your physical, emotional, and intellectual energy levels. Plan high-impact tasks, avoid burnout, and align your workflow with your body's natural rhythms. *For entertainment purposes only.*"
* **iOS Keywords (100 chars max, comma-separated):**
productivity,energy,tracker,peak,performance,wellness,calendar,schedule,focus,management,cycle

### EU App Store & Google Play (Focus: Wellness & Work-Life Balance)

* **Title (Max 30 chars):** BioMaps: Rhythm & Wellness
* **Subtitle (Max 30 chars):** Work-Life Balance Tracker
* **Description (Excerpt):**
> "Discover your natural life cycles with BioMaps. Track your physical, emotional, and intellectual rhythms using safe, locally stored data. Improve your well-being, understand your high-energy days, and learn when your body estimates a need for rest to achieve a perfect work-life balance. *For entertainment purposes only.*"
* **iOS Keywords (100 chars max, comma-separated):**
wellness,balance,rhythm,biorhythm,mindfulness,energy,habits,lifestyle,tracker,biological,clock

---

## 2. Email Templates (Retention Campaign)

### Email 1: Welcome & Guide (Sent immediately upon collecting email)

* **Subject:** Welcome to BioMaps! 🚀 Your 14-Day Premium Trial has started
* **Body:**
> Hello,
> Thank you for choosing BioMaps to help track your natural energy cycles. Your 14-day full Premium trial is now active!
> **Quick Start Guide:**
> 1. **Check Your Daily Map:** Open the app every morning to see your estimated physical, emotional, and intellectual levels.
> 2. **Add Custom Notes:** Correlate your real-world productivity with your mathematical sinusoids.
> 3. **Your Data is Safe:** All your data is stored securely right on your device.
>
> [ Explore My Chart Now ] *(App Deep Link)*
> *Disclaimer: BioMaps provides calculations based on mathematical models for entertainment purposes only and does not substitute professional medical advice.*

### Email 2: Mid-Trial Insights (Sent on Day 7)

* **Subject:** 📊 You're halfway through! 3 insights from your energy cycles
* **Body:**
> Hello,
> You have been tracking your rhythms with BioMaps for 7 days. Here are 3 quick tips to make the most of your remaining trial:
> * **Spot the Critical Days:** When a cycle line crosses the zero baseline, your energy is transitioning. Take it easy on these days.
> * **Sync with Intellect:** Plan deep focus sessions and complex problem-solving during your intellectual peak phases.
> * **Compare and Align:** Use the Premium feature to add a partner or family member and check your harmony levels.
>
> Your full access continues for another 7 days. Enjoy optimizing your schedule!
> [ Open BioMaps ] *(App Deep Link)*

### Email 3: Trial Expiration Warning (Sent on Day 13 — Transparency Driver)

* **Subject:** Important: Your BioMaps trial ends tomorrow
* **Body:**
> Hello,
> We wanted to remind you that your 14-day free trial of BioMaps Premium ends in 24 hours.
> If you've enjoyed tracking your peaks and managing your time more efficiently, you don't need to do anything. Your subscription will automatically renew at the selected rate.
> We believe in complete transparency, so if you feel BioMaps isn't the right fit for you at this time, you can easily cancel your subscription via your App Store / Google Play account settings at least 24 hours before the trial ends.
> Want to keep mapping your energy?
> [ Keep Premium Active ] *(App Deep Link)*

---

## 3. UI Copy (Onboarding & Paywall)

### Onboarding Screen 1: Push Notifications

* **Headline:** Never Miss Your Peak Energy
* **Body:** Enable smart, local notifications. We will drop a brief morning update when your physical or intellectual cycles enter a peak phase, helping you plan your day optimally. *No midnight alerts, guaranteed.*
* **CTA Button:** [ Enable Notifications ]
* **Secondary Link:** *Skip for now*

### Onboarding Screen 2: Goal Selection

* **Headline:** Personalize Your Experience
* **Subtitle:** Select up to 2 goals so we can highlight the most relevant cycle trends on your dashboard:
* [ ] Maximize Daily Productivity
* [ ] Improve Work-Life Balance
* [ ] Manage Stress & Downtime
* [ ] Track Relationship Compatibility

* **CTA Button:** [ Continue ]

### Onboarding Screen 3: Premium Trial Activation

* **Headline:** Unlock Your Personalized Energy Map
* **Body:** Get full access to advanced 60-day charts, limitless profiles, and high-res PDF reports. Try it risk-free.
* **CTA Button:** [ Start 14-Day Free Trial ]
* **Subtext:** *Then $5.99/week. Cancel anytime in your device settings.*

---

## 4. Legal / User Agreement Clauses

### English (US/UK)

> "Subscription automatically renews at the selected price ($5.99/week, $9.99/month, or $49.99/year) unless canceled at least 24 hours before the end of the current period, including the 14-day free trial. Account will be charged for renewal within 24 hours prior to the end of the trial. Manage or cancel your subscription in your App Store / Google Play account settings. All calculations are generated via mathematical models and are intended for entertainment purposes only."

### Deutsch (DE)

> "Das Abonnement verlängert sich automatisch zum gewählten Preis (5,99 €/Woche, 9,99 €/Monat oder 44,99 €/Jahr), es sei denn, es wird mindestens 24 Stunden vor dem Ende des aktuellen Zeitraums, einschließlich des 14-tägigen kostenlosen Probezeitraums, gekündigt. Das Konto wird innerhalb von 24 Stunden vor dem Ende des Probezeitraums für die Verlängerung belastet. Sie können Ihr Abonnement in den Einstellungen Ihres App Store- / Google Play-Kontos verwalten oder kündigen. Alle Berechnungen basieren auf mathematischen Modellen und dienen ausschließlich Unterhaltungszwecken."

---

## 5. Referral Mechanics («Приведи друга»)

### UI Screen Text & Layout Description

* **Screen Title:** Share the Energy
* **Main Reward Text:** "Invite a friend. Get 7 Days of Premium Free."
* **Explainer Subtext:** "When your friend downloads BioMaps using your unique link and sets up their local profile, you both get 7 days of full Premium features added to your account. No limits—invite more friends for more free weeks!"
* **Dynamic Progress Counter:** "Friends invited: 3 (+21 Premium Days Earned)"
* **CTA Button:** [ Share Invitation Link ]

### Pre-filled Native Share Invitation Copy

> "Hey! I've been tracking my daily energy peaks and focus cycles using the BioMaps app. It calculates your physical and intellectual rhythms using clean mathematical models. Use my link to download it and get a 14-day free trial plus an extra premium bonus: [DYNAMIC_REFERRAL_URL]"
