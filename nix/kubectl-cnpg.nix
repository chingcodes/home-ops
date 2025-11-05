{ pkgs }:

pkgs.buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.27.1";

  src = pkgs.fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-iEia3g3nxnVm4q5lpV9SFOSKgHJsZ7jdqE73vA2bPpI=";
  };

  vendorHash = "sha256-nbUaSTmhAViwkguMsgIp3lh2JVe7ZTwBTM7oE1aIulk=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = with pkgs.lib; {
    description = "kubectl plugin for CloudNativePG";
    homepage = "https://cloudnative-pg.io";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
