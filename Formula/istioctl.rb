class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.3.0",
      :revision => "c2bd59595ce699b31d0f931885f023028ff7902b"

  bottle do
    cellar :any_skip_relocation
    sha256 "55b0abf26212a482183a5eba485b995aa65f52d385f745b89da407e3a83a3c95" => :mojave
    sha256 "0edd1e12919a4ee9fd1f54934b941f9060260a7dff84c767c8a275423a45692b" => :high_sierra
    sha256 "3230c9f868614abf55b48df49b34df0d04eff881b6a514294bf8672a1a0591a1" => :sierra
    sha256 "159d7b17ff4c808bded5db3e07920dcae08fe793fddb2366b3422022dced721b" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s

    srcpath = buildpath/"src/istio.io/istio"
    if OS.mac?
      outpath = buildpath/"out/darwin_amd64/release"
    else
      outpath = buildpath/"out/linux_amd64/release"
    end
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "istioctl"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
    end
  end

  test do
    assert_match "Retrieve policies and rules", shell_output("#{bin}/istioctl get -h")
  end
end
