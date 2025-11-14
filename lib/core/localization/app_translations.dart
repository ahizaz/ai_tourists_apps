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
    
    // Profile Screen
    'account': 'Account',
    'subscription': 'Subscription',
    'play_quiz': 'Play Quiz',
    'ai_setup': 'AI Setup',
    'save_place': 'Save Place',
    'download_offline_map': 'Download Offline Map',
    'terms_condition': 'Terms & Condition',
    
    // AI Travel Assistant
    'ai_travel_assistant': 'AI Travel Assistant',
    'ai_is_thinking': 'AI is thinking...',
    'start_conversation': 'Start your conversation here…',
    'every_picture_history': 'Every picture has a history—let AI',
    'reveal_it': 'reveal it to you',
    'upload_snap_photo': 'Upload or snap a photo, and AI will tell you the full',
    'story_history': 'story of its history.',
    'choose_image_source': 'Choose Image Source',
    'gallery': 'Gallery',
    'camera': 'Camera',
    
    // Sign Up
    'create_an_account': 'Create An Account',
    'name': 'Name',
    'email_or_phone': 'Email or phone number',
    'i_agree_to': 'I agree to the',
    'terms_and_condition': 'Terms & Condition',
    
    // Reset Password
    'reset_password': 'Reset Password',
    'create_new_password': 'Create New Password',
    'new_password_required': 'Your new password must be different',
    'from_previous_password': 'from previous used passwords',
    'new_password': 'New Password',
    'confirm_password_field': 'Confirm Password',
    'reset_password_btn': 'Reset Password',
    
    // Map Screen
    'search_location': 'Search location',
    'you_are_here': 'You are here',
    'selected_location': 'Selected location',
    
    // Account Screen
    'account_info': 'Account',
    'full_name_label': 'Full Name',
    'email_label': 'E-mail',
    'deactivate_account': 'Deactivate Account',
    'delete_account': 'Delete Account',
    'enter_new_value': 'Enter new value',
    'save_btn': 'Save',
    'cancel_btn': 'Cancel',
    
    // AI Assistant Setup
    'ai_preferences': 'AI Preferences',
    'ai_preferences_voice': 'AI Preferences Voice',
    'ai_gender': 'AI Gender',
    'ai_voice': 'AI Voice',
    'ai_voice_type': 'AI Voice Type',
    'male': 'Male',
    'female': 'Female',
    'next_btn': 'Next',
    'complete_btn': 'Complete',
    'skip': 'Skip',
    'intelligent_companion': 'Your intelligent companion for exploring and',
    'managing_travel': 'managing travel experiences.',
    'effortlessly_explore': 'Effortlessly explore and manage points of',
    'interest_for_travels': 'interest for your travels, including',
    'attractions_restaurants': 'attractions, restaurants, and activities.',
    'contribute_unique': 'Contribute unique insights and experiences',
    'enhance_database': 'to enhance our travel database and earn',
    'rewards': 'rewards',
    
    // Subscription
    'subscription_plan': 'Subscription',
    'choose_plan': 'Choose the plan',
    'monthly': 'Monthly',
    'yearly': 'Yearly',
    'subscribe': 'Subscribe',
    'includes': 'Includes',
    
    // Save Place
    'saved_places': 'Saved Places',
    'my_saved_places': 'My Saved Places',
    'save_your_favorite': 'Save your favorite places and access them anytime',
    
    // Quiz
    'test_travel_knowledge': 'Test Your Travel Knowledge',
    'fun_quizzes_ai': 'Fun quizzes generated by AI, based on',
    'places_you_explore': 'the places you explore',
    'start_quiz': 'Start Quiz',
    'select_category': 'Select Category',
    'submit': 'Submit',
    'score': 'Score',
    'visit_complete': 'Visit Complete! 🎉',
    'quiz_suggestion_message': 'Great job exploring! Would you like to test your knowledge about this place with a fun quiz?',
    'maybe_later': 'Maybe Later',
    
    // Download Map
    'download_map': 'Download Offline Map',
    'select_area': 'Select Area to Download',
    'download': 'Download',
    'rename': 'Rename',
    'delete': 'Delete',
    'rename_map': 'Rename Map',
    'delete_map': 'Delete Map',
    'are_you_sure_delete': 'Are you sure you want to delete this map?',
    
    // Terms & Conditions
    'terms_conditions_title': 'Terms & Conditions',
    'welcome_to_app': 'Welcome to AI Tourists',
    'last_updated': 'Last Updated: November 2024',
    'use_of_app': '1. Use of the App',
    'user_accounts': '2. User Accounts & Information',
    'content_services': '3. Content & Third-Party Services',
    'bookings_payments': '4. Bookings & Payments',
    'privacy': '5. Privacy',
    'limitation_liability': '6. Limitation of Liability',
    'changes_to_terms': '7. Changes to Terms',
    'governing_law': '8. Governing Law',
    'i_understand': 'I Understand',
    'contact_us': 'Contact Us',
    
    // Place Details
    'book_now': 'Book Now',
    'description': 'Description',
    'location': 'Location',
    'reviews': 'Reviews',
    'rating': 'Rating',
    
    // Booking
    'booking_title': 'Booking.com',
    'search_hotels': 'Search hotels',
    'search_hotels_subtitle': 'From cozy country homes to funky city apartments',
    'destination_name': 'Destination name',
    'destination_placeholder': 'e.g. city, region, district or specific hotel',
    'check_in_date': 'Check-in date',
    'check_out_date': 'Check-out date',
    'night': 'night',
    'nights': 'nights',
    'stay': 'stay',
    'destination_required': 'Destination Required',
    'enter_destination': 'Please enter a destination name',
    'search_complete': 'Search Complete',
    'searching_hotels_in': 'Searching hotels in',
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
    
    // Profile Screen
    'account': 'Compte',
    'subscription': 'Abonnement',
    'play_quiz': 'Jouer au quiz',
    'ai_setup': 'Configuration IA',
    'save_place': 'Enregistrer le lieu',
    'download_offline_map': 'Télécharger la carte hors ligne',
    'terms_condition': 'Termes et conditions',
    
    // AI Travel Assistant
    'ai_travel_assistant': 'Assistant de voyage IA',
    'ai_is_thinking': 'L\'IA réfléchit...',
    'start_conversation': 'Commencez votre conversation ici…',
    'every_picture_history': 'Chaque image a une histoire—laissez l\'IA',
    'reveal_it': 'vous la révéler',
    'upload_snap_photo': 'Téléchargez ou prenez une photo, et l\'IA vous racontera',
    'story_history': 'toute son histoire.',
    'choose_image_source': 'Choisir la source de l\'image',
    'gallery': 'Galerie',
    'camera': 'Caméra',
    
    // Sign Up
    'create_an_account': 'Créer un compte',
    'name': 'Nom',
    'email_or_phone': 'E-mail ou numéro de téléphone',
    'i_agree_to': 'J\'accepte les',
    'terms_and_condition': 'Termes et conditions',
    
    // Reset Password
    'reset_password': 'Réinitialiser le mot de passe',
    'create_new_password': 'Créer un nouveau mot de passe',
    'new_password_required': 'Votre nouveau mot de passe doit être différent',
    'from_previous_password': 'des mots de passe précédents',
    'new_password': 'Nouveau mot de passe',
    'confirm_password_field': 'Confirmer le mot de passe',
    'reset_password_btn': 'Réinitialiser le mot de passe',
    
    // Map Screen
    'search_location': 'Rechercher un emplacement',
    'you_are_here': 'Vous êtes ici',
    'selected_location': 'Emplacement sélectionné',
    
    // Account Screen
    'account_info': 'Compte',
    'full_name_label': 'Nom complet',
    'email_label': 'E-mail',
    'deactivate_account': 'Désactiver le compte',
    'delete_account': 'Supprimer le compte',
    'enter_new_value': 'Entrer une nouvelle valeur',
    'save_btn': 'Enregistrer',
    'cancel_btn': 'Annuler',
    
    // AI Assistant Setup
    'ai_preferences': 'Préférences IA',
    'ai_preferences_voice': 'Préférences vocales IA',
    'ai_gender': 'Genre IA',
    'ai_voice': 'Voix IA',
    'ai_voice_type': 'Type de voix IA',
    'male': 'Masculin',
    'female': 'Féminin',
    'next_btn': 'Suivant',
    'complete_btn': 'Terminer',
    'skip': 'Passer',
    'intelligent_companion': 'Votre compagnon intelligent pour explorer et',
    'managing_travel': 'gérer vos expériences de voyage.',
    'effortlessly_explore': 'Explorez et gérez facilement les points',
    'interest_for_travels': 'd\'intérêt pour vos voyages, y compris',
    'attractions_restaurants': 'attractions, restaurants et activités.',
    'contribute_unique': 'Contribuez des idées et expériences uniques',
    'enhance_database': 'pour enrichir notre base de données et gagner',
    'rewards': 'des récompenses',
    
    // Subscription
    'subscription_plan': 'Abonnement',
    'choose_plan': 'Choisissez le plan',
    'monthly': 'Mensuel',
    'yearly': 'Annuel',
    'subscribe': 'S\'abonner',
    'includes': 'Comprend',
    
    // Save Place
    'saved_places': 'Lieux enregistrés',
    'my_saved_places': 'Mes lieux enregistrés',
    'save_your_favorite': 'Enregistrez vos lieux préférés et accédez-y à tout moment',
    
    // Quiz
    'test_travel_knowledge': 'Testez vos connaissances en voyage',
    'fun_quizzes_ai': 'Quiz amusants générés par IA, basés sur',
    'places_you_explore': 'les endroits que vous explorez',
    'start_quiz': 'Commencer le quiz',
    'select_category': 'Sélectionner une catégorie',
    'submit': 'Soumettre',
    'score': 'Score',
    'visit_complete': 'Visite terminée ! 🎉',
    'quiz_suggestion_message': 'Excellent travail d\'exploration ! Voulez-vous tester vos connaissances sur ce lieu avec un quiz amusant ?',
    'maybe_later': 'Peut-être plus tard',
    
    // Download Map
    'download_map': 'Télécharger la carte hors ligne',
    'select_area': 'Sélectionner la zone à télécharger',
    'download': 'Télécharger',
    'rename': 'Renommer',
    'delete': 'Supprimer',
    'rename_map': 'Renommer la carte',
    'delete_map': 'Supprimer la carte',
    'are_you_sure_delete': 'Êtes-vous sûr de vouloir supprimer cette carte?',
    
    // Terms & Conditions
    'terms_conditions_title': 'Termes et conditions',
    'welcome_to_app': 'Bienvenue sur AI Tourists',
    'last_updated': 'Dernière mise à jour: Novembre 2024',
    'use_of_app': '1. Utilisation de l\'application',
    'user_accounts': '2. Comptes utilisateurs et informations',
    'content_services': '3. Contenu et services tiers',
    'bookings_payments': '4. Réservations et paiements',
    'privacy': '5. Confidentialité',
    'limitation_liability': '6. Limitation de responsabilité',
    'changes_to_terms': '7. Modifications des conditions',
    'governing_law': '8. Loi applicable',
    'i_understand': 'Je comprends',
    'contact_us': 'Contactez-nous',
    
    // Place Details
    'book_now': 'Réserver maintenant',
    'description': 'Description',
    'location': 'Emplacement',
    'reviews': 'Avis',
    'rating': 'Note',
    
    // Booking
    'booking_title': 'Booking.com',
    'search_hotels': 'Rechercher des hôtels',
    'search_hotels_subtitle': 'Des maisons de campagne confortables aux appartements branchés',
    'destination_name': 'Nom de la destination',
    'destination_placeholder': 'ex. ville, région, quartier ou hôtel spécifique',
    'check_in_date': 'Date d\'arrivée',
    'check_out_date': 'Date de départ',
    'night': 'nuit',
    'nights': 'nuits',
    'stay': 'séjour',
    'destination_required': 'Destination requise',
    'enter_destination': 'Veuillez entrer un nom de destination',
    'search_complete': 'Recherche terminée',
    'searching_hotels_in': 'Recherche d\'hôtels à',
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
    
    // Profile Screen
    'account': 'Cuenta',
    'subscription': 'Suscripción',
    'play_quiz': 'Jugar cuestionario',
    'ai_setup': 'Configuración IA',
    'save_place': 'Guardar lugar',
    'download_offline_map': 'Descargar mapa sin conexión',
    'terms_condition': 'Términos y condiciones',
    
    // AI Travel Assistant
    'ai_travel_assistant': 'Asistente de viaje IA',
    'ai_is_thinking': 'La IA está pensando...',
    'start_conversation': 'Comience su conversación aquí…',
    'every_picture_history': 'Cada imagen tiene una historia—deja que la IA',
    'reveal_it': 'te la revele',
    'upload_snap_photo': 'Sube o toma una foto, y la IA te contará',
    'story_history': 'toda su historia.',
    'choose_image_source': 'Elegir fuente de imagen',
    'gallery': 'Galería',
    'camera': 'Cámara',
    
    // Sign Up
    'create_an_account': 'Crear una cuenta',
    'name': 'Nombre',
    'email_or_phone': 'Correo electrónico o teléfono',
    'i_agree_to': 'Estoy de acuerdo con los',
    'terms_and_condition': 'Términos y condiciones',
    
    // Reset Password
    'reset_password': 'Restablecer contraseña',
    'create_new_password': 'Crear nueva contraseña',
    'new_password_required': 'Su nueva contraseña debe ser diferente',
    'from_previous_password': 'de las contraseñas anteriores',
    'new_password': 'Nueva contraseña',
    'confirm_password_field': 'Confirmar contraseña',
    'reset_password_btn': 'Restablecer contraseña',
    
    // Map Screen
    'search_location': 'Buscar ubicación',
    'you_are_here': 'Estás aquí',
    'selected_location': 'Ubicación seleccionada',
    
    // Account Screen
    'account_info': 'Cuenta',
    'full_name_label': 'Nombre completo',
    'email_label': 'Correo electrónico',
    'deactivate_account': 'Desactivar cuenta',
    'delete_account': 'Eliminar cuenta',
    'enter_new_value': 'Ingrese un nuevo valor',
    'save_btn': 'Guardar',
    'cancel_btn': 'Cancelar',
    
    // AI Assistant Setup
    'ai_preferences': 'Preferencias IA',
    'ai_preferences_voice': 'Preferencias de voz IA',
    'ai_gender': 'Género IA',
    'ai_voice': 'Voz IA',
    'ai_voice_type': 'Tipo de voz IA',
    'male': 'Masculino',
    'female': 'Femenino',
    'next_btn': 'Siguiente',
    'complete_btn': 'Completar',
    'skip': 'Saltar',
    'intelligent_companion': 'Tu compañero inteligente para explorar y',
    'managing_travel': 'gestionar experiencias de viaje.',
    'effortlessly_explore': 'Explora y gestiona puntos de',
    'interest_for_travels': 'interés para tus viajes, incluyendo',
    'attractions_restaurants': 'atracciones, restaurantes y actividades.',
    'contribute_unique': 'Contribuye con ideas y experiencias únicas',
    'enhance_database': 'para mejorar nuestra base de datos y ganar',
    'rewards': 'recompensas',
    
    // Subscription
    'subscription_plan': 'Suscripción',
    'choose_plan': 'Elige el plan',
    'monthly': 'Mensual',
    'yearly': 'Anual',
    'subscribe': 'Suscribirse',
    'includes': 'Incluye',
    
    // Save Place
    'saved_places': 'Lugares guardados',
    'my_saved_places': 'Mis lugares guardados',
    'save_your_favorite': 'Guarda tus lugares favoritos y accede a ellos en cualquier momento',
    
    // Quiz
    'test_travel_knowledge': 'Prueba tus conocimientos de viaje',
    'fun_quizzes_ai': 'Cuestionarios divertidos generados por IA, basados en',
    'places_you_explore': 'los lugares que exploras',
    'start_quiz': 'Comenzar cuestionario',
    'select_category': 'Seleccionar categoría',
    'submit': 'Enviar',
    'score': 'Puntuación',
    'visit_complete': '¡Visita completada! 🎉',
    'quiz_suggestion_message': '¡Excelente trabajo explorando! ¿Te gustaría probar tus conocimientos sobre este lugar con un cuestionario divertido?',
    'maybe_later': 'Tal vez más tarde',
    
    // Download Map
    'download_map': 'Descargar mapa sin conexión',
    'select_area': 'Seleccionar área para descargar',
    'download': 'Descargar',
    'rename': 'Renombrar',
    'delete': 'Eliminar',
    'rename_map': 'Renombrar mapa',
    'delete_map': 'Eliminar mapa',
    'are_you_sure_delete': '¿Estás seguro de que quieres eliminar este mapa?',
    
    // Terms & Conditions
    'terms_conditions_title': 'Términos y condiciones',
    'welcome_to_app': 'Bienvenido a AI Tourists',
    'last_updated': 'Última actualización: Noviembre 2024',
    'use_of_app': '1. Uso de la aplicación',
    'user_accounts': '2. Cuentas de usuario e información',
    'content_services': '3. Contenido y servicios de terceros',
    'bookings_payments': '4. Reservas y pagos',
    'privacy': '5. Privacidad',
    'limitation_liability': '6. Limitación de responsabilidad',
    'changes_to_terms': '7. Cambios en los términos',
    'governing_law': '8. Ley aplicable',
    'i_understand': 'Entiendo',
    'contact_us': 'Contáctenos',
    
    // Place Details
    'book_now': 'Reservar ahora',
    'description': 'Descripción',
    'location': 'Ubicación',
    'reviews': 'Reseñas',
    'rating': 'Calificación',
    
    // Booking
    'booking_title': 'Booking.com',
    'search_hotels': 'Buscar hoteles',
    'search_hotels_subtitle': 'Desde acogedoras casas de campo hasta apartamentos urbanos modernos',
    'destination_name': 'Nombre del destino',
    'destination_placeholder': 'ej. ciudad, región, distrito u hotel específico',
    'check_in_date': 'Fecha de entrada',
    'check_out_date': 'Fecha de salida',
    'night': 'noche',
    'nights': 'noches',
    'stay': 'estadía',
    'destination_required': 'Destino requerido',
    'enter_destination': 'Por favor ingrese un nombre de destino',
    'search_complete': 'Búsqueda completa',
    'searching_hotels_in': 'Buscando hoteles en',
  };
}
