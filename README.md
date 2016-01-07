# IO::Path::Mode

Augment Perl 6's IO::Path with a .mode() method to get the file mode

## Synopsis

```

use IO::Path::Mode;

my $mode = "some-file".IO.mode;

say $mode.set-user-id ?? 'setuid' !! 'not setuid';

say $mode.user.executable ?? 'executable' !! 'not executable';

...


```

## Description

This augments the type ```IO::Path``` to provide a ```.mode``` method that allows
you to get at the file permissions (or mode.)  It follows the POSIX model pf
user, group and other permissions and consequently may not make a meaningful 
result on e.g. Windows (although the underlying calls appear to return something
approximating the correct answer.)

It relies on some non-specified functionality in the VM so may probably only work
with Rakudo on MoarVM.







