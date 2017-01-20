class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftpmirror.gnu.org/datamash/datamash-1.1.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/datamash/datamash-1.1.1.tar.gz"
  sha256 "420819b3d7372ee3ce704add847cff7d08c4f8176c1d48735d4a632410bb801b"

  bottle do
    cellar :any_skip_relocation
    sha256 "4420558eec5e035b90b7380157716d8b4408573ea68476e08a8ec6e4d048a226" => :sierra
    sha256 "2a2fd2e18e862dc1fb81d4aca8d908e8775e130cea4f2a3a9778f2135733c3ea" => :el_capitan
    sha256 "7fd000bb2c51fe6caba8973bed8dfc7b8382f48c5bee4365a2532a659706e764" => :yosemite
    sha256 "c30e7a6feb5098f96d5ae0564d326992afebfba734ec917c71c9cca434a40099" => :x86_64_linux
  end

  head do
    url "git://git.savannah.gnu.org/datamash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_equal "55\n", shell_output("seq 10 |'#{bin}/datamash' sum 1")
  end
end
