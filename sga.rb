require 'formula'

class Sga < Formula
  homepage 'https://github.com/jts/sga'
  url 'https://github.com/jts/sga/tarball/v0.9.37'
  sha1 '7bd04b2001e03dcd959215a4dd6a0fe2bbd3ff89'

  # Currently deactivated due to "undeclared identifier omp_set_num_threads"
  # head 'https://github.com/jts/sga.git'

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
