class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  # doi "10.1016/S0022-2836(05)80360-2"
  # tag "bioinformatics"

  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.6.0/ncbi-blast-2.6.0+-src.tar.gz"
  mirror "ftp://ftp.hgc.jp/pub/mirror/ncbi/blast/executables/blast+/2.6.0/ncbi-blast-2.6.0+-src.tar.gz"
  version "2.6.0"
  sha256 "0510e1d607d0fb4389eca50d434d5a0be787423b6850b3a4f315abc2ef19c996"
  revision 2

  bottle do
    sha256 "cbc5f928474dac2befb70abeb3a48482c81dddc96309d06bbe0c79439a7d4fd6" => :sierra
    sha256 "b613e7474b0f7dbdf36e9937da83569c71cf5794f4f7200c9702e77bd480c06b" => :el_capitan
    sha256 "2a28b36b92e381df14713bfcd4098e400f52f93e7882dabc8600dc4c78affac8" => :yosemite
    sha256 "7bd1d80eed5f7e6c7bf0d6e7183c69ce9fbb4ae19f2225b7bd3166338b2fb787" => :x86_64_linux
  end

  option "with-static", "Build without static libraries and binaries"
  option "with-dll", "Build dynamic libraries"

  depends_on "freetype" => :optional
  depends_on "gnutls" => :optional
  depends_on "hdf5" => :optional
  depends_on "lzo" => :optional
  depends_on :mysql => :optional
  depends_on "pcre" => :recommended
  depends_on :python if MacOS.version <= :snow_leopard

  patch do
    # Fixed upstream in future version > 2.6
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/blast/blast-make-fix2.5.0.diff"
    sha256 "ab6b827073df48a110e47b8de4bf137fd73f3bf1d14c242a706e89b9c4f453ae"
  end

  def install
    # The libraries and headers conflict with ncbi-c++-toolkit so use libexec.
    args = %W[
      --prefix=#{prefix}
      --libdir=#{libexec}
      --without-debug
      --with-mt
      --without-boost
    ]

    args << (build.with?("mysql") ? "--with-mysql" : "--without-mysql")
    args << (build.with?("freetype") ? "--with-freetype=#{Formula["freetype"].opt_prefix}" : "--without-freetype")
    args << (build.with?("gnutls") ? "--with-gnutls=#{Formula["gnutls"].opt_prefix}" : "--without-gnutls")
    args << (build.with?("pcre")   ? "--with-pcre=#{Formula["pcre"].opt_prefix}" : "--without-pcre")
    args << (build.with?("hdf5")   ? "--with-hdf5=#{Formula["hdf5"].opt_prefix}" : "--without-hdf5")

    if build.without? "static"
      args << "--with-dll" << "--without-static" << "--without-static-exe"
    else
      args << "--with-static"
      args << "--with-static-exe" unless OS.linux?
      args << "--with-dll" if build.with? "dll"
    end

    cd "c++"

    # The build invokes datatool but its linked libraries aren't installed yet.
    ln_s buildpath/"c++/ReleaseMT/lib", prefix/"libexec" if build.without? "static"

    system "./configure", *args
    system "make"

    rm prefix/"libexec" if build.without? "static"

    system "make", "install"

    # The libraries and headers conflict with ncbi-c++-toolkit.
    libexec.install include
  end

  def caveats; <<-EOS.undent
    Using the option "--with-static" will create static binaries instead of
    dynamic. The NCBI Blast static installation is approximately 7 times larger
    than the dynamic.

    Static binaries should be used for speed if the executable requires fast
    startup time, such as if another program is frequently restarting the blast
    executables.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/blastn -version")
  end
end
