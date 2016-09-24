class Symphony < Formula
  homepage "http://www.coin-or.org/projects/SYMPHONY.xml"
  url "http://www.coin-or.org/download/source/SYMPHONY/SYMPHONY-5.6.6.tgz"
  sha256 "af28afff326635b04ac47857af648244704af0b0743c9a9acd6da0b6b2b60bfb"

  bottle do
    sha256 "f04fc061bc7a9482ed88057fee10ad75de10e5ec3412b19ca6d15a40f3e8fd28" => :yosemite
    sha256 "82ac8295c28e5a87f9ce8661ad04426971adc6ebd44f53487fab45446429af46" => :mavericks
    sha256 "9696eb5df65c0f53cb2336949488d431e38d06e0ea2160b052b7d427e0be4f0b" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"
  option "with-openmp", "Enable openmp support"
  option "with-gmpl", "GNU Modeling Language support via GLPK"

  depends_on "mysql" => :build if build.with? "gmpl"
  depends_on "readline" => :recommended

  conflicts_with "coinutils", :because => "Symphony contains CoinUtils"
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
    system "make", "test" if build.with? "check"
    ENV.deparallelize
    system "make", "install"

    (share / "symphony/Datasets").install "SYMPHONY/Datasets/sample.mps"
    (share / "symphony/Datasets").install "SYMPHONY/Datasets/sample.mod", "SYMPHONY/Datasets/sample.dat" if build.with? "gmpl"
  end

  test do
    system "#{bin}/symphony", "-F", "#{share}/symphony/Datasets/sample.mps"
    system "#{bin}/symphony", "-F", "#{share}/symphony/Datasets/sample.mod", "-D", "#{share}/symphony/Datasets/sample.dat" if build.with? "gmpl"
  end
end
