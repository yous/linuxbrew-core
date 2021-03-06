class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.15.tar.gz"
  sha256 "ed9b44690f9660d25562e45472d486c086bcc916bf49f39f22e0a90444d44454"
  revision 1

  bottle do
    cellar :any
    sha256 "b5030cf46705161bfedb5c7ab2381fdd6e5fae5fff949b88192890baebcb6799" => :mojave
    sha256 "ee6d527c83cc3ceeaab865b57e252fa586ff688f7ad621d8f888f0099abdc620" => :high_sierra
    sha256 "f8804407c6e9db55ff09309fefd98559564de2827d0240c7f26b6aa9d559c30c" => :sierra
    sha256 "5421ae44bba01e58b105d1fca4e5125edd778cf78aec41cf2d617744dccf7f95" => :x86_64_linux
  end

  depends_on "openssl@1.1"

  conflicts_with "suite-sparse", :because => "suite-sparse vendors libmongoose.dylib"

  def install
    # No Makefile but is an expectation upstream of binary creation
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
    (testpath/"hello.html").write <<~EOS
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
