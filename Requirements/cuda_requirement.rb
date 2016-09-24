require "requirement"

class CudaRequirement < Requirement
  fatal true
  cask "cuda"

  def initialize(tags)
    @version = tags.shift if /\d+\.*\d*/ === tags.first
    super
  end

  satisfy :build_env => false do
    next false unless which "nvcc"
    next true unless @version
    cuda_version = /\d\.\d/.match Utils.popen_read("nvcc", "-V")
    Version.new(cuda_version.to_s) >= Version.new(@version)
  end

  env do
    ENV.append "CFLAGS", "-F/Library/Frameworks"
    nvccdir = which("nvcc").dirname
    ENV.prepend_path "PATH", nvccdir
    ENV.prepend_create_path "DYLD_LIBRARY_PATH", nvccdir.parent/"lib"
    ENV["CUDACC"] = "nvcc"
  end

  def message
    if @version
      s = "CUDA #{@version} or later is required."
    else
      s = "CUDA is required."
    end
    s += <<-EOS.undent
      To use this formula with NVIDIA graphics cards you will need to
      download and install the CUDA drivers and tools from nvidia.com.

          https://developer.nvidia.com/cuda-downloads

      Select "Mac OS" as the Operating System and then select the
      'Developer Drivers for MacOS' package.
      You will also need to download and install the 'CUDA Toolkit' package.

      The `nvcc` has to be in your PATH then (which is normally the case).

    EOS
    s += super
    s
  end

  def inspect
    "#<#{self.class.name}: #{name.inspect} #{tags.inspect} version=#{@version.inspect}>"
  end
end
