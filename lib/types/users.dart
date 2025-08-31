// ignore_for_file: non_constant_identifier_names

class MyUser {
  String nom;
  String prenom;
  String dateNaissance;
  String sexe;
  String preference;
  String email;
  String profession;
  String pays;
  String ville;
  String bio;

  MyUser({
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.sexe,
    required this.email,
    required this.profession,
    required this.pays,
    required this.ville,
    required this.bio, 
    required this.preference,
  });

   // CONVERSION DE MAP -->  MyUser

  factory MyUser.fromMap(Map<String,dynamic> map){
   return MyUser( 
    nom: map['nom'] as String, 
    prenom: map['prenom'], 
    dateNaissance: map['date_naissance'] as String, 
    sexe: map['sexe'] as String, 
    preference: map['preference'] as String,
    email: map['email']as String , 
    profession: map['profession'] as String, 
    pays: map['pays'] as String, 
    ville: map['ville'] as String, 
    bio: map['bio'] as String);
  }

  // CONVERSION DE MyUser --> MAP

  Map<String, dynamic> toMap(){
    return{
      'nom' : nom,
      'prenom' : prenom,
      'email' : email,
      'date_naissance' : dateNaissance,
      'sexe' : sexe,
      'preference' : preference,
      'profession' : profession,
      'pays' : pays,
      'ville' : ville,
      'bio' : bio,
    };
  }
}
