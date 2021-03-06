class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.121.0.tar.gz"
  sha256 "494067d6de027c1a1ba6f13ed13bc4988a71e36d7ff6d12247ea6bd7494989f3"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "243f073e5f03897427cfdf5b478f180a80aac9dcafe60274e42c327c267848cd" => :catalina
    sha256 "9d61952f2deb1b4ceb4af37877e89627c5d64029da0a1c067b560bb0023a5da9" => :mojave
    sha256 "783f36237e52966c7150c5ea6f665fdc623293870029d708dbdb14616bcbdbf9" => :high_sierra
    sha256 "e38439ac5d298536fbc14e53b9cf88df6353fcde9fd5c43c7a6a7671a7469f9f" => :x86_64_linux
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  unless OS.mac?
    depends_on "rsync" => :build
    depends_on "elfutils"
  end

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
