require 'formula'

class GraphTool < Formula
  homepage 'http://graph-tool.skewed.de/'
  url 'http://downloads.skewed.de/graph-tool/graph-tool-2.2.31.tar.bz2'
  sha1 '5e0b1c215ecd76191a82c745df0fac17e33bfb09'
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
      --disable-optimization
      --prefix=#{prefix}
      --with-python-module-path=#{lib}/python2.7/site-packages
    ]
    config_args << "--disable-sparsehash" if build.without? 'google-sparsehash'
    system "./configure", "PYTHON_EXTRA_LDFLAGS= ", *config_args
    system "make", "install"
  end

end
