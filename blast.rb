class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "http://blast.ncbi.nlm.nih.gov/"
  # doi "10.1016/S0022-2836(05)80360-2"
  # tag "bioinformatics"

  url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.5.0/ncbi-blast-2.5.0+-src.tar.gz"
  mirror "ftp://ftp.hgc.jp/pub/mirror/ncbi/blast/executables/blast+/2.5.0/ncbi-blast-2.5.0+-src.tar.gz"
  version "2.5.0"
  sha256 "cce122a29d309127a478353856b351914232e78a9546941781ff0a4c18ec9c54"
  revision 2

  bottle do
    sha256 "82bbd6d497b5164f3f8492e4ca6c8f6210f2bdcb1b89a3fa013bd83635ec1560" => :sierra
    sha256 "7fc3eeda3d70754bd99614386f60db9586edd8faf6fa1b8103fb343eeb24f9cc" => :el_capitan
    sha256 "bb225affd40c49047d9aec68793edc1259e541a8904368981c620bce93907ab5" => :yosemite
  end

  # Fix configure: error: Do not know how to build MT-safe with compiler g++-5 5.1.0
  fails_with :gcc => "5"

  option "with-static", "Build without static libraries and binaries"
  option "with-dll", "Build dynamic libraries"

  depends_on "freetype" => :optional
  depends_on "gnutls" => :optional
  depends_on "hdf5" => :optional
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "lzo" => :optional
  depends_on :mysql => :optional
  depends_on "pcre" => :recommended
  depends_on :python if MacOS.version <= :snow_leopard

  patch do
    # Fixed upstream in future version 2.6.0
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
    args << (build.with?("jpeg")   ? "--with-jpeg=#{Formula["jpeg"].opt_prefix}" : "--without-jpeg")
    args << (build.with?("libpng") ? "--with-png=#{Formula["libpng"].opt_prefix}" : "--without-png")
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
