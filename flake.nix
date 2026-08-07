{
  description = "Agent skills for the vibe Git worktree manager";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-x86_64-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

  outputs =
    {
      nixpkgs,
      nixpkgs-x86_64-darwin,
      ...
    }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      nixpkgsFor =
        system:
        let
          isIntelDarwin = system == "x86_64-darwin";
        in
        if isIntelDarwin then nixpkgs-x86_64-darwin else nixpkgs;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = (nixpkgsFor system).legacyPackages.${system};
          isIntelDarwin = system == "x86_64-darwin";
          pinactPackage =
            if isIntelDarwin then
              pkgs.callPackage (nixpkgs + "/pkgs/by-name/pi/pinact/package.nix") { }
            else
              pkgs.pinact;
        in
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              actionlint
              gh
              git
              gitleaks
              lefthook
              pinactPackage
            ];

            shellHook = ''
              if git rev-parse --git-dir >/dev/null 2>&1; then
                lefthook install >/dev/null
              fi
            '';
          };
        }
      );

      formatter = forAllSystems (system: (nixpkgsFor system).legacyPackages.${system}.nixfmt-tree);
    };
}
