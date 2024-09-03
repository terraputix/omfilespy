import Foundation
import SwiftPFor2D

@_cdecl("om_read_float_array")
func readOmFile(from file: UnsafePointer<CChar>, into buffer: UnsafeMutablePointer<Float>, dim0Start: Int, dim0End: Int, dim1Start: Int, dim1End: Int) {
    let fileString = String.init(cString: file)
    guard let read = try? OmFileReader(file: fileString) else {
        fatalError("could not open file")
    }
    guard var data = try? read.read(dim0Slow: dim0Start..<dim0End, dim1: dim1Start..<dim1End) else {
        fatalError("could not read data")
    }

    buffer.initialize(from: &data, count: data.count)
}

@_cdecl("om_hello_from_swift")
func hello_from_swift() -> Float {
    return 0
}