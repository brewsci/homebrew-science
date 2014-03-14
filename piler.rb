require "formula"

class Piler < Formula
  homepage "http://drive5.com/piler/"
  version "1.0"
  if OS.mac?
    url "http://drive5.com/piler/piler_pals_osx_src.tar.gz"
    sha1 "c9a614130b9e06ce12fee03464300fdfbc13d0bf"
  elsif OS.linux?
    url "http://drive5.com/piler/piler_source.tar.gz"
    sha1 "22d2efa728cbf1df306e723fcdc6ae68b8c05d38"
  else
    raise 'Unknown operating system'
  end

  depends_on 'muscle'

  def install
    cd (if OS.mac? then 'piler' else '.' end) do
      system "make", "CC=#{ENV.cc} -c", "GPP=#{ENV.cxx}"
      if OS.mac?
        bin.install "piler"
      else
        # Why is the executable named differently?
        bin.install "piler2" => "piler"
      end
    end
  end

  test do
    system "#{bin}/piler -version"
  end
end
