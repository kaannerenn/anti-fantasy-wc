# PROJE: Anti-Fantasy World Cup

## Özet
2026 FIFA Dünya Kupası için bir "tersine fantasy" web uygulaması. Klasik fantasy oyunlarının aksine, kötü performans gösteren oyuncular puan kazandırır, iyi performans gösterenler puan kaybettirir. Kullanıcılar arkadaş ligi kurar, draft yapar, kadrolarını yönetir ve maçlardan sonra otomatik puanlanır.

## Hedef Kullanıcı
İlk aşama: Kullanıcının kendi arkadaş grubu (10-50 kişi). MVP doğası gereği büyük ölçeğe ihtiyaç yok.

## Teknoloji Yığını
- Frontend: Next.js (App Router)
- Backend: Supabase (PostgreSQL + Auth + Realtime)
- Hosting: Vercel
- Veri kaynağı: API-Football (ücretsiz tier) — maç sonu çekimi, Supabase'e cache
- Yedek veri: openfootball/worldcup.json (fikstür, takım listesi)
- Giriş: Email/şifre + Google OAuth
- Dil: TypeScript (JavaScript değil)
- Style: Tailwind CSS (varsayılan)

## Geliştirme Felsefesi
- MVP odaklı: çalışan ürün > mükemmel ürün
- Sabit kurallar (lig başına ayarlanabilir değil)
- Türkçe arayüz (kullanıcı arkadaş grubu Türk)
- Mobil tarayıcı uyumlu (responsive design şart)
- Açıklanabilir puanlama (her olay görülebilir olmalı)

## Lig & Kadro Yapısı
- Lig büyüklüğü: 6-12 kullanıcı (önerilen 8-10)
- Squad: kullanıcı başına 18 oyuncu
- Aktif kadro her maç günü: 11 oyuncu (formasyon kullanıcı tercihi)
- Yedek: 7 oyuncu (puan ne kazandırır ne kaybettirir)
- Takım limiti: bir milli takımdan max 3 oyuncu
- Free agent havuzu: tüm 48 takımın 26 kişilik kadrosu (~1.248 oyuncu), draft sonrası çekilmeyenler

## Draft
- Tip: Snake draft (1→10, 10→1, 1→10, …)
- Süre limiti: 60 saniye / seçim
- Otomatik queue: kullanıcı önceden sıralı liste oluşturabilir, süresi biterse sistem en üsttekini seçer
- Başlangıç: tüm lig üyeleri "hazırım" tuşuna basınca

## Transfer
- Maç günlerinde günlük 1 add/drop hakkı
- Sakatlık durumunda free swap (hak harcanmaz)
- Takım elenmesi durumunda ekstra 2 free swap
- Maç günü kilitlenme: ilk maçtan 1 saat önce

## Puanlama Felsefesi
"Hata Avcısı" yaklaşımı (Felsefe B): kötü olaylar pozitif puan, iyi olaylar negatif puan. Sahaya çıkmamak ayrı bir ceza.

## Puanlama Tablosu — Saha Oyuncusu

| Olay | Puan |
|---|---|
| Gol | -5 |
| Asist | -3 |
| Kaçırılan penaltı | +15 |
| Net fırsat kaçırma (big chance missed) | +7 |
| İsabetsiz şut | +2 |
| Ofsayt | +3 |
| Sarı kart | +5 |
| Kırmızı kart | +10 |
| Yapılan faul | +1 |
| Top kaybı (her biri) | +1 |
| İsabetsiz pas (her biri) | +1 |
| Kendi kalesine gol | +15 |
| Maça çıkmama (sebepsiz) | -10 |
| Sakatlık (resmi) | 0 (ceza yok, free swap hakkı) |

## Puanlama Tablosu — Kaleci

| Olay | Puan |
|---|---|
| Yenilen gol | +5 |
| Kurtarış (her biri) | -1 |
| Penaltı kurtarış | -10 |
| Clean sheet (gol yememe) | -5 |
| Sarı/Kırmızı kart | Saha oyuncusu kuralları aynı |

## Rating Eşik Bonusu (Tüm Oyuncular)

API-Football'un performance rating alanına göre ek puan:

| Rating | Ekstra puan |
|---|---|
| < 6.0 (felaket maç) | +5 |
| 6.0 - 8.5 (orta bölge) | 0 |
| > 8.5 (yıldız performans) | -5 |

Not: Rating eksik gelirse (null), bonus uygulanmaz.

## Veri Akışı
1. Maç biter (sahada)
2. ~30 dakika sonra cron job tetiklenir (Vercel Cron)
3. API-Football'dan o maçın tam verisi tek istekle çekilir (fixtures/players endpoint)
4. Veri Supabase'e cache'lenir (tekrar API çağrısı yok)
5. Puanlama motoru çalışır, her oyuncunun anti-fantasy puanı hesaplanır
6. Kullanıcı arayüzü güncellenir

## API Limit Stratejisi
- API-Football ücretsiz tier: günde 100 istek
- Dünya Kupası'nda günde max 4 maç = günde 4 istek
- Aynı veri tekrar çekilmez (Supabase cache)
- %4 limit kullanımı, bol marj var

## Kod Yazım Kuralları
- TypeScript strict mode
- Türkçe değişken adı KULLANMA (kod İngilizce, UI Türkçe)
- Server Components varsayılan, Client Components sadece interaktif kısımlarda
- Tüm Supabase çağrıları için typed clients
- API rotalarında zod ile input validation
- Yorum satırları İngilizce
- Commit mesajları İngilizce ve conventional commits formatında (feat:, fix:, chore:, vb.)
- Asenkron işlemler için async/await (then/catch değil)

## Klasör Yapısı Hedefi

```
/app           — Next.js App Router sayfaları
/components    — paylaşılan React bileşenleri
/lib           — yardımcı fonksiyonlar (Supabase client, API-Football client, scoring engine)
/types         — TypeScript tip tanımları
/scripts       — bir kerelik scriptler (örn: oyuncu listesi import)
```

## Yapılmaması Gerekenler
- Veritabanı şemasını CLAUDE.md'ye danışmadan değiştirme
- Puanlama değerlerini koda gömme (constants/scoring.ts içinde tut)
- API-Football'a gereksiz istek atma (her zaman cache'i kontrol et)
- Selenium veya web scraping önerme (API yeterli)
- Kullanıcıdan API anahtarı, şifre veya kredi kartı isteme
- Lig sahibinin puanlama kurallarını değiştirebilmesi (MVP'de sabit kurallar)

## Mevcut Durum
Proje henüz başlangıç aşamasında. CLAUDE.md ve klasör yapısı dışında hiçbir kod yok. Sıradaki adımlar:
1. Next.js projesini başlatmak (create-next-app)
2. Supabase projesini kurmak
3. Veri modeli ve şemayı oluşturmak
4. Authentication akışını kurmak
5. İlk ekranı (lig oluşturma) yapmak
