#!/usr/bin/perl
my $ykTool = `which ykinfo`;
if ($ykTool = "") { die("no ykinfo! brew install ykpersonalize"); }

my $yubiTestCmd = "ykinfo -s 2>&1";
my $error = 'core error';
my $ok = "serial: ";
my $yubiConf = "~/.yubiSerial";

while ($myYubi == "") {
if (`cat $yubiConf 2>/dev/null` != "") { 
 $myYubi = `cat $yubiConf`; 
 print "Found yubiKey-serial $myYubi\n";
}
else { 
 my $test = `$yubiTestCmd`;
 chomp($test);
 print "Got [$test]\n";
 if ($test =~ m/$ok/) { 
  print "It was a serial number";
  my @yubiInfo = split (": ", $test); 
  print "I think the serial might be [$yubiInfo[1]]\n"; 
  if ($yubiInfo[1] =~ /^[0-9]+$/) {
  print "Writing the info $yubiInfo[1] to $yubiConf\n"; 
  `echo "$yubiInfo[1]" > $yubiConf`; 
  }
 }
else {
 print "Make sure you have a yubiKey connected for memorizing the serial number! (sleeping 5 secs before retry)\n";
 sleep 5;
} 

}
} 

$away = 0;

while (1) {


if ($away == 0) {
$yubiTest = `$yubiTestCmd`;
if ($yubiTest =~ m/$myYubi/) { 

}
else {
 if ($yubiTest =~ m/$error/) { 
  print "User left! Running screen-saver!\n";
  $away = 1;
 `open -a /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app`;
 }
else {
print "Unknown yubikey.. What to do?\n"; }
}
sleep 5;
 }

else { 
sleep 10;
if (`$yubiTestCmd` =~ m/$myYubi/) {
 $away = 0;
}

 }


}
