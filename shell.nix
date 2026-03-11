{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python313
    stdenv.cc.cc.lib
    zlib
    # Add ffmpeg if faster-whisper needs the binary too
    ffmpeg
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.zlib ]}
  '';
}
