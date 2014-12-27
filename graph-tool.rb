require "formula"

class GraphTool < Formula
  homepage "http://graph-tool.skewed.de/"
  url "http://downloads.skewed.de/graph-tool/graph-tool-2.2.35.tar.bz2"
  sha1 "f75a31dec45843beff18eb6b5ce8eda5a0645277"
  head "https://github.com/count0/graph-tool.git"
  revision 1

  option "without-cairo", "Build without cairo support"

  depends_on :python => :recommended
  depends_on :python3 => :optional

  depends_on "pkg-config" => :build
  depends_on "cgal" => "c++11"
  depends_on "google-sparsehash" => ["c++11", :recommended]
  depends_on "cairomm" => "c++11" if build.with? "cairo"
  depends_on "boost" => "c++11"
  if build.head?
    depends_on "autoconf"
    depends_on "automake"
    depends_on "libtool"
  end

  if build.with? "python3"
    depends_on "boost-python" => ["c++11", "with-python3"]
    depends_on "py3cairo" if build.with? "cairo"
    depends_on "matplotlib" => :python3
    depends_on "numpy" => :python3
    depends_on "scipy" => :python3
  elsif build.with? "python"
    depends_on "boost-python" => ["c++11", "with-python"]
    depends_on "py2cairo" if build.with? "cairo"
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
      config_args << "PYTHON=python3"
      config_args << "LDFLAGS=-L#{`python3-config --prefix`.chomp}/lib"
      config_args << "--with-python-module-path=#{lib}/python3.4/site-packages"
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
