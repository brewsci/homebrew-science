class Atompaw < Formula
  desc "PAW dataset generator for 1st-principle simulations"
  homepage "http://users.wfu.edu/natalie/papers/pwpaw/man.html"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.0.0.13.tar.gz"
  sha256 "cbd73f11f3e9cc3ff2e5f3ec87498aeaf439555903d0b95a72f3b0a021902020"

  bottle do
    sha256 "fd3287eef1d8d627e5a1d478783df367c239fe738c11a187430136f66b08db76" => :el_capitan
    sha256 "292af99a2ae89bc07e8e87b6014f137b0f070576dbbdaf9865b7665f12f01114" => :yosemite
    sha256 "956259d23620f80e5d887f5ff2c3cbc07e784fcd776586f53a012a8fcea9945f" => :mavericks
  end

  depends_on :fortran
  depends_on "veclibfort"
  depends_on "libxc" => :recommended

  def install
    ENV.deparallelize
    args = %W[--prefix=#{prefix}
              --disable-shared]
    args << "--with-linalg-incs=-I#{Formula["veclibfort"].opt_include}"
    args << "--with-linalg-libs=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"

    if build.with? "libxc"
      args << "--enable-libxc"
      args << "--with-libxc-incs=-I#{Formula["libxc"].opt_include}"
      args << "--with-libxc-libs=-L#{Formula["libxc"].opt_lib} -lxc -lxcf90"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    atompaw_tests = %W[#{doc}/example/F/lda/F.input
                       #{doc}/example/Li/lda/Li.input
                       #{doc}/example/Li/hf/Li.input]
    atompaw_tests.each do |atompaw_input|
      system "#{bin}/atompaw < #{atompaw_input} > atompaw.log"
    end
  end
end
