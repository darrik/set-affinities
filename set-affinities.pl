#!/usr/bin/env perl -w
# set-affinities.pl --- Set CPU affinity on a list of programs
#
# Time-stamp: <2013-07-28 05:26:21>
use Win32::Process::List;
use Sys::CpuAffinity;
use strict;

my %programs =
  (                                   # CPU cores (with HT)
   "firefox.exe"   => 0b000011110000, # 3,4
   "chrome.exe"    => 0b000011110000, # 3,4
   "chromium.exe"  => 0b000011110000, # 3,4
   "opera.exe"     => 0b000011110000, # 3,4
   "Duplicati.exe" => 0b111100000000, # 5,6
   "Dropbox.exe"   => 0b111100000000, # 5,6
   "rsync.exe"     => 0b111100000000, # 5,6
  );

my $P = Win32::Process::List->new();
my %list = $P->GetProcesses();
foreach my $key (keys %list) {
  while (my ($prog, $mask) = each %programs) {
    if($prog eq $list{$key}) {
      my $origmask = Sys::CpuAffinity::getAffinity($key);

      if($mask != $origmask) {
        my $ret = Sys::CpuAffinity::setAffinity($key, $mask);
        if ($ret != 1) {
          print "ERROR: Could not set affinity of $key ($list{$key}): $!\n";
        }
      }
    }
  }
}

