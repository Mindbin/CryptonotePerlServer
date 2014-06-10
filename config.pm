#
# Cryptonote Server
# dev@mindbin.io
#

package config;

# DATABASE SETTINGS
sub database
{   
    return {
        host => "localhost",
        port => "3306",
        database => "",
        username => "",
        password => ""
    };
}

# MAXIMUM NUMBER OF USERS PER IP
sub maximumUsersPerIP {
    return 20;
}

1;
