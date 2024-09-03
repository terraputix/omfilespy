import omfilespy as om
import numpy.testing as npt


def test_om_hello_from_swift():
    assert om.om_hello_from_swift() == 0


def test_read_om_float():
    file = "test_file.om"
    read_data = om.readOmFile(file, 0, 5, 0, 5)
    npt.assert_array_equal(
        read_data,
        [
            0.0,
            1.0,
            2.0,
            3.0,
            4.0,
            5.0,
            6.0,
            7.0,
            8.0,
            9.0,
            10.0,
            11.0,
            12.0,
            13.0,
            14.0,
            15.0,
            16.0,
            17.0,
            18.0,
            19.0,
            20.0,
            21.0,
            22.0,
            23.0,
            24.0,
        ],
    )
