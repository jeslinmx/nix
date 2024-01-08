{
  xdg.dataFile."applications/vivaldi-stable.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Name=Vivaldi
    GenericName=Web Browser
    Comment=Access the Internet
    Exec=/etc/profiles/per-user/jeslinmx/bin/vivaldi --force-dark-mode %U
    StartupNotify=true
    Terminal=false
    Icon=vivaldi
    Type=Application
    Categories=Network;WebBrowser;
    MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/ftp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/mailto;
    Actions=new-window;new-private-window;

    [Desktop Action new-window]
    Name=New Window
    Exec=/etc/profiles/per-user/jeslinmx/bin/vivaldi --force-dark-mode --new-window

    [Desktop Action new-private-window]
    Name=New Private Window
    Exec=/etc/profiles/per-user/jeslinmx/bin/vivaldi --force-dark-mode --incognito
  '';
}
