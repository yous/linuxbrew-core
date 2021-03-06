class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://www.cs.ubc.ca/research/flann/"
  url "https://github.com/mariusmuja/flann/archive/1.9.1.tar.gz"
  sha256 "b23b5f4e71139faa3bcb39e6bbcc76967fbaf308c4ee9d4f5bfbeceaa76cc5d3"
  revision 7

  bottle do
    cellar :any
    sha256 "d7a3870b59388e523bb964b92f0030e75823c84072a55dfdcbe676bd2b1b046f" => :mojave
    sha256 "0dbf4ddcdab675609aa59e953052fde8e557212127ee0befad52fc5d92a561f0" => :high_sierra
    sha256 "28479047aad4a062976572abf76feec33ed2b4a71373d2f9db1b7958d896ba71" => :sierra
    sha256 "16b9b6ff6a95e43eed7f4b09c5a82ea487c14a7f994ae346958d4d6b1d8b662f" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  # Fix for Linux build: https://bugs.gentoo.org/652594
  # Not yet fixed upstream: https://github.com/mariusmuja/flann/issues/369
  patch do
    url "https://raw.githubusercontent.com/buildroot/buildroot/0c469478f64d0ddaf72c0622a1830d855306d51c/package/flann/0001-src-cpp-fix-cmake-3.11-build.patch"
    sha256 "aa181d0731d4e9a266f7fcaf5423e7a6b783f400cc040a3ef0fef77930ecf680"
  end unless OS.mac?

  resource("dataset.dat") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/dataset.dat"
    sha256 "dcbf0268a7ff9acd7c3972623e9da722a8788f5e474ae478b888c255ff73d981"
  end

  resource("testset.dat") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/testset.dat"
    sha256 "d9ff91195bf2ad8ced78842fa138b3cd4e226d714edbb4cb776369af04dda81b"
  end

  resource("dataset.hdf5") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/dataset.hdf5"
    sha256 "64ae599f3182a44806f611fdb3c77f837705fcaef96321fb613190a6eabb4860"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_PYTHON_BINDINGS:BOOL=OFF", "-DBUILD_MATLAB_BINDINGS:BOOL=OFF"
    system "make", "install"
  end

  test do
    resource("dataset.dat").stage testpath
    resource("testset.dat").stage testpath
    resource("dataset.hdf5").stage testpath
    system "#{bin}/flann_example_c"
    system "#{bin}/flann_example_cpp"
  end
end
