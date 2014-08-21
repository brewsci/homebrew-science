require "formula"

class Platanus < Formula
  homepage "http://platanus.bio.titech.ac.jp/platanus-assembler/"
  #doi "10.1101/gr.170720.113"

  version "1.2.1"
  if OS.mac?
    url "http://platanus.bio.titech.ac.jp/Platanus_release/20140423010201/platanus.macOSX"
    sha1 "efeca85a45cbc802c7c0ff4771f83e14889b31e8"
  elsif OS.linux?
    url "http://platanus.bio.titech.ac.jp/Platanus_release/20130901010201/platanus"
    sha1 "be6e0a8aaf89b017f70a2bc1e0acc292fb03511d"
  end

  depends_on "gcc" if OS.mac?

  def install
    if OS.mac?
      mv "platanus.macOSX", "platanus"

      # Fix the dependent shared library install names.
      gccformula = Formula["gcc"]
      gcc = gccformula.opt_lib/"gcc/x86_64-apple-darwin13.2.0"/gccformula.version
      system "install_name_tool -change /opt/local/lib/libstdc++.6.dylib #{gcc}/libstdc++.6.dylib platanus"
      system "install_name_tool -change /opt/local/lib/gcc48/libgomp.1.dylib #{gcc}/libgomp.1.dylib platanus"
      system "install_name_tool -change /opt/local/lib/gcc48/libgcc_s.1.dylib #{gcc}/libgcc_s.1.dylib platanus"
    end
    bin.install "platanus"
  end

  test do
    system "#{bin}/platanus 2>&1 |grep platanus"
  end
end
