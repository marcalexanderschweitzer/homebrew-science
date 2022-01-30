 class Paraview < Formula
  desc ""
  homepage "https://www.paraview.org/"
  url "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.10&type=source&os=Sources&downloadFile=ParaView-v5.10.0.tar.xz"
  # url "https://www.paraview.org/paraview-downloads/ParaView-v5.10.0.tar.xz"
  sha256 "86d85fcbec395cdbc8e1301208d7c76d8f48b15dc6b967ffbbaeee31242343a5"

  depends_on "cmake"
  depends_on "ninja"
  depends_on "gcc"
  depends_on "open-mpi"
  depends_on "ffmpeg"
  depends_on "python@3.9"
  depends_on "qt@5"
  depends_on "hdf5-mpi"
  depends_on "openblas"
  depends_on "eigen"
  depends_on "boost"

patch do
  url "https://github.com/marcalexanderschweitzer/homebrew-science/blob/master/Formula/my_patch_iossvtk_mpi_paraview_5.10.0.patch?raw=true"
  sha256 "d5347d4fda2926c1af3b52f4d31775dfa47948d89342554a291c91b28755d2a6"
end
  
def install
    args = std_cmake_args + %W[
      -G Ninja 
      -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
      -DCMAKE_INSTALL_NAME_DIR:PATH=#{opt_lib}
      -DCMAKE_INSTALL_RPATH:PATH=#{rpath}
      -DCMAKE_Fortran_COMPILER:STRING=gfortran 
      -DQt5_DIR:PATH=/usr/local/opt/qt@5/lib/cmake/Qt5 
      -DBUILD_TESTING:BOOL=OFF 
      -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=ON 
      -DPARAVIEW_USE_MPI:BOOL=ON 
      -DPARAVIEW_USE_PYTHON:BOOL=ON 
      -DPython3_EXECUTABLE:FILEPATH=#{Formula["python@3.9"].opt_bin}/python3
      -DPython3_INCLUDE_DIRS:PATH=/usr/local/Frameworks/Python.framework/Versions/Current/include 
      -DPython3_LIBRARY:FILEPATH=/usr/local/Frameworks/Python.framework/Versions/Current/lib/libpython3.9.dylib
      -DPARAVIEW_ENABLE_XDMF3:BOOL=ON 
      -DPARAVIEW_ENABLE_FFMPEG:BOOL=ON 
      -DVTK_FORBID_DOWNLOADS:BOOL=ON 
      -DVTK_MODULE_USE_EXTERNAL_ParaView_protobuf:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_ParaView_cgns:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_utf8:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_doubleconversion:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_lz4:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_pugixml:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_jsoncpp:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_libharu:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_glew:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_ogg:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_theora:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_gl2ps:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_libxml2:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_lzma:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_tiff:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_netcdf:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_expat:BOOL=ON 
      -DVTK_MODULE_USE_EXTERNAL_VTK_eigen:BOOL=ON 
      -DVTK_MODULE_USE_EXTERNAL_VTK_freetype:BOOL=OFF 
      -DVTK_MODULE_USE_EXTERNAL_VTK_hdf5:BOOL=ON 
      -DVTK_MODULE_USE_EXTERNAL_VTK_mpi4py:BOOL=ON 
      -DVTK_MODULE_USE_EXTERNAL_VTK_jpeg:BOOL=ON 
      -DVTK_MODULE_USE_EXTERNAL_VTK_png:BOOL=ON 
      -DVTK_MODULE_USE_EXTERNAL_VTK_zlib:BOOL=ON 
      -DHDF5_NO_FIND_PACKAGE_CONFIG_FILE:BOOL=ON
      ]

      mkdir "build" do
        system "cmake", "..", *args
        system "ninja install"
      end
  end
end