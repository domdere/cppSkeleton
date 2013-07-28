#include "commonUtils/monoid.hpp"

namespace projectnamespace { namespace commonutils { namespace accumulators {

template <typename T>
class MonoidSum
{
public:
    typedef std::output_iterator_tag iterator_category;
    typedef T value_type;
    typedef T& reference;
    typedef T difference_type;
    typedef T* pointer;

    MonoidSum(T initialValue)
    :
        mSum(initialValue)
    {}

    T& operator*()
    {
        return mTemp;
    }

    MonoidSum<T>& operator++()
    {
        mSum += mTemp;
        return *this;
    }

    MonoidSum<T> operator+(const MonoidSum<T>& other) const
    {
        return MonoidSum<T>(mSum + other.mSum);
    }

    T GetResult() const
    {
        return mSum;
    }

private:
    T mTemp;
    T mSum;
};

}}} // namespace projectnamespace { namespace commonutils { namespace accumulators {
