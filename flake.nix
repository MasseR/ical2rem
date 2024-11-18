# nix build github:MasseR/ical2rem
{
  description = "A very basic flake";
  inputs = {
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"] (system:
      rec {
        defaultPackage = packages.ical2rem;
        packages.ical2rem = with nixpkgs.legacyPackages."${system}";
          stdenv.mkDerivation {
            pname = "ical2rem";
            version = "0.8";
            src = ./.;
            buildPhase = ''
            chmod +x ical2rem.pl
            patchShebangs ical2rem.pl
            '';
            installPhase = ''
            mkdir -p $out/bin/
            cp ical2rem.pl $out/bin/
            '';
            buildInputs = [perl];
            nativeBuildInputs = [makeWrapper];
            postFixup = ''
            wrapProgram $out/bin/ical2rem.pl --prefix PERL5LIB : "${with perlPackages; makeFullPerlPath [iCalParser TimeDate]}"
            '';
          };
      }
    );
}
