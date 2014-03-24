require 'formula'

class Arpack < Formula
  homepage 'http://forge.scilab.org/index.php/p/arpack-ng'
  url 'http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/arpack-ng_3.1.4.tar.gz'
  sha1 '1fb817346619b04d8fcdc958060cc0eab2c73c6f'
  head 'git://git.forge.scilab.org/arpack-ng.git'

  depends_on :fortran
  depends_on :mpi => [:optional, :f77]
  depends_on 'openblas' => :optional

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = ['--disable-dependency-tracking', "--prefix=#{libexec}"]
    args << '--enable-mpi' if build.with? :mpi
    if build.with? 'openblas'
      args << "--with-blas=-L#{Formula["openblas"].lib} -lopenblas"
    else
      # We're using the -ff2c flag here to avoid having to depend on dotwrp.
      # Because arpack exports only subroutines, the resulting library is
      # compatible with packages compiled with or without the -ff2c flag.
      args << "--with-blas=-framework vecLib"
      ENV['FFLAGS'] = '-ff2c'
    end

    ENV['MPILIBS'] = '-lmpi_usempi -lmpi_mpifh -lmpi' if build.with? :mpi
    system './configure', *args
    system 'make'
    system 'make', 'install'
    lib.install_symlink Dir["#{libexec}/lib/*"]
    (libexec/'share').install 'TESTS/testA.mtx'
  end

  def test
    cd libexec/'share' do
      ['dnsimp', 'bug_1323'].each do |slv|
        system "#{libexec}/bin/#{slv}"              # Reads testA.mtx
      end
    end
  end
end
