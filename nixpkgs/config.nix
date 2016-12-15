# From https://nixos.org/wiki/Cheatsheet#config_nix
{
  allowUnfree = true;
  packageOverrides = pkgs_: with pkgs_; {
    all = with pkgs; buildEnv {
      name = "all";
      paths = [
        emacs
        file
      ];
    };
  };
}
