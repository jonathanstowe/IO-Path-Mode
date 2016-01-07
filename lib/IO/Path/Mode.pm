use v6;

# Abandon all hope etc;
use MONKEY;

class IO::Path::Mode:ver<0.0.1>:auth<github:jonathanstowe> {

    my constant S_IFMT  = 0o170000;

    # masks
    my constant S_ISUID = 0o004000; # set user id bit
    my constant S_ISGID = 0o002000; # set group id bit;
    my constant S_ISVTX = 0o001000; # sticky bit

    my constant S_IRWXU = 0o000700; # user perms
    my constant S_IRWXG = 0o000070; # group perms
    my constant S_IRWXO = 0o000007; # other perms


    enum FileType ( Socket          => 0o140000, 
                    SymbolicLink    => 0o120000, 
                    File            => 0o100000, 
                    Block           => 0o060000,
                    Directory       => 0o040000,
                    Character       => 0o020000,
                    FIFO            => 0o010000);

    enum Perms ( Execute => 0o00001, Write => 0o00002, Read => 0o00004);

    role Permissions {
        method execute() returns Bool {
            Bool(self.Int +& Execute.Int);
        }
        method write() returns Bool {
            Bool(self.Int +& Write.Int);
        }
        method read() returns Bool {
            Bool(self.Int +& Read.Int);
        }
    }

    has Int $.mode;
    multi method new(IO::Path:D :$path) {
        self.new(file => $path.Str);
    }
    multi method new(Str:D :$file) {
        my Int $mode = nqp::p6box_i(nqp::stat(nqp::unbox_s($file), nqp::const::STAT_PLATFORM_MODE));
        self.new(:$mode);
    }

    method gist() {
        $!mode.base(8).Str;
    }

    method file-type() returns FileType {
        my $ft = $!mode +& S_IFMT;
        return FileType($ft);
    }

    method set-user-id() returns Bool {
        return Bool($!mode +& S_ISUID);
    }

    method set-group-id() returns Bool {
        return Bool($!mode +& S_ISGID);
    }

    method sticky() returns Bool {
        return Bool($!mode +& S_ISVTX);
    }

    method user() returns Permissions {
        my Int $perms = ($!mode +& S_IRWXU) +> 6;
        return $perms but Permissions;
    }
    method group() returns Permissions {
        my Int $perms = ($!mode +& S_IRWXG) +> 3;
        return $perms but Permissions;
    }
    method other() returns Permissions {
        my Int $perms = ($!mode +& S_IRWXO);
        return $perms but Permissions;
    }
}

augment class IO::Path {
    method mode() returns IO::Path::Mode {
        return IO::Path::Mode.new(path => self);
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
