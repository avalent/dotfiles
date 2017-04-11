# From https://nixos.org/wiki/Cheatsheet#config_nix
{
  allowUnfree = true;
  #packageOverrides = pkgs_: with pkgs_; {
    #all = with pkgs; buildEnv {
      #name = "all";
      #paths = [
        #emacs
        #file
      #];
    #};
  #};

  packageOverrides = super: let self = super.pkgs; in
  {
    all = with self.pkgs; buildEnv {
      name = "all";
      paths = [
        emacs
        file
        tig
        #myCoolVim
        sox
        stow
      ];
    };

    myPy = self.python.buildEnv.override {
      extraLibs = [ self.pythonPackages.websocket_client  self.pythonPackages.sexpdata ];
      ignoreCollisions = true;
    };

    # From https://gist.github.com/aaronlevin/9a933624d3fda83b01b06acb2aeea0a6/
    myCoolVim = self.lib.overrideDerivation (self.vim_configurable.override { python = self.myPy; }) (o: {
      aclSupport              = false;
      cscopeSupport           = true;
      darwinSupport           = false;
      fontsetSupport          = true;
      ftNixSupport            = true;
      gpmSupport              = true;
      gui                     = false;
      hangulinputSupport      = false;
      luaSupport              = true;
      multibyteSupport        = true;
      mzschemeSupport         = true;
      netbeansSupport         = false;
      nlsSupport              = false;
      perlSupport             = false;
      pythonSupport           = true;
      rubySupport             = true;
      sniffSupport            = false;
      tclSupport              = false;
      ximSupport              = false;
      xsmpSupport             = false;
      xsmp_interactSupport    = false;
    });
  };
}
