#ifndef __BINARY_BUFFER_H__
#define __BINARY_BUFFER_H__

#include <algorithm>
#include <deque>

#if defined(__GLIBC__)
    #include <endian.h>
#else
    #error "Can't find hto* and *toh functions on host system";
#endif

class BinaryBuffer {
public:
    BinaryBuffer() :  data() { }
    ~BinaryBuffer() { }

    int size() const { return data.size(); }
    int read(char* buf, int len) {
        if (data.size() < len)
            len = data.size();
        std::copy(data.begin(), data.begin() + len, buf);
        data.erase(data.begin(), data.begin() + len);
        return len;
    }
    BinaryBuffer* read_buffer(int len) {
        if (data.size() < len)
            len = data.size();
        BinaryBuffer* new_buf = new BinaryBuffer();
        new_buf->data.insert(new_buf->data.end(), data.begin(), data.begin() + len);
        data.erase(data.begin(), data.begin() + len);
        return new_buf;
    }
    uint8_t read_uint8() {
        uint8_t val = data[0];
        data.pop_front();
        return val;
    }
    int8_t read_int8() {
        int8_t val = data[0];
        data.pop_front();
        return val;
    }
    uint16_t read_uint16be() {
        uint16_t val = ((uint16_t)data[1] << 8) | (uint16_t)data[0];
        data.erase(data.begin(), data.begin() + 2);
        return be16toh(val);
    }
    uint16_t read_uint16le() {
        uint16_t val = ((uint16_t)data[1] << 8) | (uint16_t)data[0];
        data.erase(data.begin(), data.begin() + 2);
        return le16toh(val);
    }
    int16_t read_int16be() {
        int16_t val = ((int16_t)data[1] << 8) | (int16_t)data[0];
        data.erase(data.begin(), data.begin() + 2);
        return be16toh(val);
    }
    int16_t read_int16le() {
        int16_t val = ((int16_t)data[1] << 8) | (int16_t)data[0];
        data.erase(data.begin(), data.begin() + 2);
        return le16toh(val);
    }
    uint32_t read_uint32be() {
        uint32_t val = ((uint32_t)data[3] << 24) | ((uint32_t)data[2] << 16) | ((uint32_t)data[1] << 8) | (uint32_t)data[0];
        data.erase(data.begin(), data.begin() + 4);
        return be32toh(val);
    }
    uint32_t read_uint32le() {
        uint32_t val = ((uint32_t)data[3] << 24) | ((uint32_t)data[2] << 16) | ((uint32_t)data[1] << 8) | (uint32_t)data[0];
        data.erase(data.begin(), data.begin() + 4);
        return le32toh(val);
    }
    int32_t read_int32be() {
        int32_t val = ((int32_t)data[3] << 24) | ((int32_t)data[2] << 16) | ((int32_t)data[1] << 8) | (int32_t)data[0];
        data.erase(data.begin(), data.begin() + 4);
        return be32toh(val);
    }
    int32_t read_int32le() {
        int32_t val = ((int32_t)data[3] << 24) | ((int32_t)data[2] << 16) | ((int32_t)data[1] << 8) | (int32_t)data[0];
        data.erase(data.begin(), data.begin() + 4);
        return le32toh(val);
    }
    
    void add(const char* src, int len) {
        data.insert(data.end(),src,src+len);
    }
    void write_uint8(uint8_t val) { data.push_back(val); }
    void write_int8(int8_t val) { data.push_back(val); }
    void write_uint16be(uint16_t val) {
        val = htobe16(val);
        data.push_back(val & 0x00ff);
        data.push_back(val >> 8);
    }
    void write_uint16le(uint16_t val) {
        val = htole16(val);
        data.push_back(val & 0x00ff);
        data.push_back(val >> 8);
    }
    void write_int16be(int16_t val) {
        val = htobe16(val);
        data.push_back(val & 0x00ff);
        data.push_back(val >> 8);
    }
    void write_int16le(int16_t val) {
        val = htole16(val);
        data.push_back(val & 0x00ff);
        data.push_back(val >> 8);
    }
    void write_uint32be(uint32_t val) {
        val = htobe32(val);
        data.push_back(val & 0xff);
        data.push_back((val >> 8) & 0xff);
        data.push_back((val >> 16) & 0xff);
        data.push_back((val >> 24) & 0xff);
    }
    void write_uint32le(uint32_t val) {
        val = htole32(val);
        data.push_back(val & 0xff);
        data.push_back((val >> 8) & 0xff);
        data.push_back((val >> 16) & 0xff);
        data.push_back((val >> 24) & 0xff);
    }
    void write_int32be(int32_t val) {
        val = htobe32(val);
        data.push_back(val & 0xff);
        data.push_back((val >> 8) & 0xff);
        data.push_back((val >> 16) & 0xff);
        data.push_back((val >> 24) & 0xff);
    }
    void write_int32le(int32_t val) {
        val = htole32(val);
        data.push_back(val & 0xff);
        data.push_back((val >> 8) & 0xff);
        data.push_back((val >> 16) & 0xff);
        data.push_back((val >> 24) & 0xff);
    }

private:
    std::deque<uint8_t> data;
};


#endif /* __BINARY_BUFFER_H__ */
