#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $q = CGI->new;
my $years = $q->param('years');
print $q->header('text/html');

open(IN, "licenciamiento.csv") or die ("Error al abrir el archivo");
my @arr = <IN>;
close(IN);

my $size = leerEncabezado();
my $pattern = RegExp($size);

my %unis = ();

foreach my $linea(@arr){
  if($linea =~ /$pattern/){
    my $universidad = $2;
    my $periodo = $5;
    if($periodo eq $years){
      $unis{$universidad}="";
    }
  }
}
foreach my $unive (%unis){
print<<HTML;
<!DOCTYPE html>
<html lang="es">
  <head>
    <title>SUNEDU</title>
      <link href = "css/mystyle.css" rel="stylesheet">
  </head>
  <body>
      <table>
      <caption>SUNEDU</caption>
      <tr>
        <th>Nombre de universidad</th>
      </tr>
      <tr>
        <td>$unive</td>
      </tr>
      </table>
  </body>
HTML
}
sub leerEncabezado{
  my $line = $arr[0];
  my $cont = 1;

  while($line =~ /^([^\|]+)\|(.+)/){
    cont++;
    $line = $2;
  }
  return $cont;
}

sub RegExp{
  my $num = $_[0];
  my $s = "^";
  for(my $i = 1; $i < $num; $i++){
    $s .= '([^\|]+)\|';
  }
  $s .= '([^\|]+)';
  return $s;
}
