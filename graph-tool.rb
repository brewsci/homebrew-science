require 'formula'

class GraphTool < Formula
  homepage 'http://graph-tool.skewed.de/'
  url 'http://downloads.skewed.de/graph-tool/graph-tool-2.2.29.1.tar.bz2'
  sha1 '1cf735e3379548b7140ad10f7791ff1e929d40e1'
  head 'https://github.com/count0/graph-tool.git'

  depends_on 'pkg-config' => :build
  depends_on 'boost' => 'c++11'
  depends_on 'cgal' => 'c++11'
  depends_on 'google-sparsehash' => ['c++11', :optional]
  depends_on 'cairomm' => 'c++11'
  depends_on 'py2cairo'
  depends_on 'matplotlib' => :python
  depends_on 'numpy' => :python
  depends_on 'scipy' => :python

  def install
    ENV.cxx11
    config_args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-python-module-path=#{lib}/python2.7/site-packages
    ]
    config_args << "--disable-sparsehash" if build.without? 'google-sparsehash'
    system "./configure", "PYTHON_EXTRA_LDFLAGS= ", *config_args
    system "make", "install"
  end

end
