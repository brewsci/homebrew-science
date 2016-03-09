class Atompaw < Formula
  desc "PAW dataset generator for 1st-principle simulations"
  homepage "http://users.wfu.edu/natalie/papers/pwpaw/man.html"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.0.0.13.tar.gz"
  sha256 "cbd73f11f3e9cc3ff2e5f3ec87498aeaf439555903d0b95a72f3b0a021902020"

  bottle do
    sha256 "10eaa994320f807abc8873c34ae66d491e765ccd0e21f682e58e01decc4da49c" => :el_capitan
    sha256 "c0bc72d3ddaeb659b6490a9b0b826d8e536903290d410b378a28984b72bbd4b2" => :yosemite
    sha256 "68416236492e5af70fb55df215edf44c24307e91257a2e62994cbd77762d593f" => :mavericks
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
