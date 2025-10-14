# Age

Age is a modern alternative to gnu pgp. Use it to encrypt/decrypt files with a passphrase or a key pair.

In this repository, only the private `age` key is encrypted with a long, random passphrase. All other secret files are encrypted with the public key.

There is a script in the user's `bin` directory that handles the decryption of the `age` key with the given passphrase and then decrypts all other secret files (listed there) with the already decrypted private key. You should include that script in the `just` command used for deployment so that decryption happens automatically.

## If you ever need to change age keys

1. Create a new key pair:

   `age-keygen -o key.txt`

   The public key is always used for encryption and the private key for decryption.

2. Encrypt it with a passphrase:

   `age --armor --passphrase -o key.txt.age key.txt`

   Use a long and random passphrase that you can remember!

3. Replace the old encrypted key with the new one in this repository.

4. Re-encrypt secret files with new age key.

   Now that you have a new key you must re-encrypt all secret files with it.

   If you have access to the decrypted versions of those files you can re-use them, if you don't you will need to create new secret files and update related services. For example, if you can't decrypt your private ssh key you would need to create a new one and also update Github.

   To encrypt files use:

   `age --armor -r <public-key> -o <filename>.age <filename>`

   The `<public-key>` is commented out in the `key.txt` file.

   Make sure you use the same name of the file you are replacing.

5. Replace old encrypted files with the new ones.
