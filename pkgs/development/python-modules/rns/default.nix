{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  esptool,

  # build-system
  setuptools,

  # dependencies
  bleak,
  cryptography,
  netifaces,
  pyserial,

  # tests
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "rns";
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Reticulum";
    tag = version;
    hash = "sha256-jpmh7emJa9qy5Ge2sYgxSz2wYECG6POIEVo4hkAZI+8=";
  };

  patches = [
    (replaceVars ./unvendor-esptool.patch {
      esptool = lib.getExe esptool;
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    bleak
    cryptography
    netifaces
    pyserial
  ];

  pythonImportsCheck = [ "RNS" ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/rncp";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Cryptography-based networking stack for wide-area networks";
    homepage = "https://reticulum.network";
    changelog = "https://github.com/markqvist/Reticulum/blob/${src.tag}/Changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      qbit
    ];
  };
}
