class GraphTool < Formula
  desc "efficient network analysis"
  homepage "http://graph-tool.skewed.de/"

  stable do
    url "https://downloads.skewed.de/graph-tool/graph-tool-2.19.tar.bz2"
    sha256 "eba1090f94b0434890beedaf0c100dd0fc77e41ebfe29b4725d76cadb82099af"
  end

  bottle do
    sha256 "548cec02e9b37106c208c85f16e906ce3cc60a81b47eda960eff53515140651f" => :sierra
    sha256 "aae2cca7b0edaec413d5de47b3d4167cea96bab364da051a0d07b33ee9de3315" => :el_capitan
    sha256 "6a434696db83d434f244e2f50606c953d60af4a8c4a2ea7c741fb20765397a7f" => :yosemite
  end

  head do
    url "https://git.skewed.de/count0/graph-tool.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-cairo", "Build without cairo support for plotting"
  option "without-gtk+3", "Build without gtk+3 support for interactive plotting"
  option "without-matplotlib", "Use a matplotlib you've installed yourself instead of a Homebrew-packaged matplotlib"
  option "without-numpy", "Use a numpy you've installed yourself instead of a Homebrew-packaged numpy"
  option "without-python", "Build without python2 support"
  option "without-scipy", "Use a scipy you've installed yourself instead of a Homebrew-packaged scipy"
  option "with-openmp", "Enable OpenMP multithreading"

  cxx11 = MacOS.version < :mavericks ? ["c++11"] : []

  depends_on :python3 => :optional
  with_pythons = build.with?("python3") ? ["with-python3"] : []

  depends_on "pkg-config" => :build
  depends_on "boost" => cxx11
  depends_on "boost-python" => cxx11 + with_pythons
  depends_on "cairomm" if build.with? "cairo"
  depends_on "cgal" => cxx11
  depends_on "google-sparsehash" => cxx11 + [:recommended]
  depends_on "gtk+3" => :recommended

  depends_on "homebrew/python/numpy" => [:recommended] + with_pythons
  depends_on "homebrew/python/scipy" => [:recommended] + with_pythons
  depends_on "homebrew/python/matplotlib" => [:recommended] + with_pythons

  if build.with? "cairo"
    depends_on "py2cairo" if build.with? "python"
    depends_on "py3cairo" if build.with? "python3"
  end

  if build.with? "gtk+3"
    depends_on "gnome-icon-theme"
    depends_on "librsvg" => "with-gtk+3"
    depends_on "pygobject3" => with_pythons
  end

  # We need a compiler with C++14 support.
  fails_with :llvm

  fails_with :clang do
    cause "Older versions of clang have buggy c++14 support."
    build 699
  end

  fails_with :gcc => "4.8" do
    cause "We need GCC 5.0 or above for sufficient c++14 support"
  end
  fails_with :gcc => "4.9" do
    cause "We need GCC 5.0 or above for sufficient c++14 support"
  end

  if MacOS.version == :mavericks
    fails_with :gcc => "6" do
      cause "GCC 6 fails with 'Internal compiler error' on Mavericks. You should install GCC 5 instead with 'brew tap homebrew/versions; brew install gcc5"
    end
  end

  needs :openmp if build.with? "openmp"

  def install
    if MacOS.version == :mavericks && (Tab.for_name("boost").stdlib == "libcxx" || Tab.for_name("boost-python").stdlib == "libcxx")
      odie "boost and boost-python must be built against libstdc++ on Mavericks. One way to achieve this, is to use GCC to compile both libraries."
    end

    system "./autogen.sh" if build.head?

    config_args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    # fix issue with boost + gcc with C++11/C++14
    ENV.append "CXXFLAGS", "-fext-numeric-literals" unless ENV.compiler == :clang
    config_args << "--disable-cairo" if build.without? "cairo"
    config_args << "--disable-sparsehash" if build.without? "google-sparsehash"
    config_args << "--enable-openmp" if build.with? "openmp"

    Language::Python.each_python(build) do |python, version|
      config_args_x = ["PYTHON=#{python}"]
      if OS.mac?
        config_args_x << "PYTHON_LDFLAGS=-undefined dynamic_lookup"
        config_args_x << "PYTHON_EXTRA_LDFLAGS=-undefined dynamic_lookup"
      end
      config_args_x << "--with-python-module-path=#{lib}/python#{version}/site-packages"

      if python == "python3"
        inreplace "configure", "libboost_python", "libboost_python3"
        inreplace "configure", "ax_python_lib=boost_python", "ax_python_lib=boost_python3"
      end

      mkdir "build-#{python}-#{version}" do
        system "../configure", *(config_args + config_args_x)
        system "make", "install"
      end
    end
  end

  test do
    Pathname("test.py").write <<-EOS.undent
      import graph_tool.all as gt
      g = gt.Graph()
      v1 = g.add_vertex()
      v2 = g.add_vertex()
      e = g.add_edge(v1, v2)
    EOS
    Language::Python.each_python(build) { |python, _| system python, "test.py" }
  end
end
