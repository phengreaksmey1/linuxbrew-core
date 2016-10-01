class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.5.tar.gz"
  sha256 "f0145d1e51c58df5d1602d632710399f0a3fa850b161f955a8b0edb023f02fde"

  bottle do
    cellar :any
    sha256 "a13af2d5a282ff43b5732179c504f40526b0c028afedf922dcfec2b2c37e7e77" => :sierra
    sha256 "1eeec9281c060972b1dd182d8f761eb92f9ddae63c069b064312948592145913" => :el_capitan
    sha256 "91c28ea470a99e7f04822f495929fe048ed06b2dbc9f0b37b8680aaa0ef587fe" => :yosemite
    sha256 "b1804618ed47cca9b9d231d591fffc2acc2fb47abd3ff8c70d2ea481ddb4d30a" => :mavericks
    sha256 "20f2d343a7e9bf52722e17a713352b381cb371523fd1d58ae61195167af3f9dc" => :x86_64_linux
  end

  depends_on "openssl" => :recommended

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/blob/master/docs/Usage.md
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/simplest_web_server" do
      system "make"
      bin.install "simplest_web_server" => "mongoose"
    end

    if OS.mac?
      system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib"
      lib.install "libmongoose.dylib"
    else
      system ENV.cc, "-fPIC", "-c", "mongoose.c"
      system ENV.cc, "-shared", "-Wl,-soname,libmongoose.so", "-o", "libmongoose.so", "mongoose.o", "-lc", "-lpthread"
      lib.install "libmongoose.so"
    end
    include.install "mongoose.h"
    pkgshare.install "examples", "jni"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.html").write <<-EOS.undent
      <!DOCTYPE html>
      <html>
        <head>
          <title>Homebrew</title>
        </head>
        <body>
          <p>Hi!</p>
        </body>
      </html>
    EOS

    begin
      pid = fork { exec "#{bin}/mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
