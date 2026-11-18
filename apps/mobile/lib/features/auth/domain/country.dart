/// Launch markets, in the order the picker shows them.
enum Country {
  nigeria('NG', 'Nigeria', '+234', '🇳🇬', '0803 123 4567'),
  kenya('KE', 'Kenya', '+254', '🇰🇪', '0712 345 678'),
  ghana('GH', 'Ghana', '+233', '🇬🇭', '024 123 4567'),
  southAfrica('ZA', 'South Africa', '+27', '🇿🇦', '082 123 4567')
  ;

  const Country(this.code, this.name, this.dialCode, this.flag, this.example);

  /// ISO 3166-1 alpha-2.
  final String code;
  final String name;
  final String dialCode;
  final String flag;
  final String example;

  static Country fromCode(String? code) => values.firstWhere(
    (country) => country.code == code,
    orElse: () => Country.nigeria,
  );
}
