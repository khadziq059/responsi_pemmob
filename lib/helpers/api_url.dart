class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/api/pariwisata';
  static const String registrasi = 'http://responsi.webwizards.my.id/api/registrasi';
  static const String login = 'http://responsi.webwizards.my.id/api/login';
  static const String listPemandu = baseUrl + '/pemandu_wisata';
  static const String createPemandu = baseUrl + '/pemandu_wisata';
  static String updatePemandu(int id) {
    return baseUrl + '/pemandu_wisata/' + id.toString() + '/update';
  }

  static String showPemandu(int id) {
    return baseUrl + '/pemandu_wisata/' + id.toString();
  }

  static String deletePemandu(int id) {
    return baseUrl + '/pemandu_wisata/' + id.toString() + '/delete';
  }
}
