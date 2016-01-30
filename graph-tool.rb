class GraphTool < Formula
  homepage "http://graph-tool.skewed.de/"
  url "http://downloads.skewed.de/graph-tool/graph-tool-2.12.tar.bz2"
  sha256 "ac5fdd65cdedb568302d302b453fe142b875f23e3500fe814a73c88db49993a9"
  revision 1

  stable do
    # Commits to subgraph_isomorphism which are required for the last patch
    patch do
      url "https://git.skewed.de/count0/graph-tool/commit/ca2b8d110353e7ba4e105ca7afff4229f7dd61a1.diff"
      sha256 "6c5a27fe386f0424cad553bc2b6dcbe1ccb2d4e9f8c759702799ab901eb8dc36"
    end

    patch do
      url "https://git.skewed.de/count0/graph-tool/commit/24a16870bb9b4be1408416b1fa04b9ed013a4871.diff"
      sha256 "456247297df4a7db7ffa696bbd6cee3ab3a6ffa7e20dbd1a2058336efa33a782"
    end

    # Fixes build with boost 1.60
    patch do
      url "https://git.skewed.de/count0/graph-tool/commit/248b086187808d0bbda27bde8a1efe12a15bddaa.diff"
      sha256 "cd706ba200441243f8ae6301403dbdf23d3b1e29ac327288b47d65001952250e"
    end
  end

  head do
    url "https://git.skewed.de/count0/graph-tool.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    sha256 "1403a9699ab147da134b39d4cc3b64cd1a49be1d7d9b5941a842f87f5b9132b6" => :el_capitan
    sha256 "c0259303a55befb147a40d60e58e283d2b9774d5a52b9d7f13b8eacc8e0d063f" => :yosemite
    sha256 "7f2ecc68e838a493bcfe533b36c94d1e2b7dc90bd03ea0e1453f94bc1d80ef11" => :mavericks
  end

  option "without-cairo", "Build without cairo support for plotting"
  option "without-gtk+3", "Build without gtk+3 support for interactive plotting"
  option "without-matplotlib", "Use a matplotlib you've installed yourself instead of a Homebrew-packaged matplotlib"
  option "without-numpy", "Use a numpy you've installed yourself instead of a Homebrew-packaged numpy"
  option "without-python", "Build without python2 support"
  option "without-scipy", "Use a scipy you've installed yourself instead of a Homebrew-packaged scipy"

  cxx11 = MacOS.version < :mavericks ? ["c++11"] : []
  with_pythons = build.with?("python3") ? ["with-python3"] : []

  depends_on "pkg-config" => :build
  depends_on "boost" => cxx11
  depends_on "boost-python" => cxx11 + with_pythons
  depends_on "cairomm" if build.with? "cairo"
  depends_on "cgal" => cxx11
  depends_on "google-sparsehash" => cxx11 + [:recommended]
  depends_on "gtk+3" => :recommended
  depends_on :python3 => :optional

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
    build 601  # the highest build version for which compilation will fail
    cause "graph-tool must be compiled in c++14 mode"
  end

  fails_with :gcc
  fails_with :gcc => "4.8" do
    cause "graph-tool must be compiled in c++14 mode"
  end

  def install
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
