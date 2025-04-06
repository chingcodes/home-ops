{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  # Packages you need for development go here
  packages = with pkgs ; [
    (python313.withPackages (ps: with ps; [ pip requests netaddr ]))

    mise
    uv
    go-task
    age
    jq
    makejinja
    sops
    fluxcd
    cue

    kubectl
    k9s
    talosctl
    kubernetes-helm
    kustomize
    kubeconform
    cloudflared
    yewtube
  ];

  shellHook = ''
    echo "Entering home-ops shell..."

    # Tells pip to put packages into $PIP_PREFIX instead of the usual locations.
    # See https://pip.pypa.io/en/stable/user_guide/#environment-variables.
    export PIP_PREFIX=$(pwd)/_build/pip_packages
    export PYTHONPATH="$PIP_PREFIX/${pkgs.python313.sitePackages}:$PYTHONPATH"
    export PATH="$PIP_PREFIX/bin:$PATH"
    unset SOURCE_DATE_EPOCH
  '';
}
