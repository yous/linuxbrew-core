class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-fts/davix.git",
      :tag      => "R_0_7_5",
      :revision => "4b04a98027ff5ce94e18e3b110420f1ff912a32c"
  version "0.7.5"
  head "https://github.com/cern-fts/davix.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "c7921fa562e5a856e3bf71297498c42a27bcd3f8d4f2fd6a8fda5c9945171767" => :mojave
    sha256 "6ce2b3be5a9fcdb7d06c137984aa04bbc93061b9fd4ceca91ccc2fe4928f526c" => :high_sierra
    sha256 "cdbcbf1856a6c668125c7109d021352103404c018ef06537ef06d348dbe55985" => :sierra
    sha256 "35996a65253d3bd5e3c1c5c5ed5051b43b813ef55f6e79a9c6b743e2406dee5d" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@1.1"
  unless OS.mac?
    depends_on "libxml2"
    depends_on "util-linux" # for libuuid
  end

  def install
    ENV.libcxx

    cp "release.cmake", "version.cmake"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://www.google.com"
  end
end
