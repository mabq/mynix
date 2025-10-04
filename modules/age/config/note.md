# Note

If you ever need to change your age key:

1. Create a new key:

   `age-keygen -o key.txt`

2. Encrypt it with a passphrase:

   `age --armor --passphrase -o key.txt.age key.txt`

   Use a long and random passphrase that you can remember!

3. Replace the old encrypted key with the new one in this repository.

   Now that you have a new key you must re-encrypt all secret files with it.

   If you have access to the decrypted versions of those files you can re-use them, if you don't you will need to create new secret files and update related services, e.g. if you need to change the ssh key you would also need to update Github.

4. Re-encrypt secret files with new age key.

   `age --armor -r <public-key> -o <filename>.age <filename>`

   The `<public-key>` is commented out in the `key.txt` file.

   Make sure you use the same name of the file you are replacing.

5. Replace old encrypted files with the new ones.
