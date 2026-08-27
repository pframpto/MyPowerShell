break;
# Create self signed certificate for SQL
New-SelfSignedCertificate -DnsName SQL-NUG -CertStoreLocation Cert:\LocalMachine\My -FriendlyName SQLConnections -KeySpec  KeyExchange