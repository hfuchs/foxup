#!/usr/bin/perl
# 2011-02-01, Created by hf.
# Purpose: Shut down the machine after all NFS connections were closed and all
# users are gone.

# -- Pragmas, modules and constants.
use feature qw/say/;
use constant DEBUG     => 0;
use constant MINUP     => 300;     # 5 minutes
use constant MAXUP     => 14400;  # 4 hours  [TODO just a quick fix]
use constant STOPFILE  => "/tmp/nohalt";
use constant BACKUPDIR => "/mnt/backup";

# -- Collect status information (still logged in?, uptime?, ...).
my ($uptime) = split /\s/, `cat /proc/uptime`;
my $users    = split /\n/, `who`;
#my $cmd      = "showmount";             # NFS version
my $cmd      = "lsof " . BACKUPDIR;     # rsync version
my $mounts   = split /\n/, `$cmd`;
my $anacron  = system("pgrep anacron >/dev/null");

# -- Have your say (if in debug mode).
say "Up: ", $uptime, " Mounts: ", $mounts, " Users: ", $users if (DEBUG);

# -- Exit if the time is *not* ripe.
exit 0 if ($uptime < MINUP);                 # Not on-line long enough.
exit 0 if ($users > 0);                      # Someone still logged in.
exit 0 if (-e STOPFILE);                     # The stop-file exists
exit 0 if ($mounts > 1 and $uptime < MAXUP); # Someone still mounts.
exit 0 if ($anacron == 0);                   # Anacron still running.

# -- Halt the system if it is (unless it's debug time).
say "Would halt now!" if (DEBUG);
system("halt") unless (DEBUG);

