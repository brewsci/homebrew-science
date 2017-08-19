class Wopr < Formula
  homepage "https://ilk.uvt.nl/wopr"

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
    sha256 "e5ab9df7d15881f5a5cee0355c4184afe625c3ea41ca2435434f5d91860f2629" => :sierra
    sha256 "65c46a03ebce0a71f05c5b44cc1a06f17737f2ac1714bb34649deeb3294a62e4" => :el_capitan
    sha256 "90937bd62790616249dc7bde27ffa1b2b2c48ad302d6e50b4f30cbd48725cb7c" => :yosemite
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
