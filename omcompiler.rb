class Omcompiler < Formula
  desc "Modelica compiler translating Modelica to C code"
  homepage "https://www.openmodelica.org"
  url "https://github.com/OpenModelica/OMCompiler.git",
      :tag => "v1.9.6",
      :revision => "d3c35c90b382998275f42eb5da05c0f25e6b63a8"

  bottle do
    sha256 "f0f61fb5c79d1ec1262abbd705752612cd06bb702d8ec43ac7529893dd3f37b2" => :sierra
    sha256 "8f90e485a4f2b477d6cb3ec75a907698c0825f753de76e7664bc5a4dd8729a44" => :el_capitan
    sha256 "290c67df15a0e1eea8913c07ffeac6f5dcce01c1d0505fd91a9a7e4d9ff3ebae" => :yosemite
  end

  # Build dependencies
  depends_on "autoconf"     => :build
  depends_on "automake"     => :build
  depends_on "cmake"        => :build
  depends_on "libtool"      => :build
  depends_on "pkg-config"   => :build
  depends_on "gnu-sed"      => :build
  depends_on "xz"           => :build

  # Essential dependencies
  depends_on :fortran
  depends_on "lp_solve"
  depends_on "hwloc"
  depends_on "gettext"

  # Optional dependencies
  depends_on "boost"    => :optional
  depends_on "sundials" => :optional

  def install
    # The '-r' option seems to be missing. Without it the build process will
    # fail trying to copy a directory.
    inreplace "Makefile.common", "# Shared data\n\tcp -p",
                                 "# Shared data\n\tcp -rp"

    system "autoconf"

    args = ["--disable-debug"]
    args << "--disable-dependency-tracking"
    args << "--disable-silent-rules"
    args << "--prefix=#{prefix}"
    args << "--with-cppruntime" if build.with? "boost"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    # Define the Van der Pol equation as a simple model. Translate it to C code
    # (with 'omc'), compile the C code and execute the resulting program.
    str = "
        model VanDerPol  \"Van der Pol oscillator model\"
            Real x(start = 1);
            Real y(start = 1);
            parameter Real lambda = 0.3;
        equation
            der(x) = y;
            der(y) = - x + lambda*(1 - x*x)*y;
        end VanDerPol;
    "
    (testpath/"VanDerPol.mo").write str
    system "#{bin}/omc", "-s", "VanDerPol.mo"
    system "make", "-f", "VanDerPol.makefile"
    system "./VanDerPol"
  end
end
