class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.13.tar.gz"
  sha256 "22bf9676c958a2d434eb016b1c8cdd5d7af5f4c4b53fd73898064878721a13df"

  bottle do
    cellar :any_skip_relocation
    sha256 "862e6920a85e3248e23f9cd6ac2bdec9c1979cdce4081716880cadab4e2d0aaf" => :catalina
    sha256 "46f036864c900aa78029b71f5117250b5231bb8248879b08d22bc995bb7bd06c" => :mojave
    sha256 "0854c1a21c8e1fa7a6fcc1a5b087ea2ed79f9ccc5dcc073531a587cf84cfc042" => :high_sierra
    sha256 "5b0d91327cdd6be01c90c084fa84456b335ec2607022d1597d94393100d0bd3e" => :x86_64_linux
  end

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
  end

  def install
    (buildpath/"unittest/googletest").install resource("gtest")
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      int main() {
        printf("Hello World\n");
        return 0;
      }
    EOS
    if OS.mac?
      (testpath/"tundra.lua").write <<~'EOS'
        Build {
          Units = function()
            local test = Program {
              Name = "test",
              Sources = { "test.c" },
            }
            Default(test)
          end,
          Configs = {
            {
              Name = "macosx-clang",
              DefaultOnHost = "macosx",
              Tools = { "clang-osx" },
            },
          },
        }
      EOS
    else
      (testpath/"tundra.lua").write <<~'EOS'
        Build {
          Units = function()
            local test = Program {
              Name = "test",
              Sources = { "test.c" },
            }
            Default(test)
          end,
          Configs = {
            {
              Name = "linux-gcc",
              DefaultOnHost = "linux",
              Tools = { "gcc" },
            },
          },
        }
      EOS
    end
    system bin/"tundra2"
    if OS.mac?
      system "./t2-output/macosx-clang-debug-default/test"
    else
      system "./t2-output/linux-gcc-debug-default/test"
    end
  end
end
