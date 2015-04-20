class Dwgsim < Formula
  homepage "https://github.com/nh13/DWGSIM"
  url "https://github.com/nh13/DWGSIM.git",
    :tag => "dwgsim.0.1.11",
    :revision => "49aa199775e0d8bc1fee79aec7117a7fde8cb2bf"
  head "https://github.com/nh13/DWGSIM.git"

  def install
    system "make"
    bin.install "dwgsim", "dwgsim_eval"
  end

  test do
    assert shell_output("#{bin}/dwgsim -h 2>&1", 1).include?(version.to_s)
  end
end
