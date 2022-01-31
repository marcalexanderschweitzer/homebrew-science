 class Mytestpack < Formula
  desc ""
  homepage "https://www.paraview.org/"
  url "https://github.com/marcalexanderschweitzer/homebrew-science/blob/master/Formula/mytestpack-1.0.tar.gz?raw=true"
  sha256 "e08f7ebb1318bffe4ec250c7d73591cae279fd6c767e6ad0349274d3186b6aed"

  depends_on "cmake"

def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING:BOOL=OFF
      ]

      mkdir "build" do
        system "cmake", "..", *args
        system "make"
        # system "make install"
        bin.install "test_solver" => "mysolver"
    end

    #   bin.install_symlink "mysolver"
    end
end