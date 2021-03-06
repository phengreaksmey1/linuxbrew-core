class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-4.10.1.tar.gz"
  sha256 "903353febf1b88f701198d956a60cec3d2be3cc251561a678061761aec6622f6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f0459c3a5f56b16a2b636a1f37cff5220f08265400b18a2f3bea5640856ae608" => :catalina
    sha256 "23bf3d26128baf28b1204c3b574eeb1c108607b0dc2a3b7d1725f3289ef5b8cf" => :mojave
    sha256 "bc8d7ee7eeee6fa2f586681ca68d892bb504bbeef1d25f156a8039fdb33862d9" => :high_sierra
    sha256 "408fc0d9b6e9310b1b69dc34b22f6622d2ba33f9c087be9d880f2d62398c009e" => :x86_64_linux
  end

  depends_on "openssl@1.1"

  def install
    system "make", "OPENSSL=#{Formula["openssl@1.1"].opt_prefix}", "DESTDIR=#{prefix}", "install"
    # the makefile installs into DESTDIR/usr/..., move everything up one and remove usr
    # the project maintainer was contacted via sourceforge on 12-Feb, he responded WONTFIX on 13-Feb
    prefix.install Dir["#{prefix}/usr/*"]
    (prefix/"usr").unlink
  end

  plist_options :manual => "uftpd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/uftpd</string>
          <string>-d</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/uftp_keymgt"
  end
end
