require "formula"

class Smrtanalysis < Formula
  homepage "http://www.pacb.com/devnet/"
  # doi "10.1038/nmeth.2474"
  url "https://s3.amazonaws.com/files.pacb.com/software/smrtanalysis/2.2.0/smrtanalysis-2.2.0.133377.run"
  sha1 "b64cdeb68f84f021ccaeffaa62ec5977029451af"

  # Patch
  # https://s3.amazonaws.com/files.pacb.com/software/smrtanalysis/2.2.0/smrtanalysis-2.2.0.133377-patch-1.run

  def install
    raise "SMRT Analysis cannot be installed on Mac OS" if OS.mac?
    system "sh ./smrtanalysis-#{version}.run --extract-only --rootdir #{prefix}"
  end

  test do
    system "#{prefix}/install/smrtanalysis-2.2.0.133377/analysis/bin/blasr"
  end
end
