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
    SV* read(int len) {
        if (data.size() < len)
            len = data.size();
        SV* sv = newSV(0);
        char* buf = (char*)malloc( (len+1) * sizeof(uint8_t) );
        std::copy(data.begin(), data.begin() + len, buf);
        buf[len] = '\0';
        sv_usepvn_flags(sv, buf, len, SV_HAS_TRAILING_NUL);
        data.erase(data.begin(), data.begin() + len);
        return sv;
    }
    BinaryBuffer* read_buffer(int len) {
        if (data.size() < len)
            len = data.size();
        BinaryBuffer* new_buf = new BinaryBuffer();
        new_buf->data.insert(new_buf->data.end(), data.begin(), data.begin() + len);
        data.erase(data.begin(), data.begin() + len);
        return new_buf;
    }
    SV* read_uint8() {
        uint8_t val = data[0];
        data.pop_front();
        return newSVuv(val);
    }
    SV* read_int8() {
        int8_t val = data[0];
        data.pop_front();
        return newSViv(val);
    }
    SV* read_uint16be() {
        uint16_t val = ((uint16_t)data[1] << 8) | (uint16_t)data[0];
        data.erase(data.begin(), data.begin() + 2);
        return newSVuv(be16toh(val));
    }
    SV* read_uint16le() {
        uint16_t val = ((uint16_t)data[1] << 8) | (uint16_t)data[0];
        data.erase(data.begin(), data.begin() + 2);
        return newSVuv(le16toh(val));
    }
    SV* read_int16be() {
        int16_t val = ((int16_t)data[1] << 8) | (int16_t)data[0];
        data.erase(data.begin(), data.begin() + 2);
        return newSViv(be16toh(val));
    }
    SV* read_int16le() {
        int16_t val = ((int16_t)data[1] << 8) | (int16_t)data[0];
        data.erase(data.begin(), data.begin() + 2);
        return newSViv(le16toh(val));
    }
    SV* read_uint32be() {
        uint32_t val = ((uint32_t)data[3] << 24) | ((uint32_t)data[2] << 16) | ((uint32_t)data[1] << 8) | (uint32_t)data[0];
        data.erase(data.begin(), data.begin() + 4);
        return newSVuv(be32toh(val));
    }
    SV* read_uint32le() {
        uint32_t val = ((uint32_t)data[3] << 24) | ((uint32_t)data[2] << 16) | ((uint32_t)data[1] << 8) | (uint32_t)data[0];
        data.erase(data.begin(), data.begin() + 4);
        return newSVuv(le32toh(val));
    }
    SV* read_int32be() {
        int32_t val = ((int32_t)data[3] << 24) | ((int32_t)data[2] << 16) | ((int32_t)data[1] << 8) | (int32_t)data[0];
        data.erase(data.begin(), data.begin() + 4);
        return newSViv(be32toh(val));
    }
    SV* read_int32le() {
        int32_t val = ((int32_t)data[3] << 24) | ((int32_t)data[2] << 16) | ((int32_t)data[1] << 8) | (int32_t)data[0];
        data.erase(data.begin(), data.begin() + 4);
        return newSViv(le32toh(val));
    }
    
    void add(SV* sv) {
        STRLEN len;
        const char* src = SvPVbyte(sv, len);
        data.insert(data.end(),src,src+len);
    }
    void write_uint8(SV* sv) {
        uint8_t val = SvUV(sv);
        data.push_back(val);
    }
    void write_int8(SV* sv) {
        int8_t val = SvIV(sv);
        data.push_back(val);
    }
    void write_uint16be(SV* sv) {
        uint16_t val = htobe16((uint16_t)SvUV(sv));
        data.push_back(val & 0x00ff);
        data.push_back(val >> 8);
    }
    void write_uint16le(SV* sv) {
        uint16_t val = htole16((uint16_t)SvUV(sv));
        data.push_back(val & 0x00ff);
        data.push_back(val >> 8);
    }
    void write_int16be(SV* sv) {
        int16_t val = htobe16((int16_t)SvIV(sv));
        data.push_back(val & 0x00ff);
        data.push_back(val >> 8);
    }
    void write_int16le(SV* sv) {
        int16_t val = htole16((int16_t)SvIV(sv));
        data.push_back(val & 0x00ff);
        data.push_back(val >> 8);
    }
    void write_uint32be(SV* sv) {
        uint32_t val = htobe32((uint32_t)SvUV(sv));
        data.push_back(val & 0xff);
        data.push_back((val >> 8) & 0xff);
        data.push_back((val >> 16) & 0xff);
        data.push_back((val >> 24) & 0xff);
    }
    void write_uint32le(SV* sv) {
        uint32_t val = htole32((uint32_t)SvUV(sv));
        data.push_back(val & 0xff);
        data.push_back((val >> 8) & 0xff);
        data.push_back((val >> 16) & 0xff);
        data.push_back((val >> 24) & 0xff);
    }
    void write_int32be(SV* sv) {
        int32_t val = htobe32((int32_t)SvIV(sv));
        data.push_back(val & 0xff);
        data.push_back((val >> 8) & 0xff);
        data.push_back((val >> 16) & 0xff);
        data.push_back((val >> 24) & 0xff);
    }
    void write_int32le(SV* sv) {
        int32_t val = htole32((int32_t)SvIV(sv));
        data.push_back(val & 0xff);
        data.push_back((val >> 8) & 0xff);
        data.push_back((val >> 16) & 0xff);
        data.push_back((val >> 24) & 0xff);
    }

private:
    std::deque<uint8_t> data;
};


#endif /* __BINARY_BUFFER_H__ */
