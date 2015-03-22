class GraphTool < Formula
  homepage "http://graph-tool.skewed.de/"
  url "http://downloads.skewed.de/graph-tool/graph-tool-2.2.35.tar.bz2"
  sha1 "f75a31dec45843beff18eb6b5ce8eda5a0645277"
  revision 1

  head do
    url "https://github.com/count0/graph-tool.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-cairo", "Build without cairo support for plotting"
  option "with-gtk+3", "Build with gtk+3 support for interactive plotting"

  cxx11 = MacOS.version < :mavericks ? ["c++11"] : []
  with_pythons = build.with?("python3") ? ["with-python3"] : []

  depends_on "pkg-config" => :build
  depends_on "boost" => cxx11
  depends_on "cairomm" => cxx11 if build.with? "cairo"
  depends_on "cgal" => cxx11
  depends_on "google-sparsehash" => cxx11 + [:recommended]
  depends_on "gtk+3" => :optional
  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on "boost-python" => cxx11 + with_pythons

  if build.with? "gtk+3"
    depends_on "gnome-icon-theme"
    depends_on "librsvg" => "with-gtk+3"
    depends_on "pygobject3" => with_pythons
  end

  if build.with? "python"
    depends_on "py2cairo" if build.with? "cairo"
    depends_on "matplotlib" => :python
    depends_on "numpy" => :python
    depends_on "scipy" => :python
  end

  if build.with? "python3"
    depends_on "py3cairo" if build.with? "cairo"
    depends_on "matplotlib" => :python3
    depends_on "numpy" => :python3
    depends_on "scipy" => :python3
  end

  def install
    ENV.cxx11

    system "./autogen.sh" if build.head?

    config_args = %W(
      --disable-debug
      --disable-dependency-tracking
      --disable-optimization
      --prefix=#{prefix}
    )

    config_args << "--disable-cairo" if build.without? "cairo"
    config_args << "--disable-sparsehash" if build.without? "google-sparsehash"

    Language::Python.each_python(build) do |python, version|
      config_args_x = ["PYTHON=#{python}"]
      config_args_x << "PYTHON_EXTRA_LDFLAGS=#{`#{python}-config --ldflags`.chomp}"
      config_args_x << "--with-python-module-path=#{lib}/python#{version}/site-packages"

      if python == "python3"
        inreplace "configure", "libboost_python", "libboost_python3"
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
