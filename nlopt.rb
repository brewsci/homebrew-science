require "formula"

class Nlopt < Formula
  homepage 'http://ab-initio.mit.edu/nlopt'
  url 'http://ab-initio.mit.edu/nlopt/nlopt-2.4.1.tar.gz'
  sha1 '181181a3f7dd052e0740771994eb107bd59886ad'
  head 'https://github.com/stevengj/nlopt.git'

  depends_on 'octave' => :optional
  depends_on :python => ['numpy', :optional]

  def install
    ENV.deparallelize
    args = ["--with-cxx", "--enable-shared", "--prefix=#{prefix}"]
    args += ["--without-octave"] if build.without? "octave"
    args += ["--without-python"] if build.without? :python
    if build.with? 'octave'
      ENV['OCT_INSTALL_DIR'] = share/'nlopt/oct'
      ENV['M_INSTALL_DIR'] = share/'nlopt/m'
      ENV['MKOCTFILE'] = "#{Formula["octave"].bin}/mkoctfile"
    end
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    s = ''
    if build.with? 'octave'
      s += <<-EOS.undent
      Please add
        #{share}/nlopt/oct
      and
        #{share}/nlopt/m
      to the Octave path.
      EOS
    end
    if build.with? :python
      python_version = `python-config --libs`.match('-lpython(\d+\.\d+)').captures.at(0)
      s += <<-EOS.undent
      Please add
        #{lib}/python#{python_version}/site-packages
      to the Python path.
      EOS
    end
    return s
  end
end
