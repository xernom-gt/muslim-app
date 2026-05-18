/// ============================================
/// MODEL: Surat Al-Qur'an
/// ============================================
/// Merepresentasikan data surat dari API equran.id.
/// Terdiri dari 2 model: Surah (daftar surat) dan Ayah (ayat).

class Surah {
  final int nomor;
  final String nama;           // Nama Arab
  final String namaLatin;      // Nama Latin
  final int jumlahAyat;
  final String tempatTurun;    // Makkiyah / Madaniyah
  final String arti;           // Arti nama surat
  final String deskripsi;      // Deskripsi surat
  final String audio;          // URL audio full surat

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['namaLatin'] ?? '',
      jumlahAyat: json['jumlahAyat'] ?? 0,
      tempatTurun: json['tempatTurun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audio: json['audioFull']?['05'] ?? json['audioFull']?['01'] ?? '',
    );
  }
}

class Ayah {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;    // Terjemahan
  final String audio;            // URL audio per ayat

  Ayah({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      nomorAyat: json['nomorAyat'] ?? 0,
      teksArab: json['teksArab'] ?? '',
      teksLatin: json['teksLatin'] ?? '',
      teksIndonesia: json['teksIndonesia'] ?? '',
      audio: json['audio']?['05'] ?? json['audio']?['01'] ?? '',
    );
  }
}

/// Model detail surat beserta ayat-ayatnya
class SurahDetail {
  final Surah surah;
  final List<Ayah> ayat;

  SurahDetail({required this.surah, required this.ayat});

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    return SurahDetail(
      surah: Surah.fromJson(json),
      ayat: (json['ayat'] as List<dynamic>?)
              ?.map((a) => Ayah.fromJson(a))
              .toList() ??
          [],
    );
  }
}
