library hash_tests;

import 'package:unittest/unittest.dart' hide expect;
import 'package:guinness/guinness.dart';
import 'package:cogito/cogito.dart';

main() {
    unittestConfiguration.timeout = new Duration(seconds: 3);

    describe('User', () {

        it('should initalize with zero length strings', () {
            var user = new User();

            expect(user.email).toEqual('');
            expect(user.password).toEqual('');
            expect(user.hash).toEqual('');
        });

        it('should initalize with invalid data', () {
            var user = new User();

            expect(user.emailIsValid).toEqual(false);
            expect(user.passwordIsValid).toEqual(false);
            expect(user.hashIsValid).toEqual(false);
        });

        it('should accept valid emails', () {
            var emails = [
                'name@domain.com',
                'name@domain',
                'name+alias@domain.com',
            ];

            emails.forEach(expectAsync((email) {
                var user = new User()
                    ..email = email;

                expect(user.emailIsValid).toEqual(true);
            }, count: emails.length));
        });

        it('should not accept invalid emails', () {
            var emails = [
                '@domain',
                'name@'
                '',
                '@',
                'name@.com',
                'name@domain@domain.com'
            ];

            emails.forEach(expectAsync((email) {
                var user = new User()
                    ..email = email;

                expect(user.emailIsValid).toEqual(false);
            }, count: emails.length));
        });

        it('should accept passwords with atleas 5 chars', () {
            var passwords = [
                '12345',
                'sdfsdfsdgsdfgsdfg',
                'AD_FDSAFK_ÖSD=Fi9F9=?)uiZ=Ijf)Zyczixuchzxuixct8/)=XZC&=XZy'
            ];

            passwords.forEach(expectAsync((password) {
                var user = new User()
                    ..password = password;

                expect(user.passwordIsValid).toEqual(true);
            }, count: passwords.length));
        });

        it('should accept passwords with under 5 chars', () {
            var passwords = [
                '1234',
                '',
                '=XZy'
            ];

            passwords.forEach(expectAsync((password) {
                var user = new User()
                    ..password = password;

                expect(user.passwordIsValid).toEqual(false);
            }, count: passwords.length));
        });

        it('should accept SHA256 hashes', () {
            var hashes = [
                '3e624bee6f82b83206b7bfa02a4176d9f6c86141456d63d4f6a723428c19c2d8',
                '15c73b80fdd9c52ed463c4795ed169e96236f3a41921a2f8b24b3ac15bc282ca',
                'cc60da0f62d60b34207af78157038871b052bdd5183a445df7f4b56404f95e72'
            ];

            hashes.forEach(expectAsync((hash) {
                var user = new User()
                    ..hash = hash;

                expect(user.hashIsValid).toEqual(true);
            }, count: hashes.length));
        });

        it('should not accept invalid SHA256 hashes', () {
            var hashes = [
                '3e624bee6f82b83206b7bfa02a4176d9f6c86141456d63d4f6a723428c19c2d',
                '15c73b80fdd9c52ed463c4795ed169e96236f3a41921a2f8b24b3ac15bc282caa',
                ''
            ];

            hashes.forEach(expectAsync((hash) {
                var user = new User()
                    ..hash = hash;

                expect(user.hashIsValid).toEqual(false);
            }, count: hashes.length));
        });

        it('should validate Emails using the WHATWG email regex', () {
            var user = new User();

            expect(user.EMAIL_REGEX.pattern)
                .toEqual(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
        });

        it('should parse from Json correctly', () {
            var user = new User.fromJson({
                'email': 'test@example.com',
                'hash': '3e624bee6f82b83206b7bfa02a4176d9f6c86141456d63d4f6a723428c19c2d8'
            });

            expect(user.email).toEqual('test@example.com');
            expect(user.password).toEqual('');
            expect(user.hash).toEqual('3e624bee6f82b83206b7bfa02a4176d9f6c86141456d63d4f6a723428c19c2d8');
        });

        it('should encode to Json correctly', () {
            var user = new User()
                ..email = 'test@example.com'
                ..password = 'abc'
                ..hash = '3e624bee6f82b83206b7bfa02a4176d9f6c86141456d63d4f6a723428c19c2d8';

            expect(user.toJson()).toEqual({
                'email': 'test@example.com',
                'hash': '3e624bee6f82b83206b7bfa02a4176d9f6c86141456d63d4f6a723428c19c2d8'
            });
        });

        it('should hash a password correctly', () {
            var user1 = new User()
                ..email = 'test@example.com'
                ..password = 'abc'
                ..calculateHash();
            var user2 = new User()
                ..email = 'test2@example.com'
                ..password = 'abc'
                ..calculateHash();
            var user3 = new User()
                ..email = 'test@example.com'
                ..password = 'cba'
                ..calculateHash();
            var user4 = new User()
                ..email = 'test2@example.com'
                ..password = 'cba'
                ..calculateHash();

            expect(user1.hash).toEqual('3e624bee6f82b83206b7bfa02a4176d9f6c86141456d63d4f6a723428c19c2d8');
            expect(user2.hash).toEqual('15c73b80fdd9c52ed463c4795ed169e96236f3a41921a2f8b24b3ac15bc282ca');
            expect(user3.hash).toEqual('cc60da0f62d60b34207af78157038871b052bdd5183a445df7f4b56404f95e72');
            expect(user4.hash).toEqual('0865206363111d9980b2c898158b1999388f4a9cb5886084c68270ebd1f64058');
        });

        it('should clear the password after hashing', () {
            var user = new User()
                ..email = 'test2@example.com'
                ..password = 'abc'
                ..calculateHash();

            expect(user.password).toEqual('');
        });

        it('should strengthen hash', () {
            var user = new User()
                ..email = ''
                ..password = 'abc'
                ..calculateHash()
                ..strengthenHash();

            expect(user.hash).not.toEqual('ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad');
            expect(user.hash.startsWith(r'$2a$10')).toEqual(true);
        });

        it('should verify strengthened hash correctly', () {
            var registeredUser = new User()
                ..email = 'test@example.com'
                ..password = 'abc'
                ..calculateHash()
                ..strengthenHash();
            var loginUser = new User()
                ..email = 'test@example.com'
                ..password = 'abc'
                ..calculateHash();

            expect(loginUser.verifyHash({'hash': registeredUser.hash})).toEqual(true);
        });

        it('should fail to verify strengthened hash if not equal', () {
            var registeredUser = new User()
                ..email = 'test@example.com'
                ..password = 'abc'
                ..calculateHash()
                ..strengthenHash();
            var loginUser = new User()
                ..email = 'test@example.com'
                ..password = 'cba'
                ..calculateHash();

            var registeredUser2 = new User()
                ..email = 'test@example.com'
                ..password = 'abc'
                ..calculateHash()
                ..strengthenHash();
            var loginUser2 = new User()
                ..email = 'test@example.com'
                ..password = 'cba'
                ..calculateHash();

            expect(loginUser.verifyHash({'hash': registeredUser.hash})).toEqual(false);
            expect(loginUser2.verifyHash({'hash': registeredUser2.hash})).toEqual(false);
        });

        it('should calculate an API key correctly', () {
            var dbObject = {'hash': r'$2a$10$pfAujv4OEoL.nsLaON8eb.v.MoYgCoXNmu07qiIdMi71JnPXGVUfm'};
            var user1 = new User()
                ..email = 'test@example.com';
            var user2 = new User()
                ..email = 'test2@example.com';

            expect(user1.getKey(dbObject)).toEqual('902585ce09168f13c6bdd1771168be9444e490418b4626b95a6ac3e2d4a1b12f');
            expect(user2.getKey(dbObject)).toEqual('9de73e0a58f3898930c3045e023397773d7a547e2119d737bf96c2b770ddc12e');
        });
    });
}
