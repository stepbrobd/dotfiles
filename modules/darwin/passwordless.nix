{
  environment.etc."sudoers.d/10-passwordless".text = ''
    ysun ALL=(ALL:ALL) NOPASSWD:SETENV: ALL
  '';
}
