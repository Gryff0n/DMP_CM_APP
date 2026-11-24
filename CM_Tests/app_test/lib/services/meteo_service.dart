/// Abstraction de la source de données (l'implémentation réelle
/// utiliserait le paquet http).
abstract class MeteoApi {
  Future<double> temperature(String ville);
}

class MeteoException implements Exception {
  final String message;
  MeteoException(this.message);
}

class MeteoService {
  final MeteoApi api;

  MeteoService(this.api); // injection de dépendance

  /// Renvoie un conseil vestimentaire selon la température.
  Future<String> conseil(String ville) async {
    if (ville.trim().isEmpty) {
      throw MeteoException('Ville non renseignée');
    }
    try {
      final t = await api.temperature(ville);
      if (t < 10) return 'Prenez un manteau';
      if (t < 20) return 'Un pull suffira';
      return 'Tenue légère';
    } catch (_) {
      throw MeteoException('Service météo indisponible');
    }
  }

  Future<double> moyenne(List<String> villes) async {
    if (villes.isEmpty) throw MeteoException('Villes vides');

    double m = 0;
    int c = 0;
    try {
      for (int i = 0; i < villes.length; i++) {
        m += await api.temperature(villes[i]);
        c++;
      }
      m = m / c;
      return m;
    } catch (_) {
      throw MeteoException('Service météo indisponible');
    }
  }
}
