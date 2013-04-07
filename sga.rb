require 'formula'

class Sga < Formula
  homepage 'https://github.com/jts/sga'
  url 'https://github.com/jts/sga/archive/v0.9.42.tar.gz'
  sha1 '99b2de74edc70c8c7d945374490f06777bd9eab7'
  head 'https://github.com/jts/sga.git'

  depends_on :autoconf => :build
  depends_on :automake => :build
  # Only header files are used, so :build is appropriate
  depends_on 'google-sparsehash' => :build
  depends_on 'bamtools'

  def install
    cd 'src' do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-bamtools=#{Formula.factory('bamtools').opt_prefix}",
                            "--with-sparsehash=#{Formula.factory('google-sparsehash').opt_prefix}/header"
      system "make install"
    end
  end

  test do
    system "#{bin}/sga", "--version"
  end
end
