class Atompaw < Formula
  desc "PAW dataset generator for 1st-principle simulations"
  homepage "https://users.wfu.edu/natalie/papers/pwpaw/man.html"
  url "https://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.0.0.13.tar.gz"
  sha256 "cbd73f11f3e9cc3ff2e5f3ec87498aeaf439555903d0b95a72f3b0a021902020"
  revision 1

  bottle do
    sha256 "cd45642d971fa91d287ee36ddfa6abf977ca213073ecb5ca027c6761695e486e" => :el_capitan
    sha256 "7a164937d25106a74c492ebe3457952048d630a2ccef1efd856b96a36c87a637" => :yosemite
    sha256 "2861f7274926bb37c3b96d0e4bfc5d1f32a21e6793c291a3743a8eb7949c3a2c" => :mavericks
  end

  depends_on :fortran
  depends_on "veclibfort" if OS.mac?
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
