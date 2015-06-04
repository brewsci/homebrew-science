class Bcalm < Formula
  desc "de Bruijn CompAction in Low Memory"
  homepage "https://github.com/Malfoy/bcalm"
  # tag "bioinformatics"

  url "https://github.com/Malfoy/bcalm/archive/1.tar.gz"
  sha256 "95901fbb748b7fc0fff26d3c638adc9f10343d21db5ca3ad0f71882d073a74de"

  head "https://github.com/Malfoy/bcalm.git"

  def install
    ENV.libcxx
    system "make"
    bin.install "bcalm"
    doc.install "README.md"
  end

  test do
    # Currently segfaults with no input file: https://github.com/Malfoy/bcalm/issues/1
    # No input file to test on yet: https://github.com/Malfoy/bcalm/issues/2
  end
end
