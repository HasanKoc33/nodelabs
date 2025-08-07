# Movie Discovery App

Flutter ile geliştirilmiş, Clean Architecture ve MVVM pattern kullanılarak tasarlanmış film keşif uygulaması.

## 🚀 Özellikler

### Temel Özellikler
- ✅ **Kimlik Doğrulama**: Kullanıcı girişi ve kayıt sistemi
- ✅ **Ana Sayfa**: Sonsuz kaydırma ile film listesi (sayfa başına 5 film)
- ✅ **Pull-to-Refresh**: Aşağı çekerek yenileme
- ✅ **Favori Filmler**: Anlık UI güncellemesi ile favori işlemleri
- ✅ **Profil Sayfası**: Kullanıcı bilgileri ve profil fotoğrafı yükleme
- ✅ **Bottom Navigation**: Sayfa geçişleri için alt navigasyon
- ✅ **Sınırlı Teklif Bottom Sheet**: Premium özellikler için teklif ekranı

### Bonus Özellikler
- ✅ **Navigation Service**: Merkezi navigasyon yönetimi
- ✅ **Localization Service**: Türkçe/İngilizce dil desteği
- ✅ **Logger Service**: Detaylı loglama sistemi
- ✅ **Secure Token Management**: Güvenli token saklama
- ✅ **Splash Screen**: Uygulama başlangıç ekranı
- ✅ **Shimmer Loading**: Yükleme animasyonları
- ✅ **Firebase Ready**: Crashlytics ve Analytics entegrasyonu hazır

## 🏗️ Mimari

### Clean Architecture
```
lib/
├── core/                    # Çekirdek katman
│   ├── constants/          # Sabitler
│   ├── error/              # Hata yönetimi
│   ├── network/            # Ağ katmanı
│   ├── services/           # Servisler
│   └── theme/              # Tema ayarları
├── data/                   # Veri katmanı
│   ├── datasources/        # Veri kaynakları
│   ├── models/             # Veri modelleri
│   └── repositories/       # Repository implementasyonları
├── domain/                 # Domain katmanı
│   ├── entities/           # İş nesneleri
│   ├── repositories/       # Repository arayüzleri
│   └── usecases/           # İş kuralları
└── presentation/           # Sunum katmanı
    ├── bloc/               # State management
    ├── screens/            # Ekranlar
    └── widgets/            # UI bileşenleri
```

### State Management
- **BLoC Pattern**: İş mantığı ayrımı
- **Equatable**: State karşılaştırmaları
- **Injectable**: Dependency injection

### Teknolojiler
- **Flutter**: UI framework
- **Dio**: HTTP client
- **GoRouter**: Navigasyon
- **SharedPreferences**: Yerel veri saklama
- **FlutterSecureStorage**: Güvenli veri saklama
- **CachedNetworkImage**: Resim önbellekleme
- **Shimmer**: Yükleme animasyonları
- **Lottie**: Animasyonlar
- **Firebase**: Analytics ve Crashlytics

## 🛠️ Kurulum

### Gereksinimler
- Flutter SDK (3.7.2+)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Adımlar

1. **Projeyi klonlayın**
```bash
git clone <repository-url>
cd nodelabs
```

2. **Bağımlılıkları yükleyin**
```bash
flutter pub get
```

3. **Kod üretimini çalıştırın**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **API anahtarını ayarlayın**
`lib/core/constants/app_constants.dart` dosyasında `apiKey` değerini güncelleyin:
```dart
static const String apiKey = 'YOUR_TMDB_API_KEY_HERE';
```

5. **Uygulamayı çalıştırın**
```bash
flutter run
```

## 📱 Ekranlar

### 1. Splash Screen
- Uygulama logosu ve yükleme animasyonu
- Otomatik yönlendirme (giriş/ana sayfa)

### 2. Giriş Ekranı
- E-posta ve şifre ile giriş
- Form validasyonu
- Kayıt ekranına yönlendirme

### 3. Kayıt Ekranı
- Ad, e-posta ve şifre ile kayıt
- Şifre onayı
- Form validasyonu

### 4. Ana Sayfa (Keşfet)
- Popüler filmler listesi
- Sonsuz kaydırma (infinite scroll)
- Pull-to-refresh
- Favori ekleme/çıkarma
- Film detayları (rating, tarih, açıklama)

### 5. Profil Sayfası
- Kullanıcı bilgileri
- Profil fotoğrafı yükleme
- Favori film sayısı
- Ayarlar ve yardım linkleri
- Çıkış yapma

### 6. Sınırlı Teklif Bottom Sheet
- Premium üyelik teklifi
- Özellik listesi
- Call-to-action butonları

## 📸 Ekran Görüntüleri

| | | |
|:-------------------------:|:-------------------------:|:-------------------------:|
| <img src="https://github.com/hasankocdogan/nodelabs/assets/11295297/4f0d7c21-8f04-4ee8-8c9e-0c1f7c4b9f8c" width="250"> Splash Screen | <img src="https://github.com/hasankocdogan/nodelabs/assets/11295297/7b3e5e8f-8a3e-4b3c-a8a2-1f4e9c1b9e9a" width="250"> Giriş Ekranı | <img src="https://github.com/hasankocdogan/nodelabs/assets/11295297/0a3e9c1c-5f1d-4b9e-8c9b-5c5c5c5c5c5c" width="250"> Kayıt Ekranı |
| <img src="https://github.com/hasankocdogan/nodelabs/assets/11295297/9d8b3e9a-1b3e-4c1e-8c9e-0c1f7c4b9f8c" width="250"> Ana Sayfa | <img src="https://github.com/hasankocdogan/nodelabs/assets/11295297/2c4e3d1a-1b3e-4c1e-8c9e-0c1f7c4b9f8c" width="250"> Profil Sayfası | <img src="https://github.com/hasankocdogan/nodelabs/assets/11295297/1b3e4c1e-8c9e-4c1e-8c9e-0c1f7c4b9f8c" width="250"> Sınırlı Teklif |

## 🔧 Yapılandırma

### API Yapılandırması
`lib/core/constants/app_constants.dart` dosyasında:
- TMDB API anahtarını ekleyin
- Base URL'leri kontrol edin

### Firebase Yapılandırması (Opsiyonel)
1. Firebase Console'da proje oluşturun
2. `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) dosyalarını ekleyin
3. Firebase SDK'ları otomatik olarak başlatılacak

### Tema Özelleştirmesi
`lib/core/theme/app_theme.dart` dosyasında renkleri ve stilleri özelleştirin.

## 🧪 Test

```bash
# Unit testleri çalıştır
flutter test

# Widget testleri çalıştır
flutter test test/widget_test.dart

# Integration testleri çalıştır
flutter drive --target=test_driver/app.dart
```

## 📦 Build

### Android
```bash
flutter build apk --release
# veya
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```