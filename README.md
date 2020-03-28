# dc3dd-blockchain-wrapper
A wrapper for the dc3dd to send hashes of the file to a block chain

This wrapper was inspired from the [CASE-CLI-WRAPPER](https://github.com/casework/CASE-CLI-Wrapper) proof of concept.

In particular, the `wrapper.sh` was modified from this repository.

Developped with Python 3.6.9 and Ubuntu 18.04.3 LTS.

Usage:
    `./wrapper.sh command [arguments...]`

For now, it supports dc3dd:
    `./wrapper.sh dc3dd if=source_file of=output_file`


