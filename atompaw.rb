class Atompaw < Formula
  desc "PAW dataset generator for 1st-principle simulations"
  homepage "http://users.wfu.edu/natalie/papers/pwpaw/man.html"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.0.0.12.tar.gz"
  sha256 "693826cc5211cef965a619446a031d2207db45c3a570f470b685cb8ad538c2d5"

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
