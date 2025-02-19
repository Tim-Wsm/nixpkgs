{
  lib,
  fetchzip,
  stdenvNoCC,
  writeText,
}:

stdenvNoCC.mkDerivation rec {
  pname = "iana-etc";
  version = "20240318";

  src = fetchzip {
    url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
    sha256 = "sha256-t/VOTFDdAH+EdzofdMyUO9Yvl5qdMjdPl9ebYtBC388=";
  };

  installPhase = ''
    install -D -m0644 -t $out/etc services protocols
  '';

  setupHook = writeText "setup-hook" ''
    export NIX_ETC_PROTOCOLS=@out@/etc/protocols
    export NIX_ETC_SERVICES=@out@/etc/services
  '';

  meta = with lib; {
    homepage = "https://github.com/Mic92/iana-etc";
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
