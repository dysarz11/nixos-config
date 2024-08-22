# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };
  

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    #open = true;
    
    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
      nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

  hardware.nvidia.prime = {
    #offload = {
    #enable = true;
    #enableOffloadCmd = true;
    #};
  sync.enable = true;

    # Make sure to use the correct Bus ID values for your system!
  intelBusId = "PCI:0:0:0";
  nvidiaBusId = "PCI:1:2:0";
                # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  #sound.enable = true;
  security.rtkit.enable = true;
  boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1" ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.justin = {
    isNormalUser = true;
    description = "Justin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    lshw
    wget
    gcc
    ghc
    gh
    ranger
    waybar
    # eww # waybar alt
    # For waybar
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; 
        })
    )

    dunst

    # wallpaper
    hyprpaper #swww alt

    kitty
    pulseaudio
    rofi-wayland
    git
    libreoffice
    lua
    libGLU
    monero-gui
    fastfetch
    networkmanagerapplet
    openra
    openarena
    ventoy-full
    exfat
    exfatprogs
    rofi-bluetooth
    tor
    tor-browser
    sweet
    gdb
    zap
    xbase
    erlang
    libutp
    tensorflow-lite
    libtensorflow
    rPackages.keras
    libcxx
    SDL
    SDL2
    cfr
    zulu
    python3
    radare2
    dxa
    zydis
    flasm
    gef
    torrenttools
    qbittorrent-qt5
    mpv
    libvlc
    blueberry
    gv
    openssl
    cmatrix
    mathgl
    mathemagix
    tomb
    xmrig
    atomic-swap
    lynx
    electrum
    bisq-desktop
    gimp
    zathura
    sent
    newsboat
    librewolf
    epubcheck
    epub2txt2
    sdcv
    groff
    stdman
    util-linux
    pywal
    ungoogled-chromium
    #steam
    #protonplus
    #protonup-qt
    zip
    ripunzip
    javaPackages.openjfx21
    libGL
    texliveTeTeX
  ];

  nixpkgs.config.allowUnfree = true;
  #programs.steam = {
  #  enable = true;
  #  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  #};

  #programs.steam.gamescopeSession.enable = true;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # for cursor visibility
    WLR_NO_HARDWARE_CURSORS = "1";

    # make electron apps use wayland
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    opengl.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
