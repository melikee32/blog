-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 11 Ağu 2026, 19:57:08
-- Sunucu sürümü: 10.4.32-MariaDB
-- PHP Sürümü: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `blog`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(2, 'Eğitim'),
(1, 'Genel'),
(5, 'Sanat'),
(4, 'Seyahat'),
(3, 'Teknoloji');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `comment_text` text NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `comments`
--

INSERT INTO `comments` (`id`, `comment_text`, `post_id`, `user_id`, `created_at`) VALUES
(1, 'Çok güzel anlatılmış, Flask öğrenmeye yeni başladım.', 1, 2, '2026-08-11 09:27:16'),
(2, 'Bu yazı gerçekten işime yaradı. Teşekkürler!', 1, 3, '2026-08-11 09:27:16'),
(3, 'Yazılım öğrenmek isteyenler için faydalı bir yazı olmuş.', 2, 1, '2026-08-11 09:27:16'),
(4, 'Yapay zeka hakkında daha fazla yazı bekliyorum.', 3, 4, '2026-08-11 09:27:16'),
(6, 'Sanat gerçekten insan hayatında önemli bir yere sahip.', 5, 3, '2026-08-11 09:27:16'),
(7, 'aynen katılıyorum', 5, 1, '2026-08-11 09:29:08'),
(8, '5455JHN', 6, 4, '2026-08-11 09:43:34');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `favorites`
--

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `favorites`
--

INSERT INTO `favorites` (`id`, `user_id`, `post_id`, `created_at`) VALUES
(1, 2, 1, '2026-08-11 09:27:26'),
(3, 1, 2, '2026-08-11 09:27:26'),
(4, 4, 3, '2026-08-11 09:27:26'),
(7, 4, 1, '2026-08-11 09:27:26'),
(8, 1, 1, '2026-08-11 09:29:14'),
(9, 1, 2, '2026-08-11 09:29:16'),
(10, 1, 2, '2026-08-11 09:29:21'),
(11, 4, 6, '2026-08-11 09:43:22'),
(19, 4, 5, '2026-08-11 10:57:41'),
(20, 4, 9, '2026-08-11 10:57:45'),
(21, 4, 10, '2026-08-11 10:57:51'),
(23, 1, 19, '2026-08-11 12:15:37'),
(24, 1, 31, '2026-08-11 13:01:13'),
(30, 5, 7, '2026-08-11 13:43:51'),
(35, 5, 1, '2026-08-11 13:52:12'),
(36, 5, 2, '2026-08-11 13:54:13');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` enum('draft','published') DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `category` varchar(50) NOT NULL DEFAULT 'Genel'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `posts`
--

INSERT INTO `posts` (`id`, `title`, `content`, `user_id`, `status`, `created_at`, `updated_at`, `category`) VALUES
(1, 'Flask ile Blog Sitesi Nasıl Yapılır?', 'Flask kullanarak basit ve kullanışlı bir blog sitesi geliştirmek mümkündür.', 1, 'published', '2026-08-11 09:26:52', '2026-08-11 09:26:52', 'Teknoloji'),
(2, 'Yazılım Öğrenmeye Nasıl Başlanır?', 'Yazılım öğrenmeye yeni başlayanlar için temel adımları ve önemli önerileri ele alıyoruz.', 2, 'published', '2026-08-11 09:26:52', '2026-08-11 09:26:52', 'Eğitim'),
(3, 'Yapay Zeka Günlük Hayatımızı Nasıl Değiştiriyor?', 'Yapay zeka teknolojileri artık eğitimden sağlığa kadar birçok farklı alanda kullanılmaktadır.', 3, 'published', '2026-08-11 09:26:52', '2026-08-11 09:26:52', 'Teknoloji'),
(5, 'Sanatın İnsan Hayatındaki Önemi - deneme başlık', 'Sanat, insanların kendilerini ifade etmelerinin ve yaratıcılıklarını geliştirmelerinin önemli yollarından biridir. deneme yazısı ekleme', 1, 'published', '2026-08-11 09:26:52', '2026-08-11 09:28:53', 'Sanat'),
(6, 'deneme yazısı YUSUF', 'YHCFGYHDCBDMC', 4, 'draft', '2026-08-11 09:43:16', '2026-08-11 09:43:16', 'Eğitim'),
(7, 'Flask ile İlk Adımlar', 'Flask, Python ile web geliştirmeyi oldukça kolaylaştıran hafif bir framework. Bu yazıda temel route yapısını ele alıyorum.', 1, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Teknoloji'),
(8, 'MySQL Foreign Key Mantığı', 'İlişkisel veritabanlarında foreign key kullanımı veri bütünlüğünü korur. CASCADE ve RESTRICT farklarını inceledik.', 2, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Teknoloji'),
(9, 'Kapadokya Gezisi Notlarım', 'Balon turu için sabahın erken saatlerinde kalktık, manzara gerçekten nefes kesiciydi.', 3, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Seyahat'),
(10, 'Empresyonizm Akımına Kısa Bakış', 'Monet ve Renoir gibi sanatçıların ışığı tuvale nasıl taşıdığını konuşalım.', 4, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Sanat'),
(11, 'Üniversite Sınavlarına Hazırlık', 'Düzenli tekrar ve deneme sınavları en etkili çalışma yöntemlerinden.', 1, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Eğitim'),
(12, 'Python ile Web Scraping', 'BeautifulSoup ve requests kütüphaneleriyle basit bir veri toplama örneği yaptık.', 2, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Teknoloji'),
(13, 'Kapadokya\'dan Sonra Efes', 'Antik kentte yürürken tarihin içinde kayboluyorsunuz.', 3, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Seyahat'),
(14, 'Sokak Sanatı ve Şehir Kültürü', 'Grafiti, artık birçok şehirde sanatın demokratikleşmesinin bir örneği.', 4, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Sanat'),
(15, 'Etkili Not Tutma Teknikleri', 'Cornell yöntemi ile ders notlarını daha verimli tutabilirsiniz.', 1, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Eğitim'),
(16, 'REST API Tasarım İlkeleri', 'Kaynak odaklı düşünmek API tasarımını çok daha anlaşılır hale getiriyor.', 2, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Teknoloji'),
(17, 'Karadeniz Yaylalarında Bir Hafta', 'Sis, çay bahçeleri ve taze hava; tam bir doğa kaçamağı.', 3, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Seyahat'),
(18, 'Heykel Sanatında Malzeme Seçimi', 'Mermer, bronz ve ahşabın heykel üzerindeki etkisini karşılaştırdık.', 4, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Sanat'),
(19, 'Zaman Yönetimi ve Pomodoro', 'Pomodoro tekniği ile odaklanma sürelerimi nasıl artırdım.', 1, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Eğitim'),
(20, 'Docker\'a Giriş', 'Container mantığını öğrenmek, geliştirme ortamlarını standartlaştırmanın ilk adımı.', 2, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Teknoloji'),
(21, 'Bodrum\'da Gün Batımı', 'Gümbet sahilinden izlenen gün batımı listemin başında.', 3, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Seyahat'),
(22, 'Modern Sanatta Soyutlama', 'Kandinsky\'nin çalışmaları üzerinden soyut sanatı tartıştık.', 4, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Sanat'),
(23, 'Online Derslerde Motivasyon', 'Uzaktan eğitimde dikkat dağınıklığıyla başa çıkma yöntemleri.', 1, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Eğitim'),
(24, 'Git ve Versiyon Kontrolü', 'Branch, merge ve rebase kavramlarını basit örneklerle anlattım.', 2, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Teknoloji'),
(25, 'Pamukkale Travertenleri', 'Beyaz teraslar arasında yürümek gerçekten farklı bir deneyim.', 3, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Seyahat'),
(26, 'Fotoğrafçılıkta Kompozisyon', 'Üçte bir kuralı ve altın oran fotoğraflarınızı nasıl güçlendirir.', 4, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Sanat'),
(27, 'Kütüphanede Verimli Çalışma', 'Sessiz ortamın odaklanmaya katkısını kendi deneyimimden anlattım.', 1, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Eğitim'),
(28, 'JavaScript\'te Asenkron İşlemler', 'Promise ve async/await yapılarını örneklerle inceledik.', 2, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Teknoloji'),
(29, 'Assos\'ta Bir Gün Batımı', 'Antik tiyatronun üzerinden izlenen manzara akıllardan çıkmıyor.', 3, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Seyahat'),
(30, 'Tipografi ve Görsel İletişim', 'Font seçimi bir tasarımın duygusunu nasıl belirler, konuştuk.', 4, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Sanat'),
(31, 'Sınav Kaygısıyla Başa Çıkmak', 'Nefes teknikleri ve planlı çalışmanın kaygıyı azaltmadaki rolü.', 1, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Eğitim'),
(32, 'SQL Sorgu Optimizasyonu', 'Index kullanımı sorgu performansını nasıl ciddi şekilde artırır.', 2, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Teknoloji'),
(33, 'Amasra\'da Sahil Yürüyüşü', 'Küçük liman şehri, kalabalıktan uzak sakin bir tatil için ideal.', 3, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Seyahat'),
(34, 'Heykeltıraşlıkta Işık ve Gölge', 'Bir heykelin farklı ışık altında nasıl değiştiğini gözlemledik.', 4, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Sanat'),
(35, 'Grup Projelerinde İletişim', 'Ekip çalışmasında net görev dağılımının önemini deneyimledim.', 1, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Eğitim'),
(36, 'React ile Bileşen Mantığı', 'Props ve state farkını basit bir örnek üzerinden açıkladım.', 2, 'draft', '2026-08-11 10:46:30', '2026-08-11 10:46:30', 'Teknoloji'),
(37, 'frehvnbehd', 'fnhnmdke', 5, 'draft', '2026-08-11 11:38:10', '2026-08-11 11:38:10', 'Sanat'),
(38, 'deneme', 'python', 3, 'draft', '2026-08-11 17:34:10', '2026-08-11 17:34:10', 'Eğitim');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `post_categories`
--

CREATE TABLE `post_categories` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `post_categories`
--

INSERT INTO `post_categories` (`id`, `post_id`, `category_id`) VALUES
(1, 1, 3),
(2, 2, 2),
(3, 3, 3),
(5, 5, 5);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `job` varchar(100) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `role` enum('user','admin') DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `job`, `photo`, `created_at`, `role`) VALUES
(1, 'melike', 'melike@gmail.com', 'scrypt:32768:8:1$a8kHCnQbKkcfpMzN$d5b23079e642cd6e7044d229474fcacbad6cc4be6e74f6f859ca789b8c1c48276ca0def1cc4e309cb70b15554a76ec7ad5423812614d2453535ec741d75334ec', 'Öğrenci', 'user_1.png', '2026-08-11 09:24:11', 'admin'),
(2, 'ahmet', 'ahmet@gmail.com', 'scrypt:32768:8:1$87JwHIw9jEtto4Zs$4528b335efdcfff3f41d0c8ac9c206d98eb7a24423b59f29d71514311aa517a02bd16f58f26b8723ec2040fb6562739ffef885f9e1066811f2933d7aa39e2674', 'Araştırmacı', NULL, '2026-08-11 09:25:00', 'user'),
(3, 'zeynep', 'zeynep@gmail.com', 'scrypt:32768:8:1$dQAcPWbDvs8YimkI$bc79bc30b9b548ff2f842b529dbeaf31db3de46ea96ce8da5e14139277f18421d945b1cc109a9d98373a49ae41535c942672e3e3b94825c1324d92601476acf6', 'Yazar', 'user_3.png', '2026-08-11 09:25:27', 'user'),
(4, 'mehmet', 'mehmet@gmail.com', 'scrypt:32768:8:1$hxSwpEf5ZyfL3RaB$37f96bb3a7ac833f8a89b0273985af5c0e4ac9a52dee4250794a4784d60b1ed9a9937e9f0eaa21f9bc43fa310815f60627891d3999b75a7937d2b5279a64e0b0', 'Öğretmen', 'user_4.png', '2026-08-11 09:25:45', 'user'),
(5, 'ebrar sıla', 'ebrar@gmail.com', 'scrypt:32768:8:1$Do2F79pLoqCOJ8Pl$f87025aa61f150ef88fd5aa9b57971f24cc063bfc6f0088f59a3e0f8d1460578ea54de426d3edf099dd618683843558a4eb4ea04043e6f598a1bb53219083c91', '', NULL, '2026-08-11 11:14:23', 'user'),
(6, 'mehmetali', 'ali@gmail.com', 'scrypt:32768:8:1$1LY3FbeW1viTd4UF$44b4c75317a70bb046d79c21c50f9fbce9936247b390ff6ac39595b2504d0fe4a2bba02819020ec0477936d2a976ebd9cd280bd5b84c7aa3827d9fb721b37187', '', NULL, '2026-08-11 11:14:47', 'user'),
(7, 'melek', 'melek@gmail.com', 'scrypt:32768:8:1$K0Hqx8duA2WKjFvz$208c2fe20c666807aa75362db0c6b5fb00c81ed362aaef5b278896024f6bfcb0fc3039f2c8005b81c2f7f59891cb85f5c9f05e8e990566f58e2e8b72dc14af7b', '', NULL, '2026-08-11 11:15:07', 'user'),
(8, 'hilal', 'hilal@gmail.com', 'scrypt:32768:8:1$wGUYhyLb2IiZgk7w$c3417173eab490dd0cb10a76f36c6372343b60fd61aeb70adcd9312422e453f68810d92b06a48fbafad2dff574f2f983b72d960854348c3066d7c298fe7853ce', '', NULL, '2026-08-11 11:15:25', 'user');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Tablo için indeksler `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Tablo için indeksler `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `post_id` (`post_id`);

--
-- Tablo için indeksler `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Tablo için indeksler `post_categories`
--
ALTER TABLE `post_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Tablo için indeksler `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Tablo için AUTO_INCREMENT değeri `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- Tablo için AUTO_INCREMENT değeri `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- Tablo için AUTO_INCREMENT değeri `post_categories`
--
ALTER TABLE `post_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Tablo kısıtlamaları `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`);

--
-- Tablo kısıtlamaları `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Tablo kısıtlamaları `post_categories`
--
ALTER TABLE `post_categories`
  ADD CONSTRAINT `post_categories_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `post_categories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
