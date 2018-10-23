#! #!/usr/bin/perl;
use strict;
use basename;

if (!(@ARGV == 1)){
    die "you can use this script like this:
    perl MiseqSummaryCombine miseq18152";
}
my $runNumber = $ARGV[0];
my $sourceFile = "/datum/NextDatafile";
my $outPutfile = "/home/illumina/Perl/MiseqConfige";
my(@list,@mid,@dir);
opendir(DR,"$sourceFile") | die "can't open the sourcefile";
@list = glob "$sourceFile/*/*/$runNumber/*/*.summary";
closedir;
chdir $sourceFile | die "can't cd the file\n";
my $destFile = $outputFile . "/" . $runNumber.".summaryCombine";
open(OR,">$destFile")
foreach my $sample($list){
    open(SR,"$sample") | die "can't open the $_";
    @mid = <SR>;
    while (@mid){
     print OR $mid[1] . "\n";
  }
close;
}
close;
