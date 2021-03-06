class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.39.0.tar.gz"
  sha256 "35a4b0b812988a2ff8e8374b4917dcff25bd9f95b0b6e093fbce9877e4abb73a"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a73c6988e89e464fa1d1c4e36a5e938a7cb288872b55b812ffdfdc73ddc7d6c0" => :catalina
    sha256 "93caae5513e0e06a6aa7ad6a94654e869e160c2e396b0b90f3b13fa8ac3d2c85" => :mojave
    sha256 "ebf3f89c3321e85943e1bf8582ffb75608d9ea0ddd22adf4408a82fa15d03eda" => :high_sierra
    sha256 "eeaadfa35f4675727dae960596bb9571140487708cc81d38fe608983aa9ddda3" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    doctl_version = version.to_s.split(/\./)

    src = buildpath/"src/github.com/digitalocean/doctl"
    src.install buildpath.children
    src.cd do
      base_flag = "-X github.com/digitalocean/doctl"
      ldflags = %W[
        #{base_flag}.Major=#{doctl_version[0]}
        #{base_flag}.Minor=#{doctl_version[1]}
        #{base_flag}.Patch=#{doctl_version[2]}
        #{base_flag}.Label=release
      ].join(" ")
      system "go", "build", "-ldflags", ldflags, "-o", bin/"doctl", "github.com/digitalocean/doctl/cmd/doctl"
    end

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
