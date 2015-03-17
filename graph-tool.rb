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

  depends_on "pkg-config" => :build
  depends_on "boost" => cxx11
  depends_on "cairomm" => cxx11 if build.with? "cairo"
  depends_on "cgal" => cxx11
  depends_on "google-sparsehash" => cxx11 + [:recommended]
  depends_on "gtk+3" => :optional
  depends_on "librsvg" => "with-gtk+3" if build.with? "gtk+3"
  depends_on :python => :recommended
  depends_on :python3 => :optional


  if build.with? "python3"
    depends_on "boost-python" => cxx11 + ["with-python3"]
    depends_on "py3cairo" if build.with? "cairo"
    depends_on "pygobject3" => "with-python3" if build.with? "gtk+3"
    depends_on "matplotlib" => :python3
    depends_on "numpy" => :python3
    depends_on "scipy" => :python3
  elsif build.with? "python"
    depends_on "boost-python" => cxx11
    depends_on "py2cairo" if build.with? "cairo"
    depends_on "pygobject3" if build.with? "gtk+3"
    depends_on "matplotlib" => :python
    depends_on "numpy" => :python
    depends_on "scipy" => :python
  end

  def install
    ENV.cxx11

    config_args = %W(
      --disable-debug
      --disable-dependency-tracking
      --disable-optimization
      --prefix=#{prefix}
    )

    if build.with? "python3"
      xy = Language::Python.major_minor_version "python3"
      config_args << "PYTHON=python3"
      config_args << "LDFLAGS=-L#{`python3-config --prefix`.chomp}/lib"
      config_args << "--with-python-module-path=#{lib}/python#{xy}/site-packages"
    else
      config_args << "--with-python-module-path=#{lib}/python2.7/site-packages"
    end

    config_args << "--disable-cairo" if build.without? "cairo"
    config_args << "--disable-sparsehash" if build.without? "google-sparsehash"

    system "./autogen.sh" if build.head?
    system "./configure", "PYTHON_EXTRA_LDFLAGS=-L#{HOMEBREW_PREFIX}/bin", *config_args
    system "make", "install"
  end

  test do
    Pathname("test.py").write <<-EOS.undent
      import graph_tool.all as gt
      g = gt.Graph()
      v1 = g.add_vertex()
      v2 = g.add_vertex()
      e = g.add_edge(v1, v2)
    EOS
    Language::Python.each_python(build) { |python, _version| system python, "test.py" }
  end
end
