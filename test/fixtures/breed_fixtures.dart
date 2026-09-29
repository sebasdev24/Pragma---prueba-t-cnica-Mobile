/// Respuestas reales de The Cat API (recortadas) para las pruebas.
/// Nótese que no traen `intelligence` ni `adaptability`: así responde hoy.
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

/// Raza real sin foto ni origen (Asian Semi-longhair en la API).
const Map<String, dynamic> noImageJson = {
  'id': 'asl',
  'name': 'Asian Semi-longhair',
  'life_span': '12-15',
  'temperament': 'Affectionate, Gentle',
  'description': 'Semi-longhaired cat.',
  'weight': {'metric': '3-6'},
  'height': {'metric': '25-30'},
};

/// Formato antiguo de la API, con las escalas que pide el enunciado.
const Map<String, dynamic> legacyScoresJson = {
  'id': 'beng',
  'name': 'Bengal',
  'description': 'Spotted.',
  'temperament': 'Alert, Agile',
  'intelligence': 5,
  'adaptability': 4,
  'reference_image_id': 'dN6eoeLjY',
};
