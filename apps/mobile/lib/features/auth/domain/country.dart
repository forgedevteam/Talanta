/// Launch markets, in the order the picker shows them.
enum Country {
  cameroon(
    code: 'CM',
    name: 'Cameroon',
    frenchName: 'Cameroun',
    dialCode: '+237',
    flag: '🇨🇲',
    example: '6 71 23 45 67',
    exampleCity: 'Douala',
  ),
  nigeria(
    code: 'NG',
    name: 'Nigeria',
    frenchName: 'Nigeria',
    dialCode: '+234',
    flag: '🇳🇬',
    example: '0803 123 4567',
    exampleCity: 'Lagos',
  ),
  kenya(
    code: 'KE',
    name: 'Kenya',
    frenchName: 'Kenya',
    dialCode: '+254',
    flag: '🇰🇪',
    example: '0712 345 678',
    exampleCity: 'Nairobi',
  ),
  ghana(
    code: 'GH',
    name: 'Ghana',
    frenchName: 'Ghana',
    dialCode: '+233',
    flag: '🇬🇭',
    example: '024 123 4567',
    exampleCity: 'Accra',
  ),
  southAfrica(
    code: 'ZA',
    name: 'South Africa',
    frenchName: 'Afrique du Sud',
    dialCode: '+27',
    flag: '🇿🇦',
    example: '082 123 4567',
    exampleCity: 'Johannesburg',
  )
  ;

  const Country({
    required this.code,
    required this.name,
    required this.frenchName,
    required this.dialCode,
    required this.flag,
    required this.example,
    required this.exampleCity,
  });

  /// ISO 3166-1 alpha-2.
  final String code;
  final String name;
  final String frenchName;
  final String dialCode;
  final String flag;

  /// A local number in the format people write it, shown as a hint.
  final String example;

  /// Shown as the hint in the city field.
  final String exampleCity;

  /// The name in the app's current language.
  String displayName(String languageCode) =>
      languageCode == 'fr' ? frenchName : name;

  static Country fromCode(String? code) => values.firstWhere(
    (country) => country.code == code,
    orElse: () => Country.cameroon,
  );
}
