{
  description = "Home-Ops shell";

  inputs = {
    # Use the desired channel for nixpkgs; here we use unstable as an example.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Add the talhelper flake as an input.
    talhelper.url = "github:budimanjojo/talhelper";
  };

  outputs = { self, nixpkgs, talhelper }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    # Import custom packages
    kubectl-cnpg = pkgs.callPackage ./nix/kubectl-cnpg.nix { };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
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
        helmfile
        kustomize
        kubeconform
        cloudflared
        yewtube
        cilium-cli

        # Add the telhelper package from the talhelper flake.
        talhelper.packages.${system}.default
      ] ++ [
        # Custom packages
        kubectl-cnpg
      ];

      shellHook = ''
        echo "Entering home-ops shell..."
        export PIP_PREFIX=$(pwd)/_build/pip_packages
        export PYTHONPATH="$PIP_PREFIX/${pkgs.python313.sitePackages}:$PYTHONPATH"
        export PATH="$PIP_PREFIX/bin:$PATH"
        unset SOURCE_DATE_EPOCH

        export KUBECONFIG=$(pwd)/kubeconfig
        export TALOSCONFIG=$(pwd)/talos/clusterconfig/talosconfig
        export SOPS_AGE_KEY_FILE=$(pwd)/age.key
      '';
    };
  };
}
