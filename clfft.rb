class Clfft < Formula
  homepage "https://github.com/clMathLibraries/clFFT/"
  url "https://github.com/clMathLibraries/clFFT/archive/v2.4.tar.gz"
  sha256 "d77506af774bbe8ccf4226a58e623c8a29587edcf02984e72851099be0efe04b"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "fd803537e3af8d9189852ac87001d6be4562f5a20a9d8cb11d799548dbc71bb5" => :yosemite
    sha256 "8265a5b1a675ad57825240e75cc58bf3a83996808019f6fc43cc7c55c78fc8c8" => :mavericks
    sha256 "135f7e329b29dbadf53bfa4c6b8110800fefc013edbf88c5263b8618ff3008e9" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build

  patch do
    # rename Client
    url "https://github.com/clMathLibraries/clFFT/commit/ecf5d654e3588a2b829227812f4333fb5e9abc90.diff"
    sha256 "2aefc0c7550853d9ef9bc0efc5e39e12acdf66358e11a0946adf89fc2f6a961b"
  end

  patch do
    # fix shared lib loading for mac
    url "https://github.com/clMathLibraries/clFFT/commit/ecc34629034390a8846490b2d3fe0a4a46a7486a.diff"
    sha256 "de8631695044be6a567d881b5ebfe463b7a706d62f1e6b44b3194526a0632796"
  end

  patch do
    # don't install py files in bin
    url "https://github.com/clMathLibraries/clFFT/commit/ae845846990bfabe5c01ee8629b8df32ca9ce7a9.diff"
    sha256 "b61b93b0065a1bce678883109f13690dc2cc88e86a8a37ac490bb4b5a8d37828"
  end

  patch do
    # properly deal with rpaths
    url "https://github.com/clMathLibraries/clFFT/commit/5d30d17fa8d7fdf6eb0fd6ee28a2c79d989dbed9.diff"
    sha256 "d198d25581ca543ce70a1d908ddad8e4802e3f16ecde7aa4a8878bdbc91e7593"
  end

  patch do
    # don't use lib64 in lib path
    url "https://github.com/clMathLibraries/clFFT/commit/67d1085deb54f8fc166d9523092ff97a190d56ae.diff"
    sha256 "73c4e4b315284ab86c60ba46d608e817e52698383e6d7910e2cc41bc1e744d9b"
  end

  patch do
    # install cmake config and version files
    url "https://github.com/clMathLibraries/clFFT/commit/c7bac74917ecdeb6d4db7a3f6d677ddba412efa0.diff"
    sha256 "31e5a6ffc8e94e30970035162c2b45418795929402513b189d2f8fd3a3810ef0"
  end

  patch do
    # don't force the usage of libc++
    url "https://github.com/clMathLibraries/clFFT/pull/73.diff"
    sha256 "ad7d8b858027e8562b5478793583299f2dfc00621919c62ee199e1885af09a99"
  end

  def install
    cd "src"
    system "cmake", ".", "-DBUILD_TEST:BOOL=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    # apple's opencl for cpu has a known bug that makes clfft fail on cpu
    cd lib
    output = `#{bin}/clFFT-client -i`
    assert $?.success? unless output =~ /CL_DEVICE_TYPE: +CPU/
  end
end
