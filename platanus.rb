class Platanus < Formula
  homepage "http://platanus.bio.titech.ac.jp/platanus-assembler/"
  # doi "10.1101/gr.170720.113"
  # tag "bioinformatics"

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
      gcclib = gccformula.opt_lib/"gcc/5"
      system "install_name_tool -change /opt/local/lib/libstdc++.6.dylib #{gcclib}/libstdc++.6.dylib platanus"
      system "install_name_tool -change /opt/local/lib/gcc48/libgomp.1.dylib #{gcclib}/libgomp.1.dylib platanus"
      system "install_name_tool -change /opt/local/lib/gcc48/libgcc_s.1.dylib #{gcclib}/libgcc_s.1.dylib platanus"
    end
    bin.install "platanus"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/platanus 2>&1", 1)
  end
end
