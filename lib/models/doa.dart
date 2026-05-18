/// ============================================
/// MODEL: Doa (Supplication)
/// ============================================
/// Merepresentasikan data doa dari API.

class Doa {
  final String id;
  final String doa;        // Judul / nama doa
  final String ayat;       // Teks Arab doa
  final String latin;      // Teks Latin
  final String artinya;    // Arti / terjemahan

  Doa({
    required this.id,
    required this.doa,
    required this.ayat,
    required this.latin,
    required this.artinya,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      id: json['id']?.toString() ?? '',
      doa: json['doa'] ?? '',
      ayat: json['ayat'] ?? '',
      latin: json['latin'] ?? '',
      artinya: json['artinya'] ?? '',
    );
  }
}
