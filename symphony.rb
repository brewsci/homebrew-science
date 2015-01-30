require 'formula'

class Symphony < Formula
  homepage 'http://www.coin-or.org/projects/SYMPHONY.xml'
  url 'http://www.coin-or.org/download/source/SYMPHONY/SYMPHONY-5.6.6.tgz'
  sha1 'be97382f63e31ea8b8d6ff428f85abbadca414c0'

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

    system "./configure",  *args
    system "make"
    system "make", "test" if build.with? "check"
    ENV.deparallelize
    system "make install"

    (share / "symphony/Datasets").install "SYMPHONY/Datasets/sample.mps"
    (share / "symphony/Datasets").install "SYMPHONY/Datasets/sample.mod", "SYMPHONY/Datasets/sample.dat" if build.with? "gmpl"
  end

  test do
    system "#{bin}/symphony", "-F", "#{share}/symphony/Datasets/sample.mps"
    system "#{bin}/symphony", "-F", "#{share}/symphony/Datasets/sample.mod", "-D", "#{share}/symphony/Datasets/sample.dat" if build.with? "gmpl"
  end
end
