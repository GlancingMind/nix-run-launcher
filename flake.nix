{
  description = "A ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        lib = {
          # Generates a shell script to launch the application detached from
          # the terminal.
          #
          # Parameters:
          #   application - The derivation of application to be launched.
          #   binaryName (optional) - The name of the application to be
          #     executed. If not given, the applications pname will be used.
          #
          # Example usage:
          #   `default = lib.launch-detached { application = pkgs.foot; };`
          launch-detached = {
            application,
            binaryName ? application.pname
          }: pkgs.writeShellApplication {
            name = "${application.name}-launcher";
            runtimeInputs = [ pkgs.coreutils application ];
            text = "nohup ${binaryName} </dev/null >/dev/null 2>&1 &";
          };
        };
      }
    );
}
