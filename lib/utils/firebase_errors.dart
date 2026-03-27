class FirebaseErrors {
  static String mapMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return "El formato del correo electrónico es inválido.";
      case 'weak-password':
        return "La contraseña es muy débil. Debe tener al menos 6 caracteres.";
      case 'email-already-in-use':
        return "Ya existe una cuenta registrada con este correo.";
      case 'network-request-failed':
        return "Error de red. Verifica tu conexión a internet.";
      case 'user-disabled':
        return "Esta cuenta de usuario ha sido inhabilitada.";
      case 'too-many-requests':
        return "Demasiados intentos fallidos. Inténtalo de nuevo más tarde.";
      case 'operation-not-allowed':
        return "El registro con correo y contraseña no está habilitado en Firebase.";
      case 'invalid-credential':
        return "Usuario no existe o credenciales incorrectas.";
      // Error por defecto
      default:
        return "Error de Firebase ($code): Inténtelo de nuevo.";
    }
  }
}
