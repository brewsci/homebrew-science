class Symphony < Formula
  desc "Generic MILP solver"
  homepage "https://projects.coin-or.org/SYMPHONY"
  url "https://www.coin-or.org/download/source/SYMPHONY/SYMPHONY-5.6.6.tgz"
  sha256 "af28afff326635b04ac47857af648244704af0b0743c9a9acd6da0b6b2b60bfb"
  revision 1

  bottle do
    cellar :any
    sha256 "08806b4cf87ace05706b77c5344800d54ef1f386bcfbcae221dec19d6ac84622" => :sierra
    sha256 "9698ba6df20e9804258df4ec32213617f51437daf8169c08a902f0658e2ae85b" => :el_capitan
    sha256 "9b2eb1a5a8989d6471004e62a79efd8fff3a21b956d72e3320f644b7e14cd2fa" => :yosemite
  end

  option "without-test", "Skip build-time tests (not recommended)"
  option "with-openmp", "Enable openmp support"
  option "with-gmpl", "GNU Modeling Language support via GLPK"

  deprecated_option "without-check" => "without-test"

  depends_on "mysql" => :build if build.with? "gmpl"
  depends_on "readline" => :recommended

  conflicts_with "coinmp", :because => "Symphony and CoinMP contain CoinUtils"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--enable-shared=yes",
            "--enable-gnu-packages", "--prefix=#{prefix}"]

    if build.with? "readline"
      ENV.append "CXXFLAGS", "-I#{Formula["readline"].opt_include}"
      ENV.append "LDFLAGS",  "-L#{Formula["readline"].opt_lib}"
    end

    if build.with? "gmpl"
      # Symphony uses a patched version of GLPK for reading MPL files.
      # Use a private version rather than require the Homebrew version of GLPK.
      cd "ThirdParty/Glpk" do
        system "./get.Glpk"
      end
      ENV.append "CPPFLAGS", "-I#{Formula["mysql"].opt_include}/mysql"
      args << "--with-gmpl"
    end

    if build.with? "openmp"
      args << "--enable-openmp"
      ENV.append "LDFLAGS", "-lgomp"
    end

    system "./configure", *args
    system "make"
    system "make", "test" if build.with? "test"
    ENV.deparallelize
    system "make", "install"

    (pkgshare/"Datasets").install "SYMPHONY/Datasets/sample.mps"
    (pkgshare/"Datasets").install "SYMPHONY/Datasets/sample.mod", "SYMPHONY/Datasets/sample.dat" if build.with? "gmpl"
  end

  test do
    system "#{bin}/symphony", "-F", "#{pkgshare}/Datasets/sample.mps"
    system "#{bin}/symphony", "-F", "#{pkgshare}/Datasets/sample.mod", "-D", "#{pkgshare}/Datasets/sample.dat" if build.with? "gmpl"
  end
end
