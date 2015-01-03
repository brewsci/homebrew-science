require 'formula'

class Arpack < Formula
  homepage 'http://forge.scilab.org/index.php/p/arpack-ng'
  url 'http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/arpack-ng_3.1.4.tar.gz'
  sha1 '1fb817346619b04d8fcdc958060cc0eab2c73c6f'
  head 'git://git.forge.scilab.org/arpack-ng.git'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "cbcd37dbf0f4df4246a4907a229ec28550119b7f" => :yosemite
    sha1 "9d088970dd26ec2d286cfff275b7fac56aa044d6" => :mavericks
    sha1 "35aeeb9c44095e0c6af0add7454eb6532964d161" => :mountain_lion
  end

  depends_on :fortran
  depends_on :mpi => [:optional, :f77]
  depends_on "openblas" => :optional
  depends_on "veclibfort" if build.without? "openblas" and OS.mac?

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = ["--disable-dependency-tracking", "--prefix=#{libexec}"]
    args << "--enable-mpi" if build.with? :mpi
    if build.with? "openblas"
      args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas"
    elsif OS.mac?
      args << "--with-blas=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    else
      args << "--with-blas=-lblas -llapack"
    end

    if build.with? :mpi
      ENV['CC']  = "mpicc"
      ENV['CXX'] = "mpic++"
      ENV['F77'] = "mpif77"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/'pkgconfig').install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    (libexec/"share").install "TESTS/testA.mtx"
  end

  test do
    cd libexec/"share" do
      ["dnsimp", "bug_1323"].each do |slv|
        system "#{libexec}/bin/#{slv}"              # Reads testA.mtx
      end
    end
  end
end
