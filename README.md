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
git clone [<repository-url>](https://github.com/HasanKoc33/nodelabs.git)
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

4. **Uygulamayı çalıştırın**
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
## 📱 Ekran Görüntüleri

| Ana Sayfa | Sınırlı Teklif | Giriş |
|:---------:|:--------------:|:-----:|
| <img src="https://raw.githubusercontent.com/HasanKoc33/nodelabs/refs/heads/main/assets/screenshots/home_screen_screenshot..jpeg" width="250"/> | <img src="https://raw.githubusercontent.com/HasanKoc33/nodelabs/refs/heads/main/assets/screenshots/limittedOffer_screen_screenshot..jpeg" width="250"/> | <img src="https://raw.githubusercontent.com/HasanKoc33/nodelabs/refs/heads/main/assets/screenshots/login_screen_screenshot.jpeg" width="250"/> |

| Profil | Kayıt |
|:------:|:-----:|
| <img src="https://raw.githubusercontent.com/HasanKoc33/nodelabs/refs/heads/main/assets/screenshots/profile_screen_screenshot..jpeg" width="250"/> | <img src="https://raw.githubusercontent.com/HasanKoc33/nodelabs/refs/heads/main/assets/screenshots/register_screen_screenshot..jpeg" width="250"/> |

## 🔧 Yapılandırma

### API Yapılandırması
`lib/core/constants/app_constants.dart` dosyasında:
- Base URL'leri kontrol edin



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
