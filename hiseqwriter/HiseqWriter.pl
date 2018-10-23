#! /usr/bin/perl -w
use strict;
use warnings;
use File::Basename;
#use this just like perl HiseqWriter.pl LM806312-1.map.txt
if (!defined($ARGV[0])) {
    die"just input the right file. "
}
my $map = $ARGV[0];
my($sourdir,$datatype,$inputdir,$outputdir,@list,$samplename,$file,$output1);
$file = glob "/datum/NextSeqDataFilter/*/*/*/*/$map";
$sourdir = dirname($file);
$datatype = "PE400";
$inputdir = $sourdir . "/1_RawData";
$outputdir = $sourdir . "/2_CleanData";
system("mkdir -p $inputdir");
system("mkdir -p $outputdir");
open (INPUT, $map) or die $!;
while(<INPUT>){
    $_ =~s/[\r\n]+//g;
    my @temp = split /\t/;
    @list = $temp[0];
    $output1 = $sourdir . "/" . $temp[0] . '.sh';
    open(OUT, ">$output1") || die "could not creat file";
    for my $samplename(@list){
    my $filname1 = $inputdir . "/" . $samplename . "_R1.fq.gz";
    my $filname2 = $inputdir . "/" . $samplename . "_R2.fq.gz";
    print OUT "perl /home/illumina/Perl/MiSeqQualityV2.0.pl $samplename $datatype $filname1 $filname2 $outputdir";
    }
    close(OUT);
}
close(INPUT);