class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      tag:      "v100.0.1",
      revision: "27441adfb51bc16073d65dbef300c8d3d7e86dc7"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0e179d579938e4301f04b4896bb2c234f4b643e53e53cbd4a7f796978d2ea6d" => :catalina
    sha256 "ac56190c6ec7e25d49f979aff7f6cc3e45820002ef22fbc444196b64de2590f9" => :mojave
    sha256 "1eb5cf4cd5565e07659f37e2531be1e72b0e2e8e57587af229e230fa00315ed3" => :high_sierra
    sha256 "dd1710f0d55cf77c4c9d71050d1c384ae849a46206e7fca4d0cd33f3ee9fc4b8" => :x86_64_linux
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "lolcat.gemspec"
    system "gem", "install", "lolcat-#{version}.gem"
    bin.install libexec/"bin/lolcat"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    man6.install "man/lolcat.6"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      This is
      a test
    EOS

    system bin/"lolcat", "test.txt"
  end
end
