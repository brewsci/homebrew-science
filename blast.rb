class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "http://blast.ncbi.nlm.nih.gov/"
  # doi "10.1016/S0022-2836(05)80360-2"
  # tag "bioinformatics"

  url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.5.0/ncbi-blast-2.5.0+-src.tar.gz"
  mirror "ftp://ftp.hgc.jp/pub/mirror/ncbi/blast/executables/blast+/2.5.0/ncbi-blast-2.5.0+-src.tar.gz"
  version "2.5.0"
  sha256 "cce122a29d309127a478353856b351914232e78a9546941781ff0a4c18ec9c54"

  bottle do
    sha256 "4495b5f379a686f3ed89fe894a1b3c03c67720f219a049ef4f463eb4996fe5cb" => :sierra
    sha256 "8a1eda783cd2242d39acd956ff180b3d7220c93c8330826d7d75c13668ba56ec" => :el_capitan
    sha256 "9e5588eb5d9d83ead8ceb140f2479f4f6ded2ab88181d1e5c59a857e04f39ea0" => :yosemite
    sha256 "33d69f5a77a69acabbe90ceb1114b64073aae746863c7d66f224a4420ef1b4a5" => :x86_64_linux
  end

  # Fix configure: error: Do not know how to build MT-safe with compiler g++-5 5.1.0
  fails_with :gcc => "5"

  # Due to boost 1.58
  fails_with :llvm do
    build 2335
    cause "Dropped arguments to functions when linking with boost"
  end

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

    # Do not deliver this folder, it makes "make install fail" with "Inappropriate file type or format"
    rm_rf buildpath/"c++/ReleaseMT/inc/common/"

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
