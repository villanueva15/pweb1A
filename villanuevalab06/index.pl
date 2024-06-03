#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $q = CGI->new;
print $q->header('text/html;charset=UTF-8');

my @lines = getData("licenciamiento.csv");
print STDERR @lines;

my @periods = getPeriods(@lines);
print STDERR "Periods: @periods\n";

my $HTMLoptions = renderSelect(@periods);
print STDERR $HTMLoptions;

my $body = renderBody($HTMLoptions);
print STDERR $body;

print renderHTMLpage('Consulta Estado Licenciamiento','css/mystyle.css',$body);

sub getData{
  my $fn = $_[0];
  open(IN, $fn) or die $!;
  my @lines = <IN>;
  close(IN);
  return @lines;
}

sub getPeriods{
  my @lines = @_;

  my $regExp = getRegExp('|', 10);
  print STDERR "REGEXP: $regExp\n";
  my %periods = ();
  foreach my $line (@lines){
    if($line =~ /$regExp/){
      my $period = $5;
      if($period =~ /[0-9]+/){
        $periods{$period} = undef;
      }
    }
  }
  return sort (keys %periods);
}
sub getRegExp{
  my $separator = $_[0];
  my $len = $_[1];

  my $regExp = "^";
  my $group = "([^$separator]+)";

  for(my $i = 1; $i < $len; $i++){
    $regExp .= $group."\\".$separator;
  }
  $regExp .= $group; #Last group doesn't have a separtor at the end.

  return $regExp;
}

sub renderSelect{
  my @lines = @_;

  my $options = "";
  foreach my $line (@lines){
    $options .= "      <option value='$line'>$line</option>\n";
  }
  return $options;
}

sub renderHTMLpage{
  my $title = $_[0];
  my $css = $_[1];
  my $body = $_[2];

  my $html = <<"HTML";
<!DOCTYPE html>
<html lang="es">
  <head>
    <title>$title</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="$css">
  </head>

  <body>
$body
  </body>
</html>
HTML
  return $html;
}

sub renderBody{
  my $HTMLoptions = @_[0];

  my $body = <<"BODY";
    <h1>Universidades licenciadas una determinada cantidad de años</h1>
    <form action='queryByYear.pl' method='GET'>
    <label for="years">Años de licenciamiento:</label>
    <select name='years' id='years'>
$HTMLoptions
    </select>
    <input type='submit' value='Consultar Nombres de Universidades'>
    </form>
BODY
  return $body;
}
