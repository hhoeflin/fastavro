import io

lorem_ipsum=b"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."

cdef struct ByteReader:
    const char* data
    long pos
    long length

cdef inline char read_byte(ByteReader* br):
    cdef char c = br.data[br.pos]
    br.pos += 1
    return c

cdef inline const char* read_bytes(ByteReader* br, long num):
    br.pos += num
    return br.data + (br.pos - num)

cdef int count_ls_cdef(const char* s, int s_len):
    cdef int count = 0
    cdef int i = 0
    for i in range(s_len):
        if s[i] == b'l':
            count += 1
    return count

cdef int count_ls_bytereader(ByteReader br):
    cdef int count = 0
    while br.pos < br.length:
        if read_bytes(&br, 1)[0] == b'l':
            count += 1
    return count

cdef int count_ls_bytereader_single(ByteReader br):
    cdef int count = 0
    while br.pos < br.length:
        if read_byte(&br) == b'l':
            count += 1
    return count

cdef int count_ls_bytesio(fo) except? -1:
    cdef bytes c = fo.read(1)
    cdef int count = 0

    while c:
        if <unsigned char>(c[0]) == b'l':
            count += 1
        c = fo.read(1)
    return count



def py_count_ls_cdef(s: bytes):
    return count_ls_cdef(s, len(s))

def py_count_ls_bytereader(s: bytes):
    return count_ls_bytereader(ByteReader(s, 0, len(s)))

def py_count_ls_bytereader_single(s: bytes):
    return count_ls_bytereader_single(ByteReader(s, 0, len(s)))

def py_count_ls_bytesio(s: bytes):
    return count_ls_bytesio(io.BytesIO(s))
