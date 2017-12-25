class Wopr < Formula
  homepage "https://ilk.uvt.nl/wopr"
  revision 1

  stable do
    url "https://software.ticc.uvt.nl/wopr-1.36.1.tar.gz"
    sha256 "ffcf2ce85f18dcce86a45ecdd9f3066e4c1f8043b8b33bf4bc71bfe91ae32e49"

    # C++11 compatibility
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/0846a0c/wopr/cxx11.diff"
      sha256 "c113e269f9c13307ed791c799ce75f92e4b3b654c77a69e87f746c4cdeb0566b"
    end

    # Upstream commit from 28 Feb 2017 "Don't use a timbl function that was
    # non-functional for 7 years already."
    patch do
      url "https://github.com/LanguageMachines/wopr/commit/9cdb23b.patch?full_index=1"
      sha256 "c926149b59a3a3e01dc9005923a7a99745810cd04b85e3274ca6d1a12d40ac9d"
    end
  end

  bottle do
    cellar :any
    sha256 "5a9190ebe32630c2af81f0b842b35829287f89c4f2d59abe4d0bf1de45e6b644" => :high_sierra
    sha256 "f97455f03119767c279d6ab29fa2e4141acd70544f400e45667947514ec6fe59" => :sierra
    sha256 "583a0dc5c1a5a385aa10b8a68ccb52ae19756bcd955a6b3b773a8fd71103058c" => :el_capitan
    sha256 "48e1fa0c02cf59eb7c33bfb0e81932a348c81821a2be288246d07271bda4bd73" => :x86_64_linux
  end

  head do
    url "https://github.com/LanguageMachines/wopr.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "libfolia"
  end

  depends_on "pkg-config" => :build
  depends_on "timbl"
  depends_on "icu4c"

  needs :cxx11

  def install
    ENV.cxx11

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]

    if build.head?
      chmod 0755, "bootstrap.sh"
      system "./bootstrap.sh"
    else
      args << "--without-folia"
    end

    system "./configure", *args
    system "make", "install"
  end
end
