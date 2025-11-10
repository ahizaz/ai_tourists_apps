import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'fr_FR': frFR,
        'es_ES': esES,
      };

  // English translations
  static const Map<String, String> enUS = {
    // Language Selection
    'select_language': 'Select Language',
    'language': 'Language',
    'english': 'English',
    'french': 'Français',
    'spanish': 'Español',
    
    // Splash Screen
    'discover_the': 'Discover the',
    'ai_travel_assist': 'AI Travel Assist App',
    'smart_recommendations': 'Smart recommendations and real-time',
    'guidance_fingertips': 'guidance at your fingertips',
    'next': 'Next',
    
    // Splash Screen Second
    'explore_effortlessly': 'Explore Without Limits',
    'navigate_plan': 'Enjoy offline access and smart recommendations,',
    'ai_assistance': 'anytime, anywhere',
    'get_start': 'Get Start',
    
    // Splash Screen Third
    'ai_travel_companion': 'Your AI Travel Companion',
    'receive_realtime': 'Receive real-time navigation, personalized',
    'tips_support': 'tips, and multi-language support',
    'go_to_home': 'Go To Home',
    
    // Sign In
    'sign_in_account': 'Sign In Your Account',
    'phone_or_email': 'Phone number or email',
    'password': 'Password',
    'remember_me': 'Remember me',
    'forget_password': 'Forget password?',
    'sign_in': 'Sign In',
    'dont_have_account': "Don't have an account?",
    'sign_up': 'Sign Up',
    
    // Sign Up
    'sign_up_account': 'Sign Up Your Account',
    'full_name': 'Full Name',
    'email': 'Email',
    'phone_number': 'Phone Number',
    'confirm_password': 'Confirm Password',
    'already_have_account': 'Already have an account?',
    
    // Common
    'continue': 'Continue',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    'save': 'Save',
    'edit': 'Edit',
    'delete': 'Delete',
    'search': 'Search',
    'filter': 'Filter',
    'apply': 'Apply',
    'reset': 'Reset',
    'yes': 'Yes',
    'no': 'No',
    'ok': 'OK',
    'hello': 'Hello',
    
    // Categories
    'all': 'All',
    'historical': 'Historical',
    'museum': 'Museum',
    'tourism': 'Tourism',
    'most_nearby': 'Most Nearby',
    'no_places_found': 'No nearby places found.',
    'current_location': 'Current location',
    'weather': 'Weather',
    'see_map': 'See Map',
    
    // Places
    'great_wall_china': 'Great Wall of China',
    'great_wall_desc': 'The Great Wall of China is a series of fortifications made of stone, brick, tamped earth, wood, and other materials.',
    'national_museum': 'National History Museum',
    'national_museum_desc': 'Explore ancient artifacts and natural history exhibitions from around the world.',
    'city_park': 'City Park',
    'city_park_desc': 'A big green area great for walking, cycling and family activities.',
    'great_wall_scenic': 'Great Wall Scenic Spot',
    'great_wall_scenic_desc': 'Beautiful viewpoint with restored watchtowers and easy access trails.',
  };

  // French translations
  static const Map<String, String> frFR = {
    // Language Selection
    'select_language': 'Sélectionner la langue',
    'language': 'Langue',
    'english': 'English',
    'french': 'Français',
    'spanish': 'Español',
    
    // Splash Screen
    'discover_the': 'Découvrez',
    'ai_travel_assist': 'L\'app de voyage IA',
    'smart_recommendations': 'Recommandations intelligentes et',
    'guidance_fingertips': 'guidage en temps réel',
    'next': 'Suivant',
    
    // Splash Screen Second
    'explore_effortlessly': 'Explorez sans limites',
    'navigate_plan': 'Accès hors ligne et recommandations,',
    'ai_assistance': 'partout, tout le temps',
    'get_start': 'Commencer',
    
    // Splash Screen Third
    'ai_travel_companion': 'Compagnon de voyage IA',
    'receive_realtime': 'Navigation en temps réel, conseils',
    'tips_support': 'personnalisés et support multilingue',
    'go_to_home': 'Aller à l\'accueil',
    
    // Sign In
    'sign_in_account': 'Connectez-vous à votre compte',
    'phone_or_email': 'Numéro de téléphone ou e-mail',
    'password': 'Mot de passe',
    'remember_me': 'Se souvenir de moi',
    'forget_password': 'Mot de passe oublié?',
    'sign_in': 'Se connecter',
    'dont_have_account': "Vous n'avez pas de compte?",
    'sign_up': 'S\'inscrire',
    
    // Sign Up
    'sign_up_account': 'Créer votre compte',
    'full_name': 'Nom complet',
    'email': 'E-mail',
    'phone_number': 'Numéro de téléphone',
    'confirm_password': 'Confirmer le mot de passe',
    'already_have_account': 'Vous avez déjà un compte?',
    
    // Common
    'continue': 'Continuer',
    'cancel': 'Annuler',
    'confirm': 'Confirmer',
    'save': 'Enregistrer',
    'edit': 'Modifier',
    'delete': 'Supprimer',
    'search': 'Rechercher',
    'filter': 'Filtrer',
    'apply': 'Appliquer',
    'reset': 'Réinitialiser',
    'yes': 'Oui',
    'no': 'Non',
    'ok': 'OK',
    'hello': 'Bonjour',
    
    // Categories
    'all': 'Tout',
    'historical': 'Historique',
    'museum': 'Musée',
    'tourism': 'Tourisme',
    'most_nearby': 'Plus proche',
    'no_places_found': 'Aucun lieu à proximité trouvé.',
    'current_location': 'Emplacement actuel',
    'weather': 'Météo',
    'see_map': 'Voir la carte',
    
    // Places
    'great_wall_china': 'Grande Muraille de Chine',
    'great_wall_desc': 'La Grande Muraille de Chine est une série de fortifications faites de pierre, de brique, de terre battue, de bois et d\'autres matériaux.',
    'national_museum': 'Musée National d\'Histoire',
    'national_museum_desc': 'Explorez des artefacts anciens et des expositions d\'histoire naturelle du monde entier.',
    'city_park': 'Parc de la Ville',
    'city_park_desc': 'Un grand espace vert idéal pour la marche, le vélo et les activités familiales.',
    'great_wall_scenic': 'Point de Vue Grande Muraille',
    'great_wall_scenic_desc': 'Magnifique point de vue avec des tours de guet restaurées et des sentiers d\'accès facile.',
  };

  // Spanish translations
  static const Map<String, String> esES = {
    // Language Selection
    'select_language': 'Seleccionar idioma',
    'language': 'Idioma',
    'english': 'English',
    'french': 'Français',
    'spanish': 'Español',
    
    // Splash Screen
    'discover_the': 'Descubre la',
    'ai_travel_assist': 'App de viaje con IA',
    'smart_recommendations': 'Recomendaciones inteligentes y',
    'guidance_fingertips': 'orientación en tiempo real',
    'next': 'Siguiente',
    
    // Splash Screen Second
    'explore_effortlessly': 'Explora sin límites',
    'navigate_plan': 'Acceso offline y recomendaciones,',
    'ai_assistance': 'en cualquier momento y lugar',
    'get_start': 'Comenzar',
    
    // Splash Screen Third
    'ai_travel_companion': 'Compañero de viaje IA',
    'receive_realtime': 'Navegación en tiempo real, consejos',
    'tips_support': 'personalizados y soporte multilingüe',
    'go_to_home': 'Ir al inicio',
    
    // Sign In
    'sign_in_account': 'Inicia sesión en tu cuenta',
    'phone_or_email': 'Número de teléfono o correo electrónico',
    'password': 'Contraseña',
    'remember_me': 'Recuérdame',
    'forget_password': '¿Olvidaste tu contraseña?',
    'sign_in': 'Iniciar sesión',
    'dont_have_account': '¿No tienes una cuenta?',
    'sign_up': 'Registrarse',
    
    // Sign Up
    'sign_up_account': 'Crea tu cuenta',
    'full_name': 'Nombre completo',
    'email': 'Correo electrónico',
    'phone_number': 'Número de teléfono',
    'confirm_password': 'Confirmar contraseña',
    'already_have_account': '¿Ya tienes una cuenta?',
    
    // Common
    'continue': 'Continuar',
    'cancel': 'Cancelar',
    'confirm': 'Confirmar',
    'save': 'Guardar',
    'edit': 'Editar',
    'delete': 'Eliminar',
    'search': 'Buscar',
    'filter': 'Filtrar',
    'apply': 'Aplicar',
    'reset': 'Restablecer',
    'yes': 'Sí',
    'no': 'No',
    'ok': 'OK',
    'hello': 'Hola',
    
    // Categories
    'all': 'Todo',
    'historical': 'Histórico',
    'museum': 'Museo',
    'tourism': 'Turismo',
    'most_nearby': 'Más cercano',
    'no_places_found': 'No se encontraron lugares cercanos.',
    'current_location': 'Ubicación actual',
    'weather': 'Clima',
    'see_map': 'Ver mapa',
    
    // Places
    'great_wall_china': 'Gran Muralla China',
    'great_wall_desc': 'La Gran Muralla China es una serie de fortificaciones hechas de piedra, ladrillo, tierra apisonada, madera y otros materiales.',
    'national_museum': 'Museo Nacional de Historia',
    'national_museum_desc': 'Explora artefactos antiguos y exhibiciones de historia natural de todo el mundo.',
    'city_park': 'Parque de la Ciudad',
    'city_park_desc': 'Una gran área verde ideal para caminar, andar en bicicleta y actividades familiares.',
    'great_wall_scenic': 'Mirador Gran Muralla',
    'great_wall_scenic_desc': 'Hermoso mirador con torres de vigilancia restauradas y senderos de fácil acceso.',
  };
}
