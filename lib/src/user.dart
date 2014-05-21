part of cogito;

class User {
    /// Email validation according to WHATWGs HTML5 type="email" standard.
    final EMAIL_REGEX = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");

    String email = '';
    String password = '';
    String hash = '';

    String _id;

    String get id => _id;

    /// True if email matches EMAIL_REGEX
    bool get emailIsValid => EMAIL_REGEX.hasMatch(email);
    /// True if password have a length of at least 5
    bool get passwordIsValid => password.length > 4;
    /// True if hash have a length of exactly 64
    bool get hashIsValid => hash.length == 64;

    User();

    User.fromJson(Map json) {
        email = json['email'];
        hash = json['hash'];
    }

    Map toJson() => {
        'email': email,
        'hash': hash,
    };

    /**
     * Calculates a hash from the password with the email as salt and clears the password.
     */
    void calculateHash() {
        var sha256 = new SHA256()
            ..add(password.codeUnits)
            ..add(email.codeUnits);
        hash = CryptoUtils.bytesToHex(sha256.close());
        password = '';
    }

    /**
     * Calculates a key by hashing the stored hash with the email as salt.
     */
    String getKey(Map dbObject) {
        var sha256 = new SHA256()
            ..add(dbObject['hash'].codeUnits)
            ..add(email.codeUnits);
        return CryptoUtils.bytesToHex(sha256.close());
    }

    /**
     * Strengthens the hash by hashing it using [DBCrypt][].
     *
     * [DBCrypt]: http://pub.dartlang.org/packages/dbcrypt
     */
    void strengthenHash() {
        hash = new DBCrypt().hashpw(hash, new DBCrypt().gensalt());
    }

    /**
     * Verifies the stored hash against the provide using [DBCrypt][].
     *
     * [DBCrypt]: http://pub.dartlang.org/packages/dbcrypt
     */
    bool verifyHash(Map dbObject) => new DBCrypt().checkpw(hash, dbObject['hash']);
}
