class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.8.25.tar.bz2"
  sha256 "d76d79edc31cf76e782b9f697420d3defbcc91778c3c650658086a1b748e8792"

  bottle do
    cellar :any_skip_relocation
    sha256 "29ebb59b42af0959efe85ca374d03cd51984b9966c3be2ed51c8ae30098e0ea2" => :mojave
    sha256 "832957657fec785b6d157a6a670da607675bdef8655d82c3a16fc39e305e5e57" => :high_sierra
    sha256 "92fb7438f0467c2f749218cb8b23fa1bf66425fb8f49b20888530fb97094598f" => :sierra
    sha256 "227d87e21775e920816ddf628baaddeaab849107caca94b31cfa80e9d46aedfe" => :x86_64_linux
  end

  keg_only :provided_by_macos,
    "pcsc-lite interferes with detection of macOS's PCSC.framework"

  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    args = %W[--disable-dependency-tracking
              --disable-silent-rules
              --prefix=#{prefix}
              --sysconfdir=#{etc}
              --disable-libsystemd]
    args << "--disable-libudev" unless OS.mac?

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
