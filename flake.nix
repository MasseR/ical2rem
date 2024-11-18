# nix build github:MasseR/ical2rem
{
  description = "A very basic flake";
  inputs = {
  };

  outputs = { self, nixpkgs }: rec {
    packages.x86_64-linux.default = packages.x86_64-linux.ical2rem;
    packages.x86_64-linux.ical2rem = with nixpkgs.legacyPackages.x86_64-linux; stdenv.mkDerivation {
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
  };
}
