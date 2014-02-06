require 'formula'

class Fasta < Formula
  homepage 'http://faculty.virginia.edu/wrpearson/fasta/'
  url 'http://faculty.virginia.edu/wrpearson/fasta/fasta36/fasta-36.3.6d.tar.gz'
  sha1 '54e08a52de4e11600600c224fbd341eb668d3b0a'

  def install
    cd 'src' do
      system 'make', '-f', case RUBY_PLATFORM.downcase
        when /darwin/
          '../make/Makefile.os_x86_64'
        when /linux/
          '../make/Makefile.linux64_sse2'
        else
          raise "The system `#{`uname`.chomp}' is not supported."
      end
    end
    bin.install Dir['bin/*']
    doc.install Dir['doc/*']
  end

  test do
    system "#{bin}/fasta36"
  end
end
