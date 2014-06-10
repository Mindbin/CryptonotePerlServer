#!/usr/bin/perl
#
# Cryptonote Server
# dev@mindbin.io
#

use CGI;
use Switch;
use Digest::SHA3 qw(sha3_256_hex sha3_512_hex);
use JSON::XS;
use config;
use db;

################################

my $query = new CGI;
my $dbh = new db(); $dbh->connect(config::database());

my $ip = sha3_256_hex($ENV{'REMOTE_ADDR'});
my $action = $query->param('action');
my $id = $query->param('id');
my $login = $query->param('login');
my $data = $query->param('data');
my $res = {};

################################

print "Access-Control-Allow-Origin: *\n";
print "Content-type: text/html\n\n";
if (length($id) == 128 && length($login) == 64) {
    switch ($action) {
        case "get" {
            my ($note) = $dbh->select_row_hashref("SELECT * FROM noteData WHERE id=".$dbh->quote($id)." AND login=".$dbh->quote($login));
            if ($note) {
                $res = {
                    status => 1,
                    message => "Found",
                    data => $note->{data}
                };
            } else {
                $res = {
                    status => 0,
                    message => "Not Found"
                };
            }
        }
        case "save" {
            my ($note) = $dbh->select_row_hashref("SELECT * FROM noteData WHERE id=".$dbh->quote($id)." AND login=".$dbh->quote($login));
            if ($note) {
                $dbh->do("UPDATE noteData SET data=".$dbh->quote($data).", ip=".$dbh->quote($ip)." WHERE login=".$dbh->quote($login)." AND id=".$dbh->quote($id));
                $res = {
                    status => 1,
                    message => "Updated Existing"
                };
            } else {
                my ($count) = $dbh->select_row("SELECT COUNT(*) FROM noteData WHERE ip='$ip'");
                if ($count>=config::maximumUsersPerIP()) {
                    $res = {
                        status => 0,
                        message => "Maximum amount of notes has been reached."
                    };
                } else {
                    $dbh->do("INSERT INTO noteData SET data=".$dbh->quote($data).", ip=".$dbh->quote($ip).", login=".$dbh->quote($login).", id=".$dbh->quote($id));
                    $res = {
                        status => 1,
                        message => "Created New"
                    };
                }
            }
        }
        case "rename" {
            my $newID = $query->param('newid');
            if (length($newID) == 128) {
                my ($note) = $dbh->select_row_hashref("SELECT * FROM noteData WHERE id=".$dbh->quote($id)." AND login=".$dbh->quote($login));
                if ($note) {
                    $dbh->do("UPDATE noteData SET id=".$dbh->quote($newID)." WHERE login=".$dbh->quote($login)." AND id=".$dbh->quote($id));
                    $res = {
                        status => 1,
                        message => "Renamed"
                    };
                } else {
                    $res = {
                        status => 0,
                        message => "Not Found"
                    };
                }
            } else {
                $res = {
                    status => 0,
                    message => "Invalid Request"
                };
            }
        }
        else {
            $res = {
                status => 0,
                message => "Invalid Request"
            };
        }
    }
} else {
    switch ($action) {
        case "ver" {
            $res = {
                status => 1,
                name => "Cryptonote",
                lang => "Perl",
                version => "0.1",
            };
        }
        else {
            $res = {
                status => 0,
                message => "Invalid request"
            };
        }
    }    
}
print encode_json($res);

################################

$dbh->disconnect();
exit 0;

################################