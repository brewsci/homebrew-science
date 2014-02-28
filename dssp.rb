require 'formula'

class Dssp < Formula
  homepage 'http://swift.cmbi.ru.nl/gv/dssp/'
  url 'ftp://ftp.cmbi.ru.nl/pub/software/dssp/dssp-2.1.0.tgz'
  sha1 'ac943f49e2bdce73b3523434ec811857e50d82a2'

  depends_on 'boost'

  def install
    # Create a make.config file that contains the configuration for boost
    boost = Formula["boost"].opt_prefix
    File.open('make.config', 'w') do |makeconf|
      makeconf.puts "BOOST_LIB_SUFFIX = -mt"
      makeconf.puts "BOOST_LIB_DIR = #{boost / 'lib'}"
      makeconf.puts "BOOST_INC_DIR = #{boost / 'include'}"
    end

    # There is no need for the build to be static and static build causes
    # an error: ld: library not found for -lcrt0.o
    inreplace 'makefile' do |s|
      s.gsub! /-static/, ''
    end

    # The makefile ask for g++ as a compiler but that causes a error at link
    # time: ld: library not found for -lgcc_ext.10.5
    system "make", "install", "DEST_DIR=#{prefix}", "MAN_DIR=#{man1}", "CXX=c++"
  end

  test do
    system 'mkdssp --version'
  end
end
