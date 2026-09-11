{
  description = "A flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = { 
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprfm = { 
    #   url = "github:soyeb-jim285/hyprfm";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.quill-icons.url = "github:soyeb-jim285/quill-icons/69b653672ece8652cfef52c1c228abe9e2c4fce0";
    # };
  };

  outputs = { self, nixpkgs, home-manager, nix-index-database, ... }@inputs:{

    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
                 ./configuration.nix
                 nix-index-database.nixosModules.default
                 inputs.musnix.nixosModules.musnix
                 home-manager.nixosModules.home-manager {
                   home-manager = {
                     useGlobalPkgs = true;
                     useUserPackages = true;
                     extraSpecialArgs = { inherit inputs; };
                     users.kirill = import ./modules/home.nix;
                     backupFileExtension = "backup";
                   };
                 }
                ];
    };
  };
}
