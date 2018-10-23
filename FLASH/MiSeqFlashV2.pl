#! /usr/bin/perl -w
use strict;
use warnings;
#FASTER AND STRONGER
#flash ../RawData/AD006_GCCAAT_Trim_25_50_R1.fq ../RawData/AD006_GCCAAT_Trim_25_50_R2.fq -m 10 -M 150 -x 0 -p 33 -o test-1 -r 130 -f 195 -s 20
#perl MiSeqFlash.pl FlashMerge.fq Barcode IndexLength tag
#perl /home/illumina/Perl/MiSeqFlash.pl [0]/home/illumina/Perl/Barcode/new [1]7 [2]LM_PE400.merged.fastq 
if(!defined($ARGV[2])){
	die "	please do like this :
		perl /home/illumina/Perl/MiSeqFlashV2.pl /home/illumina/Perl/Barcode/new 7 LM_PE400.merged.fastq\n";
}

my(@mid, $i, $j, %hash,);
my($line1, $seq1, $seq1_reverse, $qname1, $qual1);
my($index, $reads, $IndexLength);
my $ID = 0;
my $key = 0;
$IndexLength = $ARGV[1];

#input Index File
open(HEHE,"<$ARGV[0]") or die $!;
while(<HEHE>){
	$_ =~ s/[\r\n]+//g;
	push @mid, [$_];#assiment the barcode to mid
	$hash{$_} = 0; #assiment the the $hash{$_} = 0
	if(length($_) ne $IndexLength){
		die "/////////////\n";
	}
	if($_ =~ /[\s\t]/){
		die "/////////////\n";
	}
}
close HEHE;

#input fastq file generated from Flash Merge
open(HEHE,"gzip -dc <$ARGV[2]|") or die $!;
while(1){
	$line1 = <HEHE>; if(!defined($line1)){last;}; chomp ($line1);
    $seq1  = <HEHE>; chomp ($seq1);
	$seq1_reverse = $seq1;
	$seq1_reverse = reverse($seq1_reverse);
	$seq1_reverse =~ tr/ATGCatcg/TACGtagc/;
    $qname1= <HEHE>; chomp ($qname1);
    $qual1 = <HEHE>; chomp ($qual1);
	
	#Forward analysis
	$key = 0;
	if($key == 0){
		$index = substr($seq1, 0, $IndexLength);
		$reads = substr($seq1, $IndexLength, length($seq1)-$IndexLength);
		if(defined($hash{$index})){
			$key ++;
			$hash{$index} ++;
		}
	}
	
	#Reverse Analysis
	if($key == 0){
		$seq1_reverse = $seq1;
		$seq1_reverse = reverse($seq1_reverse);
		$seq1_reverse =~ tr/ATGCatcg/TACGtagc/;
		$index = substr($seq1_reverse, 0, $IndexLength);
		$reads = substr($seq1_reverse, $IndexLength, length($seq1_reverse)-$IndexLength);
		if(defined($hash{$index})){
			$key ++;
			$hash{$index} ++;
		}
	}	
}
close HEHE;

#to be continue..
foreach my $i(0 .. $#mid){
	if($hash{$mid[$i][0]} >= 1000){
		$j = $i + 1;
}
  else {
  	next;
  }
  print "F".$j."\t".$mid[$i][0]."\t".$hash{$mid[$i][0]}."\n"; 
}

