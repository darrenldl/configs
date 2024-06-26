# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./boot.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Australia/Sydney";

  services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # GNOME
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  programs.dconf.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    # gnome-console
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      variant = "";
      layout = "au";
    };
  };

  environment.localBinInPath = true;

  environment.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Flatpak service
  services.flatpak.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.darren = {
    isNormalUser = true;
    description = "darren";
    extraGroups = [ "networkmanager" "wheel" ];
    packages =
      let gnomeRelatedPkgs = with pkgs; [
          gnome.gnome-tweaks
          gnome.gnome-software
        ];
      in
      (with pkgs; [
        firefox
        keepassxc
        # ungoogled-chromium
        evolution
        mate.eom
        mpv
        poppler_utils
        gnumake
        python3
      ])
      ++
      (with pkgs.libsForQt5; [
        okular
      ])
      ;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    let gnomeRelatedPkgs = with pkgs; [
        gnome.adwaita-icon-theme
        gnome.adwaita-icon-theme
        gnomeExtensions.appindicator
      ];
    in
    let virtRelatedPkgs = with pkgs; [
        swtpm
      ];
    in
    (with pkgs; [
      wget
      curl
      tmux
      neovim
      btop
      blueman
      git
      gnupg
      podman
      restic
      pandoc
      fzf
      ripgrep
      unzip
      nmap
      tokei
      fastfetch
    ])
    ++
    gnomeRelatedPkgs
    ++
    virtRelatedPkgs
  ;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.blueman.enable = true;

  services.fwupd.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.podman = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.checkReversePath = false;
  networking.firewall.allowedUDPPorts = [ 51820 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
