class Libminc < Formula
  desc "Medical Imaging file format and Toolbox"
  homepage "https://en.wikibooks.org/wiki/MINC"
  url "https://github.com/BIC-MNI/libminc/archive/libminc-2-3-00.tar.gz"
  version "2.3.00"
  sha256 "8c00e0383575ace1f941a5b35b99678db2a0dd5e023f8671d25debc949c7cf12"
  revision 3

  bottle do
    cellar :any
    sha256 "72580ca8d34e69ad5aa38eb7335f545f7f83405333d0be85fb60b9fd33639945" => :sierra
    sha256 "294737c53350cc72b529f237c4b0d324f09d25741ade5501bc8b0c76cdfbeae2" => :el_capitan
    sha256 "6faa96547a0c37fced5add8dce0a3de9a84669d8a3deaf7a73fcb8173b95b62d" => :yosemite
    sha256 "f055ff44c403104eb3514100e46ee513e929aa98e0c5747de18a4ec41618f6b3" => :x86_64_linux
  end

  depends_on "hdf5"
  depends_on "netcdf"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{libexec}"
    system "make", "install"

    lib.mkdir
    ln_sf Dir["#{libexec}/lib/*.a"], lib
    ln_sf Dir["#{libexec}/lib/*.dylib"], lib

    include.mkdir
    ln_sf Dir["#{libexec}/includebrew "], include

    cd "testdir" do
      system "cmake", "."
    end

    pkgshare.install "testdir"
  end

  test do
    cp_r "#{pkgshare}/testdir/.", testpath
    system "./minc2-datatype-test"
  end
end
