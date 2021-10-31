class Address{
  String co;
  String house;
  String street;
  String lm; //Landmark
  String loc;
  String country;
  String vtc;
  String dist;
  String state;
  String pc;

  Address({required this.co, required this.house, required this.street, required this.lm, required this.loc, required this.country, required this.vtc, required this.dist, required this.state, required this.pc});

  Map<String, String> toJson(){
    return {
      'co': co,
      'house': house,
      'street': street,
      'lm': lm,
      'loc': loc,
      'country': country,
      'vtc': vtc,
      'dist': dist,
      'state': state,
      'pc': pc
    };
  }
}