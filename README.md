CryptonotePerlServer
====================

Perl server for Cryptonote synchronization.

You need a server supporting MySQL and Perl.
Then edit config.pm to match your settings.
If you serve it outside of cgi-bin you should disable access to config.pm with .htaccess or in your server configuration, else it will be readable.

Modules needed by Perl:
 - Digest::SHA3
 - JSON::XS