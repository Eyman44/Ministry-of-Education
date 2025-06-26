class CertificateResponse {
  final String status;
  final List<GeneralCertificate> data;

  CertificateResponse({required this.status, required this.data});

  factory CertificateResponse.fromJson(Map<String, dynamic> json) {
    return CertificateResponse(
      status: json['status'],
      data: (json['data'] as List)
          .map((e) => GeneralCertificate.fromJson(e))
          .toList(),
    );
  }
}

class GeneralCertificate {
  final int id;
  final String name;
  final List<CertificateType> certTypes;

  GeneralCertificate({required this.id, required this.name, required this.certTypes});

  factory GeneralCertificate.fromJson(Map<String, dynamic> json) {
    return GeneralCertificate(
      id: json['id'],
      name: json['name'],
      certTypes: (json['certTypes'] as List)
          .map((e) => CertificateType.fromJson(e))
          .toList(),
    );
  }
}

class CertificateType {
  final int id;
  final String name;
  final City city;
  final List<Subject> subjects;

  CertificateType({
    required this.id,
    required this.name,
    required this.city,
    required this.subjects,
  });

  factory CertificateType.fromJson(Map<String, dynamic> json) {
    return CertificateType(
      id: json['id'],
      name: json['name'],
      city: City.fromJson(json['city']),
      subjects: (json['subjects'] as List)
          .map((e) => Subject.fromJson(e))
          .toList(),
    );
  }
}

class City {
  final int id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Subject {
  final int id;
  final String name;
  final int minMark;
  final int maxMark;

  Subject({
    required this.id,
    required this.name,
    required this.minMark,
    required this.maxMark,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      minMark: json['minMark'],
      maxMark: json['maxMark'],
    );
  }
}
