require 'formula'

class Fasta < Formula
  homepage 'http://faculty.virginia.edu/wrpearson/fasta/'
  url 'http://faculty.virginia.edu/wrpearson/fasta/CURRENT/fasta-36.3.5e.tar.gz'
  sha1 'a75cab8d7db3c79904293617a33bab10d95d342c'

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
