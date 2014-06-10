#
# Cryptonote Server
# dev@mindbin.io
#

package db;

use DBI;

sub new
{
    my $class = shift;
    
    my $self = {
            class => $class,
            dbh => undef
    };
    
    bless $self, $class;

    return $self;
}

sub connect {
    my ($self, $config) = @_;
    
    $self->{dbh} = DBI->connect("DBI:mysql:database=".$config->{database}.";host=".$config->{host}.";port=".$config->{port}, $config->{username}, $config->{password}) or return &handle_error("Cannot open database ".$config->{database}.". $DBI::errstr");
    
    return $self->{dbh};
}

sub disconnect
{
    my ($self) = @_;
    
    $self->{dbh}->disconnect or &handle_error("Error on disconnect. $DBI::errstr");
}

sub select_row_hashref
{
    my ($self, $sql) = @_;
    
    my $sth=$self->{dbh}->prepare($sql) or &handle_error ("SQL statement failed: $sql; ERROR DESCRIPTION: $DBI::errstr");
    $sth->execute() or &handle_error ("SQL statement failed: $sql; ERROR DESCRIPTION: $DBI::errstr");
    my $row=$sth->fetchrow_hashref();
    return $row;
}

sub select_rows
{
    my ($self, $sql) = @_;
    
    my $sth=$self->{dbh}->prepare($sql) or &handle_error ("prepare failed: $sql; ERROR DESCRIPTION: $DBI::errstr");
    $sth->execute() or &handle_error("execute failed: $sql; ERROR DESCRIPTION: $DBI::errstr");
    return $sth;
}

sub select_row
{
    my ($self, $sql) = @_;
    my @row=$self->{dbh}->selectrow_array($sql);
    &handle_error("SQL statement failed: $sql; ERROR DESCRIPTION: $DBI::errstr") if $DBI::errstr;
    
    return @row;
}

sub do
{
    my ($self, $sql) = @_;
    
    $self->{dbh}->do($sql) or &handle_error("SQL statement failed: $sql; ERROR DESCRIPTION: $DBI::errstr");
}

sub quote
{
	my ($self, $in)=@_;
	my $out = $self->{dbh}->quote($in);
	return $out;
}

sub handle_error
{
    my ($message) = @_;
    
    die($message);
    
    return 0;
}

1;