class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-core/2.34/at-spi2-core-2.34.0.tar.xz"
  sha256 "d629cdbd674e539f8912028512af583990938c7b49e25184c126b00121ef11c6"

  bottle do
    sha256 "218486e16a9dfcce0b1426a8aed933288220fa1fc9080008809400258987c414" => :x86_64_linux
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "dbus"
  depends_on "gettext"
  depends_on "glib"
  depends_on :linux
  depends_on "linuxbrew/xorg/libx11"
  depends_on "linuxbrew/xorg/libxtst"
  depends_on "linuxbrew/xorg/xorgproto"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "--libdir=#{lib}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{libexec}/at-spi2-registryd", "-h"
  end
end
