{
  description = "PureScript websocket simple";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  inputs.purescript-overlay = {
    url = "github:thomashoneyman/purescript-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { self, nixpkgs, flake-utils, purescript-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      #let pkgs = nixpkgs.legacyPackages.${system};
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ purescript-overlay.overlays.default ];
        };
        
      in
        {
          devShells.default = pkgs.mkShell {
            name = "purescript-websocket-simple";
            #inputsFrom = builtins.attrValues self.packages.${system};
            buildInputs = with pkgs; [
              purescript
              nodejs
              nodePackages.npm
              spago-unstable
            ];
          };
        }
    );
}
