{
  flake.nixosModules.pipewire = { pkgs, ... }: {

    # Make sure the old stack is off; it conflicts with PipeWire
    services.pulseaudio.enable = false; # older releases: hardware.pulseaudio.enable

    # Lets PipeWire get realtime scheduling
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true; # ALSA apps (like cliamp) route through PipeWire
      alsa.support32Bit = true; # needed for 32-bit apps, Steam/Wine games
      pulse.enable = true; # PulseAudio compatibility (pavucontrol, most apps)
      jack.enable = true; # optional: JACK apps (DAWs, etc.)
      wireplumber.enable = true; # session manager (default, so usually implied)
    };

    environment.systemPackages = with pkgs; [
      wiremix # Simple TUI mixer for PipeWire
    ];

  };
}
