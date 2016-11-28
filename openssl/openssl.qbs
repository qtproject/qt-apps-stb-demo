import qbs
import qbs.Probes

Product {
    Probes.PathProbe {
        id: pkgConfigProbe
        names: ["pkg-config"]
        pathSuffixes: ["bin"]
    }

    Probes.PkgConfigProbe {
        id: opensslProbe
        executable: pkgConfigProbe.filePath
        name: "libssl"
        minVersion: "1.0"

        // HACK: Homebrew doesn't install OpenSSL .pc files to the "correct" directory
        libDirs: ["/usr/local/opt/openssl/lib/pkgconfig"]
    }

    Group {
        property stringList opensslLdflags: opensslProbe.libs
        condition: qbs.targetOS.contains("macos")
        name: "OpenSSL"
        files: {
            if (!opensslLdflags)
               return [];

            var libsslPath;
            var libsslName;
            for (var i = 0; i < opensslLdflags.length; ++i) {
                if (opensslLdflags[i].startsWith("-L"))
                    libsslPath = opensslLdflags[i].substr(2);
                if (opensslLdflags[i].startsWith("-l"))
                    libsslName = opensslLdflags[i].substr(2);
            }
            if (qbs.sysroot && libsslPath.startsWith(qbs.sysroot))
                libsslPath = libsslPath.substr(qbs.sysroot.length);
            return [[libsslPath, "lib" + libsslName + "*.dylib"].join(qbs.pathSeparator)];
        }
        qbs.install: true
        qbs.installDir: qbs.targetOS.contains("darwin")
                        ? "Applications/Qt TV.app/Contents/Frameworks"
                        : "lib"
    }
}
