#include <boost/cstdint.hpp>

namespace projectnamespace { namespace commonutils { namespace monoid {

template <typename T>
struct monoid_traits
{
public:
    static T zero()
    {
        return T::zero();
    }

    static T append(const T& x, const T& y)
    {
        return x.append(y);
    }
};

template <>
struct monoid_traits<boost::uint32_t>
{
public:
    static boost::uint32_t zero()
    {
        return 0u;
    }

    inline static boost::uint32_t append(
        boost::uint32_t x,
        boost::uint32_t y)
    {
        return x + y;
    }
};

}}} // namespace projectnamespace { namespace commonutils { namespace monoid {
