class Mrbayes < Formula
  desc "Bayesian inference of phylogenies and evolutionary models"
  homepage "https://mrbayes.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mrbayes/mrbayes/3.2.6/mrbayes-3.2.6.tar.gz"
  sha256 "f8fea43b5cb5e24a203a2bb233bfe9f6e7f77af48332f8df20085467cc61496d"
  head "https://mrbayes.svn.sourceforge.net/svnroot/mrbayes/trunk/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg180"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cff3cf3836481d517ee9fc27f76adb464acb56d24fc8bd135a72bc6d75bb606" => :sierra
    sha256 "8daf7a5a685cacc3a389cc5c2ce5690fd70f9537caf4df469393efd9cbb9251e" => :el_capitan
    sha256 "c26cf8600fd909c19bddefcd5abde30d8e9e3ce15e371c5f9185480e51b222ac" => :yosemite
    sha256 "40a093ccf6f43fcb89aa22467d8f63fb14b58456257aef50d1f774256d125c45" => :x86_64_linux
  end

  option "with-beagle", "Build with BEAGLE library support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :mpi => [:cc, :optional]
  depends_on "beagle" => :optional

  def install
    args = ["--disable-debug", "--prefix=#{prefix}"]
    args << "--with-beagle=" + ((build.with? "beagle") ? Formula["beagle"].opt_prefix : "no")
    args << "--enable-mpi="  + ((build.with? "mpi") ? "yes" : "no")

    cd "src" do
      system "autoconf"
      system "./configure", *args
      system "make"
      bin.install "mb"
    end

    # Doc and examples are not included in the svn
    pkgshare.install ["documentation", "examples"] unless build.head?
  end

  def caveats
    unless build.head?
      <<-EOS.undent
        The documentation and examples are installed to
            #{HOMEBREW_PREFIX}/share/mrbayes
      EOS
    end
  end

  test do
    pipe_output(bin/"mb", "Execute #{pkgshare}/examples/finch.nex")
  end
end
