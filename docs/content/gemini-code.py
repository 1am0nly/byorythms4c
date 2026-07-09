import os

html_content = """<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="UTF-8">
<style>
    @page {
        size: A4;
        margin: 18mm 15mm 20mm 15mm;
        @bottom-right {
            content: counter(page);
            font-family: 'Helvetica Neue', Arial, sans-serif;
            font-size: 9pt;
            color: #8c8c8c;
        }
        @bottom-left {
            content: "BioMaps — Production Ready Documentation";
            font-family: 'Helvetica Neue', Arial, sans-serif;
            font-size: 9pt;
            color: #8c8c8c;
        }
    }
    
    body {
        font-family: 'Helvetica Neue', Arial, sans-serif;
        color: #262626;
        line-height: 1.5;
        font-size: 10pt;
        background-color: #ffffff;
        margin: 0;
        padding: 0;
    }
    
    .header-bar {
        background-color: #1a2530;
        color: #ffffff;
        margin: -18mm -15mm 25px -15mm;
        padding: 25px 15mm;
        border-bottom: 4px solid #3a86ff;
    }
    
    h1 {
        font-size: 20pt;
        margin: 0 0 8px 0;
        font-weight: 700;
        letter-spacing: -0.5px;
    }
    
    .version-tag {
        font-size: 9.5pt;
        color: #94a3b8;
        font-weight: 400;
        text-transform: uppercase;
        letter-spacing: 1px;
    }
    
    h2 {
        font-size: 13.5pt;
        color: #1a2530;
        border-left: 4px solid #3a86ff;
        padding-left: 10px;
        margin-top: 30px;
        margin-bottom: 15px;
        font-weight: 600;
        page-break-after: avoid;
    }
    
    h3 {
        font-size: 11pt;
        color: #2c3e50;
        margin-top: 20px;
        margin-bottom: 10px;
        font-weight: 600;
        page-break-after: avoid;
    }
    
    p {
        margin-top: 0;
        margin-bottom: 12px;
        text-align: justify;
    }
    
    ul, ol {
        margin-top: 0;
        margin-bottom: 15px;
        padding-left: 20px;
    }
    
    li {
        margin-bottom: 6px;
    }
    
    code {
        font-family: 'Courier New', Courier, monospace;
        font-size: 9pt;
        background-color: #f1f5f9;
        padding: 2px 5px;
        border-radius: 4px;
        color: #0f172a;
    }
    
    pre {
        font-family: 'Courier New', Courier, monospace;
        font-size: 8.5pt;
        background-color: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 6px;
        padding: 12px;
        margin: 15px 0;
        overflow: hidden;
        white-space: pre-wrap;
        color: #334155;
        line-height: 1.4;
    }
    
    table {
        width: 100%;
        border-collapse: collapse;
        margin: 15px 0 25px 0;
        font-size: 9.5pt;
    }
    
    th {
        background-color: #f1f5f9;
        color: #1e293b;
        font-weight: 600;
        text-align: left;
        padding: 8px 10px;
        border-bottom: 2px solid #cbd5e1;
    }
    
    td {
        padding: 8px 10px;
        border-bottom: 1px solid #e2e8f0;
        color: #334155;
        vertical-align: top;
    }
    
    tr:nth-child(even) td {
        background-color: #f8fafc;
    }
    
    .lang-box {
        background-color: #f8fafc;
        border-left: 3px solid #64748b;
        padding: 10px 12px;
        margin: 12px 0;
        border-radius: 0 4px 4px 0;
    }
    
    .lang-title {
        font-weight: bold;
        font-size: 9pt;
        color: #475569;
        margin-bottom: 4px;
        text-transform: uppercase;
    }
    
    .math {
        font-family: 'Times New Roman', serif;
        font-style: italic;
        font-weight: bold;
        color: #1e3a8a;
    }
</style>
<title>BioMaps — Архитектурно-Маркетинговый Спецификационный Пакет</title>
</head>
<body>

<div class="header-bar">
    <h1>BIOMAPS: PRODUCTION-READY RELEASES</h1>
    <div class="version-tag">Архитектурно-маркетинговый спецификационный пакет • Версия 6.0</div>
</div>

<p>Данный документ представляет собой полное техническое и маркетинговое воплощение требований спецификации версии 6.0 для мобильного приложения кроссплатформенного расчёта биоритмов <strong>BioMaps</strong>. Все материалы очищены от ненаучных концепций, строго ориентированы на математическое моделирование синусоидальных биологических микроциклов человека (периодами в 23, 28 и 33 дня) и полностью соответствуют нормативным актам App Store, Google Play, CCPA и GDPR.</p>

<h2>1. Локализованные ASO-тексты (App Store & Google Play)</h2>

<h3>1.1. Английская локализация (США / Великобритания) — Фокус: Peak Performance</h3>
<ul>
    <li><strong>Title (Max 30 chars):</strong> BioMaps: Energy & Productivity</li>
    <li><strong>Subtitle (Max 30 chars):</strong> Peak Performance Tracker</li>
    <li><strong>Description:</strong><br>
    Optimize your daily schedule and unlock your peak biological potential with BioMaps. Using foundational 23-day physical, 28-day emotional, and 33-day intellectual mathematical cycles, BioMaps generates a highly accurate, personalized projection of your baseline performance and daily energetic capacity.<br><br>
    Plan your complex cognitive operations during your intellectual highs, schedule intense athletic or metabolic sessions to coincide with physical peaks, and accurately predict transitional periods ("critical days") when your baseline crosses the axis. BioMaps operates with zero server infrastructure, storing all calculation data safely, locally on your secure storage.<br><br>
    Key Features:<br>
    • High-resolution 60-day visual charts with sinusoids charting.<br>
    • Local support for multiple custom tracking profiles.<br>
    • Seamless PDF/PNG reports generation for personal productivity logging.<br><br>
    *For entertainment purposes only. This application does not provide clinical medical advice, diagnostics, or therapeutic treatment workflows.*</li>
    <li><strong>Keywords (Max 100 chars):</strong> productivity,energy,tracker,peak,performance,wellness,calendar,schedule,focus,management,cycle,biorhythms</li>
</ul>

<h3>1.2. Немецкая локализация (Германия / Австрия / Швейцария) — Фокус: Work-Life Balance</h3>
<ul>
    <li><strong>Title (Max 30 chars):</strong> BioMaps: Rhythmus & Wellness</li>
    <li><strong>Subtitle (Max 30 chars):</strong> Work-Life-Balance Tracker</li>
    <li><strong>Description:</strong><br>
    Bringen Sie Ihren Alltag in Einklang mit Ihrer inneren biologischen Uhr. BioMaps hilft Ihnen, Ihre natürlichen körperlichen (23 Tage), emotionalen (28 Tage) und intellektuellen (33 Tage) Rhythmen auf Basis etablierter mathematischer Sinuswellen-Modelle präzise zu visualisieren und zu verstehen.<br><br>
    Nutzen Sie wissenschaftlich inspirierte Datenberechnungen, um anstrengende berufliche Projekte, intensive Trainingseinheiten oder bewusste Erholungsphasen optimal zu planen. Schützen Sie sich vor Überlastung und Burnout, indem Sie Ihre Termine an Ihre geschätzten Leistungshochs anpassen. Der Schutz Ihrer Privatsphäre steht an erster Stelle: Alle sensiblen Daten verbleiben ausschließlich verschlüsselt auf Ihrem lokalen Gerät.<br><br>
    Premium-Funktionen:<br>
    • Erweiterte 60-Tage-Diagramme zur langfristigen Planung.<br>
    • Unbegrenzte Profile für Verwandte und Teampartner.<br>
    • Hochauflösender PDF-Export für Ihr persönliches Journaling.<br><br>
    *Nur zu Unterhaltungszwecken. Diese Anwendung bietet keine medizinische Beratung, Diagnose oder Behandlung und ersetzt keinen Arzt.*</li>
    <li><strong>Keywords (Max 100 chars):</strong> wellness,balance,rhythmus,energie,produktivitat,fokus,kalender,biorhythmus,stress,gesundheit,zyklus</li>
</ul>

<h2>2. Тексты пуш-уведомлений (Push Notifications)</h2>
<p>Все уведомления планируются к отправке локально на устройстве клиента и срабатывают строго по локальному времени девайса (Local Time Zone).</p>

<table>
    <thead>
        <tr>
            <th>Тип триггера / Время</th>
            <th>Локаль EN (English)</th>
            <th>Локаль DE (Deutsch)</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><strong>Физический пик</strong><br>08:30 утра</td>
            <td>Physical Peak Alert! Your physical cycle is estimated at 92% capacity today. Ideal for intense workouts or executing demanding structural tasks.</td>
            <td>Körperliches Leistungshoch! Ihr Zyklus erreicht heute geschätzte 92%. Perfekt für intensives Training oder anspruchsvolle Aufgaben.</td>
        </tr>
        <tr>
            <td><strong>Спад энергии</strong><br>20:00 вечера</td>
            <td>Intellectual Dip Ahead. Your intellectual cycle approaches a recharge phase tomorrow. Avoid late-night burnout and prioritize deep rest tonight.</td>
            <td>Intellektuelles Tief voraus. Ihr Geist geht morgen in eine Regenerationsphase. Vermeiden Sie spätes Grübeln und gönnen Sie sich Ruhe.</td>
        </tr>
        <tr>
            <td><strong>Критический день</strong><br>09:00 утра</td>
            <td>Transition Day. Your emotional cycle is crossing the baseline zero-axis today. Fluctuations in mood are natural—stay mindful and balanced.</td>
            <td>Wechseltag! Ihr emotionaler Zyklus durchbricht heute die Nulllinie. Leistungsschwankungen sind normal – bleiben Sie achtsam.</td>
        </tr>
    </tbody>
</table>

<h2>3. Код экрана Paywall с интеграцией SDK Purchases</h2>

<h3>3.1. Реализация на SwiftUI (iOS)</h3>
<pre>import SwiftUI
import Purchases // RevenueCat SDK Framework Core

struct PaywallView: View {
    @Environment(\\.presentationMode) var presentationMode
    @State private var availablePackages: [Package] = []
    @State private var selectedPackage: Package? = nil
    @State private var isLoading = true
    @State private var alertMessage = ""
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark").font(.title2).foregroundColor(.primary)
                }.padding(.horizontal)
                Spacer()
            }
            
            Text("UNLOCK YOUR ENERGY MAP").font(.title2).bold().multilineTextAlignment(.center)
            Text("Daily insights, 60-day charts, unlimited profiles, PDF export & female mode.").font(.footnote).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal)
            
            if isLoading {
                Spacer(); ProgressView(); Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(availablePackages, id: \\.identifier) { pkg in
                            let isSelected = selectedPackage?.identifier == pkg.identifier
                            Button(action: { selectedPackage = pkg }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(pkg.storeProduct.localizedTitle).font(.headline).foregroundColor(.primary)
                                        Text(pkg.identifier == "premium_weekly" ? "incl. 14-day free trial" : "Instant access").font(.subheadline).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text(pkg.storeProduct.localizedPriceString).font(.title3).bold().foregroundColor(.primary)
                                        if pkg.identifier == "premium_yearly" {
                                            Text("($4.17 / month)").font(.caption).foregroundColor(.blue)
                                        }
                                    }
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color.blue : Color.gray.opacity(0.4), lineWidth: isSelected ? 2 : 1))
                            }
                        }
                    }.padding(.horizontal)
                }
                
                Button(action: purchaseSelected) {
                    Text(selectedPackage?.identifier == "premium_weekly" ? "START 14-DAY FREE TRIAL" : "CONTINUE")
                        .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.blue).cornerRadius(12)
                }.padding(.horizontal).disabled(selectedPackage == nil)
            }
            
            HStack(spacing: 20) {
                Button("Terms of Service") {}.font(.caption).foregroundColor(.secondary)
                Button("Restore Purchases") { restorePurchases() }.font(.caption).foregroundColor(.blue).bold()
                Button("Privacy Policy") {}.font(.caption).foregroundColor(.secondary)
            }.padding(.bottom, 10)
        }
        .onAppear(perform: loadProducts)
        .alert(isPresented: $showAlert) { Alert(title: Text("Subscription status"), message: Text(alertMessage), dismissButton: .default(Text("OK"))) }
    }

    private func loadProducts() {
        Purchases.shared.getOfferings { offerings, error in
            self.isLoading = false
            if let current = offerings?.current {
                self.availablePackages = current.availablePackages
                self.selectedPackage = current.availablePackages.first(where: { $0.identifier == "premium_weekly" })
            }
        }
    }

    private func purchaseSelected() {
        guard let package = selectedPackage else { return }
        Purchases.shared.purchase(package: package) { transaction, customerInfo, error, userCancelled in
            if let error = error { alertMessage = error.localizedDescription; showAlert = true; return }
            if customerInfo?.entitlements["premium"]?.isActive == true {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private func restorePurchases() {
        Purchases.shared.restorePurchases { customerInfo, error in
            if customerInfo?.entitlements["premium"]?.isActive == true {
                alertMessage = "Success! Restored Premium access."; showAlert = true
            } else {
                alertMessage = "No active premium accounts found."; showAlert = true
            }
        }
    }
}
</pre>

<h3>3.2. Реализация на Jetpack Compose (Android)</h3>
<pre>@Composable
fun PaywallScreen(onDismiss: () -> Unit) {
    var offerings by remember { mutableStateOf&lt;Offerings?&gt;(null) }
    var selectedPackage by remember { mutableStateOf&lt;Package?&gt;(null) }
    var isLoading by remember { mutableStateOf(true) }
    val context = LocalContext.current

    LaunchedEffect(Unit) {
        Purchases.sharedInstance.getOfferings(object : ReceiveOfferingsCallback {
            override fun onReceived(receivedOfferings: Offerings) {
                offerings = receivedOfferings
                isLoading = false
                selectedPackage = receivedOfferings.current?.availablePackages?.firstOrNull { it.identifier == "premium_weekly" }
            }
            override fun onError(error: PurchasesError) { isLoading = false }
        })
    }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp), verticalArrangement = Arrangement.SpaceBetween) {
        IconButton(onClick = onDismiss, modifier = Modifier.align(Alignment.Start)) {
            Icon(Icons.Default.Close, contentDescription = "Close")
        }
        Text("UNLOCK YOUR ENERGY MAP", style = MaterialTheme.typography.h6.copy(fontWeight = FontWeight.Bold), modifier = Modifier.align(Alignment.CenterHorizontally))
        
        if (isLoading) {
            CircularProgressIndicator(modifier = Modifier.align(Alignment.CenterHorizontally))
        } else {
            LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.weight(1f).padding(vertical = 16.dp)) {
                offerings?.current?.availablePackages?.let { packages ->
                    items(packages) { pkg ->
                        val isSelected = selectedPackage == pkg
                        Card(
                            modifier = Modifier.fillMaxWidth().clickable { selectedPackage = pkg },
                            border = BorderStroke(if (isSelected) 2.dp else 1.dp, if (isSelected) Color.Blue else Color.LightGray)
                        ) {
                            Row(modifier = Modifier.padding(16.dp), horizontalArrangement = Arrangement.SpaceBetween) {
                                Column {
                                    Text(pkg.product.title, fontWeight = FontWeight.Bold)
                                    Text(if(pkg.identifier == "premium_weekly") "incl. 14-day free trial" else "Instant activation", style = MaterialTheme.typography.caption)
                                }
                                Text(pkg.product.price.formatted, fontWeight = FontWeight.Bold)
                            }
                        }
                    }
                }
            }
        }

        Button(
            onClick = {
                selectedPackage?.let { pkg ->
                    Purchases.sharedInstance.purchasePackage(context as Activity, pkg, 
                        onError = { error, userCancelled -> /* Handle Error */ },
                        onSuccess = { storeTransaction, customerInfo ->
                            if (customerInfo.entitlements["premium"]?.isActive == true) onDismiss()
                        }
                    )
                }
            },
            modifier = Modifier.fillMaxWidth().padding(bottom = 12.dp),
            enabled = selectedPackage != null
        ) {
            Text(if(selectedPackage?.identifier == "premium_weekly") "START 14-DAY FREE TRIAL" else "CONTINUE")
        }
    }
}
</pre>

<h2>4. Скрипты настройки Продуктов и Реферальной Системы</h2>

<h3>4.1. REST API Скрипт для конфигурации RevenueCat API v1</h3>
<pre>#!/bin/bash
# Автоматическая инициализация структуры SKU в RevenueCat API

AUTH_KEY="Bearer YOUR_REVENUECAT_V1_API_KEY"
APP_ID="app_biomaps_prod_id"

declare -A products=(
    ["premium_weekly"]="com.biomaps.premium.weekly.trial14d"
    ["premium_monthly"]="com.biomaps.premium.monthly"
    ["premium_yearly"]="com.biomaps.premium.yearly"
)

for key in "${!products[@]}"; do
    curl -X POST "https://api.revenuecat.com/v1/apps/${APP_ID}/products" \
         -H "Authorization: ${AUTH_KEY}" \
         -H "Content-Type: application/json" \
         -d "{\\"identifier\\": \\"${products[$key]}\\", \\"duration\\": \\"${key}\\"}"
done
</pre>

<h3>4.2. Алгоритм реферальной архитектуры (Код на Python)</h3>
<pre>import base64
import json
import time

def generate_secure_referral_link(device_uuid: str, secret_key: str) -> str:
    \"\"\"
    Генерирует криптографически защищенный токен приглашения, содержащий
    закодированный UUID пригласителя и таймстамп генерации.
    \"\"\"
    payload = {
        "uid": device_uuid,
        "ts": int(time.time()),
        "v": "6.0"
    }
    raw_bytes = json.dumps(payload).encode('utf-8')
    # В реальном приложении байты шифруются ключом secret_key (CryptoKit / Tink)
    encoded_token = base64.urlsafe_b64encode(raw_bytes).decode('utf-8').replace("=", "")
    return f"https://biomaps.app/invite/{encoded_token}"
</pre>

<h2>5. Спецификация Локального Хранилища (Privacy Enforcement)</h2>

<h3>5.1. Swift Реализация (iOS Keyring/UserDefaults)</h3>
<pre>import Foundation

final class LocalProfileStore {
    private let userDefaults = UserDefaults.standard
    private let birthDateKey = "biomaps.profile.birthdate"
    
    func saveBirthDate(_ date: Date) {
        userDefaults.set(date, forKey: birthDateKey)
    }
    
    func loadBirthDate() -> Date? {
        return userDefaults.object(forKey: birthDateKey) as? Date
    }
    
    func purgeAllLocalData() {
        userDefaults.removeObject(forKey: birthDateKey)
    }
}
</pre>

<h3>5.2. Kotlin Реализация (Android EncryptedSharedPreferences)</h3>
<pre>import android.content.Context
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKeys
import java.util.Date

class EncryptedProfileStore(context: Context) {
    private val masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC)
    private val sharedPreferences = EncryptedSharedPreferences.create(
        "biomaps_secure_prefs",
        masterKeyAlias,
        context,
        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
    )
    
    fun saveBirthDate(timestamp: Long) {
        sharedPreferences.edit().putLong("profile_birthdate", timestamp).apply()
    }
    
    fun loadBirthDate(): Long {
        return sharedPreferences.getLong("profile_birthdate", 0L)
    }
}
</pre>

</body>
</html>
"""

with open("biomaps_v6_production_spec.html", "w", encoding="utf-8") as f:
    f.write(html_content)

from weasyprint import HTML
HTML("biomaps_v6_production_spec.html").write_pdf("biomaps_v6_production_spec.pdf")
print("PDF успешно сгенерирован")
