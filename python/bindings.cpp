#include <pybind11/numpy.h>
#include <pybind11/pybind11.h>

namespace py = pybind11;

// C++ wrapper for the Swift function
extern "C"
{
  float om_hello_from_swift(); // Declaration of the Swift function

  // void om_read_float_array(const char* file, float* into, int dim0Start,
  //                          int dim0End, int dim1Start, int dim1End);
}

// py::array_t<float> readOmFile(const std::string &file, int dim0Start,
//                               int dim0End, int dim1Start, int dim1End)
// {
//   int buffer_size = (dim0End - dim0Start) * (dim1End - dim1Start);
//   // create a new buffer pointer where we can write the output from swift
//   float *buffer = new float[buffer_size];

//   // Call the extern C function and get the array of floats
//   om_read_float_array(file.c_str(), buffer, dim0Start, dim0End, dim1Start,
//                       dim1End);
//   // convert the buffer to a pybind array to return it
//   // Create a pybind11 buffer_info object to describe the buffer
//   py::buffer_info buf_info(
//       buffer,                                 /* Pointer to buffer */
//       sizeof(float),                          /* Size of one scalar */
//       py::format_descriptor<float>::format(), /* Python struct-style format
//                                                  descriptor */
//       1,                                      /* Number of dimensions */
//       {buffer_size},                          /* Buffer dimensions */
//       {sizeof(float)}                         /* Strides (in bytes)
//                                                  for each index */
//   );

//   // Create a pybind11 array from the buffer_info
//   py::array_t<float> result(buf_info);

//   // Don't forget to free the memory!
//   delete[] buffer;

//   return result;
// };

PYBIND11_MODULE(bindings, m)
{
  m.doc() = "pybind11 om-files swift bindings"; // optional module docstring

  m.def("om_hello_from_swift", &om_hello_from_swift,
        "A function that does not add two numbers");

  // m.def("om_read_float_array", &om_read_float_array,
  // "Read Float array from an om file");

  // m.def("readOmFile", &readOmFile, "Read Float array from an om file");
}
