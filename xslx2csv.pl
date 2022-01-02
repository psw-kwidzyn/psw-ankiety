#!/usr/bin/perl
# Wykorzystanie perl xslx2csv.pl plik.xslx [numer-arkusza]

use Spreadsheet::ParseXLSX;
#
use locale;
use utf8;
binmode(STDOUT, ":utf8");
##use open ":encoding(utf8)";
use open IN => ":encoding(utf8)", OUT => ":utf8";
#
my %HDR = (
'NazwiskoiImię' => 'nazwisko',
'Datawprowadzeniaankiety' => 'data',
'Dotyczy' => 'dotyczy',
'Płeć' => 'plec',
'JakPan/Panioceniaofertęprzedmiotów(zakresitreść)' => 'ofertaPrzedmiotow',
'JakPan/Panioceniaofertęspecjalności(zakres)' => 'ofertaSpecjalnosci',
'JakPan/Panioceniaofertęprzedmiotówfakultatywnych(zakresitreść)' =>  'ofertaPrzemiotowFakultat',
'JakPan/Panioceniadostępnośćiprzejrzystościinformacjidotyczącychprogramówstudiówisprawdydaktycznych' => 'dostepnoscProgramow',
'JakPan/Panioceniadostępnośćinformacjidotyczącejregulaminów(studiów,pomocymaterialnej,innych),programówkształcenia,wymagańegzaminacyjnychorazzasadpobieraniaopłat' => 'dostepnoscRegulaminow',
'JakPan/Panioceniaofertęnaukijęzykówobcych(zakresistopieńzaawansowania)' => 'ofertaJezyki',
'JakPan/PanioceniaofertęstudiówzagranicąwramachprogramuErasmus' => 'ofertaErasmus',
'JakPan/Panioceniaogólnewarunkówlokalowe' => 'ofertWarunkiLokalowe',
'JakPan/Panioceniawyposażeniasalwspomagającychproceskształcenia(audiowizualne,tabliceitp.)' => 'wyposażenieSal',
'JakPan/Panioceniabazękomputerową' => 'bazaKomputerowa',
'JakPan/Paniocenialiczebnościgrupstudenckichwaktywnychformachzajęć(ćwiczenia/laboratoria)' => 'liczebnoscGrup',
'JakPan/Panioceniaracjonalnośćiorganizacjęrozkładuzajęć' => 'rozkladZajec',
'JakPan/Panioceniadostępdowypożyczalni/czytelniidostępnychwniejzbiorów' => 'biblioteka',
'JakPan/Panioceniasprecyzowaniewymagańdotyczącychwykonywanychzadańizaliczaniaumiejętnościpodczaskształceniapraktycznego' => 'ksztalceniePraktyczneWymagania',
'JakPan/Panioceniaorganizacjękształceniapraktycznego(dobórplacówek,kadry)' => 'ksztalceniePraktyczneOrganizacja',
'JakPan/Panioceniazbieżnośćczynnościwykonywanychpodczaskształceniapraktycznegozprogramemwymaganychumiejętnościzawodowych' => 'ksztalceniePraktyczneZbieznosc',
'JakPan/Panioceniadostępnośćdziekanatu' => 'dziekanatDostep',
'JakPan/Panioceniażyczliwości/otwartość/chęćpomocypracownikówdziekanatu' => 'dziekanatZOP',
'JakPan/Panioceniapracędziekanatupodwzględemterminowościzałatwianiaspraw/kompetencji' => 'dziekanatTK',
'JakjestPana/Panioceniafunkcjonalnośće-dziekanatu' => 'edziekanatFunkcjonalnosc',
'JakPan/Panioceniapracęe-dziekanatupodwzględemterminowościzałatwianiaspraw' => 'edziekanatTerminowosc',
'Proszęokreślićczegobrakuje/cobynależałbyusprawnićwpracye-dziekanatu:' => 'edziekanatKomentarz',
'JakjestPana/Paniocenaestetykiuczelnianejstronyinternetowej' => 'wwwEstetyka',
'JakjestPana/Paniocenafunkcjonalnościuczelnianejstronyinternetowejorazaktualności/kompletnościinsformacjinatejstronie' => 'wwwFunkcjonalosc',
'Proszęokreślićczegobrakuje/cobynależałopoprawićnauczelnianejstronieinternetowej:' => 'wwwKomentarz',
'JakPan/Panioceniadostępnośćkwestury' => 'kwesturaDostep',
'JakPan/Panioceniażyczliwości/otwartość/chęćpomocypracownikówkwestury' => 'kwesturaZOP',
'JakPan/Panioceniapracękwesturypodwzględemterminowościzałatwianiaspraw/kompetencji' => 'kwesturaTK',
'JakPan/Panioceniadostępnośćpunktuinformacyjnego' => 'infopunktDostep',
'JakPan/Panioceniażyczliwości/otwartość/chęćpomocypracownikówpunktuinformacyjnego' => 'infopunktZOP',
'JakPan/Panioceniapracępunktuinformacyjnegopodwzględemkompetencji' => 'infopunktKompetencje',
'JakPan/PanioceniadziałalnośćUczelnianejKomisjiStypendialnej' => 'UKS',
'JakPan/PanioceniadziałalnośćSamorząduStudenckiego' => 'SS',
'JakPan/PanioceniadziałalnośćStudenckichKółNaukowych' => 'SKN',
'Płeć' => 'plec2',
'Miejscezamieszkania(gmina)' => 'gmina',
'Rokstudiów' => 'rok',
'Trybstudiów' => 'tryb',
'Kierunekstudiów' => 'kierunek',
'BrałemudziałwprogramieErasmus' => 'aktywnoscErasmus',
'BrałemudziałwaktywnościSamorząduStudenckiego/kółnaukowychlubimprezachorganizowanychprzezSamorządStudencki(juwenalia/otrzęsiny)' => 'aktywnosc',
'Uwagi' => 'uwagi',
'Uwaginatematankiety' => 'uwagiAnkieta', );

$xslxfile = $ARGV[0]; 
$ArkuszNo = $ARGV[1] || 1; ## domyślnie arkuszu 1

my $source_excel = new Spreadsheet::ParseXLSX;
my $source_book = $source_excel->parse("$xslxfile")
  or die "Could not open source Excel file $xslxfile: $!";

# Zapisuje zawartość wybranego arkusza do hasza %csv
my %csv = ();

foreach my $sheet_number (0 .. $source_book->{SheetCount}-1) {
  my $sheet = $source_book->{Worksheet}[$sheet_number];

  print STDERR "*** SHEET:", $sheet->{Name}, "/", $sheet_number, "\n";
  if ( $ArkuszNo ==  $sheet_number + 1 ) {

    next unless defined $sheet->{MaxRow};
    next unless $sheet->{MinRow} <= $sheet->{MaxRow};
    next unless defined $sheet->{MaxCol};
    next unless $sheet->{MinCol} <= $sheet->{MaxCol};

    $rowNo = 0;
    foreach my $row_index ($sheet->{MinRow} .. $sheet->{MaxRow}) {
       foreach my $col_index ($sheet->{MinCol} .. $sheet->{MaxCol}) {
          my $source_cell = $sheet->{Cells}[$row_index][$col_index];
	  if ($source_cell) {
	    ##$csv{$row_index}{$col_index} = $source_cell->Value;
	    $cVal = $source_cell->Value;
            $cVal =~ s/\n/ /g;
            $cVal =~ s/^[ \t]|[ \t]$//g; ## usuń wiodące/kończące odstępy
            ## ### ###
	    if ($cVal eq "Bardzo Dobrze" || $q eq "zdecydowanie się zgadzam" ) { $cVal = "5"}
            elsif ($cVal eq "Dobrze" || $q eq "zgadzam się" ) { $cVal = "4"}
            elsif ($cVal eq "Nie mam zdania/Nie wiem" || $q eq "nie mam zdania" ) { $cVal = "3"}
            elsif ($cVal eq "Źle" || $q eq "nie zgadzam się" ) { $cVal = "2"}
            elsif ($cVal eq "Bardzo Źle" || $q eq "zdecydowanie się nie zgadzam" ) { $cVal = "1"}
            ## ### ###
            if ($rowNo == 0 ) {## header 
                $cVal =~ s/[ \t]+//g;
                ##
                $cVal = $HDR{$cVal};
            }
            print "$cVal";
	  }
          unless($col == $sheet -> {MaxCol}) {print ";";}
       }
       unless( $row == $sheet -> {MaxRow}){print "\n";}
       $rowNo++;
    }
  }
}
###
