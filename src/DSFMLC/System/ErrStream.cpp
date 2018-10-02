#include <DSFMLC/System/ErrStream.hpp>

ErrStream::ErrStream()
{
    //set the size to be BUFFER_SIZE-1 to more easily handle overflow character
    setp(m_buffer, m_buffer+BUFFER_SIZE-1);
}

void ErrStream::setWriteFunc(void (*writeFunc)(const char* str, int size))
{
    m_writeFunc = writeFunc;
}

ErrStream::int_type ErrStream::overflow(int_type ch)
{
    *pptr() = ch;
    pbump(1);
    write();
    return ch;
}

int ErrStream::sync()
{
    write();
    return 0;
}

void ErrStream:: write()
{
    std::ptrdiff_t size = pptr() - pbase();
    pbump(-size);
    m_writeFunc(m_buffer, size);
}