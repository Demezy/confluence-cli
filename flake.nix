{
  description = "A command-line interface for Atlassian Confluence";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        confluence-cli = pkgs.buildNpmPackage {
          pname = "confluence-cli";
          version =
            (builtins.fromJSON (builtins.readFile ./package.json)).version;

          src = ./.;

          npmDepsHash = "sha256-XJBTPGaLwQQBvzruVLR/vL/6EBcGKN+rbqEC6/Zcqcc=";

          dontNpmBuild = true;

          meta = {
            description = "A command-line interface for Atlassian Confluence";
            homepage = "https://github.com/pchuri/confluence-cli";
            license = pkgs.lib.licenses.mit;
            mainProgram = "confluence";
          };
        };
        default = self.packages.${pkgs.system}.confluence-cli;
      });
    };
}
