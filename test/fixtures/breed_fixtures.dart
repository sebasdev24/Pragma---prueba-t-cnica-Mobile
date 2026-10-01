/// Respuestas reales de The Cat API, recortadas, para las pruebas. No
/// traen `intelligence` ni `adaptability` porque hoy la API ya no los manda.
const Map<String, dynamic> abyssinianJson = {
  'id': 'abys',
  'name': 'Abyssinian',
  'life_span': '14-17',
  'temperament':
      'Active, Energetic, Independent, Intelligent, Gentle, Curious, Playful',
  'origin': 'Egypt',
  'country_code': 'EG',
  'description':
      'Medium-sized, elegant cat with a distinctive ticked coat pattern.',
  'breed_group': 'Short-haired',
  'history': 'One of the oldest known cat breeds.',
  'reference_image_id': 'KWdLHmOqc',
  'weight': {'imperial': '8-12', 'metric': '3.6-5.4'},
  'height': {'imperial': '10-12', 'metric': '25-30'},
  'image': {
    'id': 'KWdLHmOqc',
    'url': 'https://cdn2.thecatapi.com/images/KWdLHmOqc.jpg',
    'width': 1200,
    'height': 800,
  },
};

/// Una raza real que no tiene foto ni origen (Asian Semi-longhair).
const Map<String, dynamic> noImageJson = {
  'id': 'asl',
  'name': 'Asian Semi-longhair',
  'life_span': '12-15',
  'temperament': 'Affectionate, Gentle',
  'description': 'Semi-longhaired cat.',
  'weight': {'metric': '3-6'},
  'height': {'metric': '25-30'},
};

/// Así responde `/breeds/{id}`: con `reference_image_id` pero sin el
/// objeto `image`.
const Map<String, dynamic> referenceOnlyJson = {
  'id': 'beng',
  'name': 'Bengal',
  'description': 'Spotted.',
  'temperament': 'Alert, Agile',
  'weight': {'imperial': '10 - 18', 'metric': '4.5 - 8.2'},
  'reference_image_id': 'dN6eoeLjY',
};
