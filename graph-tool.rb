class GraphTool < Formula
  homepage "http://graph-tool.skewed.de/"
  url "http://downloads.skewed.de/graph-tool/graph-tool-2.7.tar.bz2"
  sha256 "c71ab0056c27d0d5b4f92d58d8d3ad019ef535da822b54898459a09b119449e1"

  bottle do
    sha256 "8d9ec4a8eff050f3eb65c66318e1a74d9ba2e68185f393f59a5577bb6e2325b0" => :yosemite
    sha256 "9e9b87d27858a52dce599d2f6956072a4c68d8853b182ecb1b4fe143c718311e" => :mavericks
    sha256 "713daa0e2ec965e6cde55bc4086d94c3bd1a051ba800cb3eee0588c6310af167" => :mountain_lion
  end

  head do
    url "https://github.com/count0/graph-tool.git"
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

  cxx11 = MacOS.version < :mavericks ? ["c++11"] : []
  with_pythons = build.with?("python3") ? ["with-python3"] : []

  depends_on "pkg-config" => :build
  depends_on "boost" => cxx11
  depends_on "boost-python" => cxx11 + with_pythons
  depends_on "cairomm" => cxx11 if build.with? "cairo"
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

  def install
    ENV.cxx11

    system "./autogen.sh" if build.head?

    config_args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-optimization
      --prefix=#{prefix}
    ]

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
