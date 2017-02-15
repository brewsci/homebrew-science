class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.10/matio-1.5.10.tar.gz"
  sha256 "41209918cebd8cc87a4aa815fed553610911be558f027aee54af8b599c78b501"

  bottle do
    cellar :any
    sha256 "65febf628ca9bd6a04f060f8279d5abd568daf9e1b17ec84dbfa8ee3825d7fff" => :sierra
    sha256 "3062b7b996e230517d31621c97815f83e9b0adce3adc466c88a68caa9878479f" => :el_capitan
    sha256 "0a42d84e71a5a47036b6e7fa6ae1dccc6fc1d5ec9bfb8c696e162192a2c9605e" => :yosemite
  end

  option "with-hdf5", "Enable support for newer MAT files that use the HDF5-format"

  depends_on "hdf5" => :optional

  # sample MATLAB file from http://web.uvic.ca/~monahana/eos225/matlab_tutorial/tutorial_5/working_with_data.html
  resource "test_mat_file" do
    url "http://web.uvic.ca/~monahana/eos225/poc_data.mat.sfx"
    sha256 "a29df222605476dcfa660597a7805176d7cb6e6c60413a3e487b62b6dbf8e6fe"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib=/usr
      --enable-extended-sparse=yes
    ]

    if build.with? "hdf5"
      args << "--with-hdf5=#{HOMEBREW_PREFIX}" << "--enable-mat73=yes"
    else
      args << "--with-hdf5=no"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("test_mat_file")
    mv "poc_data.mat.sfx", "test.mat"
    (testpath/"not-a-mat-file.mat").write("Not a mat file\n")
    (testpath/"mat.c").write <<-'EOS'.undent
      #include <stdlib.h>
      #include <stdio.h>
      #include <matio.h>
      #include <errno.h>
      int main(int argc, char **argv)
      {
        mat_t *matfp;
        errno = 0;
        matfp = Mat_Open(argv[1], MAT_ACC_RDONLY);
        if (NULL == matfp) {
          printf("errno %d", errno);
          return EXIT_FAILURE;
        }
        printf("errno %d", errno);
        Mat_Close(matfp);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "mat.c", "-o", "mat", "-I#{include}", "-L#{lib}", "-lmatio"
    assert_equal "errno 2", shell_output("./mat no-such-file.mat", 1)
    assert_equal "errno 0", shell_output("./mat not-a-mat-file.mat", 1)
    assert_equal "errno 0", shell_output("./mat test.mat")
  end
end
