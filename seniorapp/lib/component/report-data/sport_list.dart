List<String> sportList = [
  'Ceremony',
  'Beach Volleyball',
  'Karate',
  'Athletics',
  'Football',
  'Rowing & Traditional Boat',
  'Volleyball',
  'Sport Climbing',
  'Tennis',
  'Badminton',
  'Fencing',
  'Chess',
  'Futsal',
  'Muay Thai',
  'Basketball',
  'Petanque',
  'Swimming',
  'Sepak Takraw',
  'Archery',
  'Pencak Silat',
  'Table Tennis',
  'E-sports',
  'Taekwondo',
  'Wushu',
];

List<String> sortedSport(List<String> sport) {
  sport.sort((a,b) => a.toString().toLowerCase().compareTo(b.toLowerCase().toString()));
  return sport;
}