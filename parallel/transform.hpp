#ifndef PARALLEL_TRANSFORM_HPP__
#define PARALLEL_TRANSFORM_HPP__

#include <boost/range/algorithm/transform.hpp>

#include <future>

namespace projectnamespace { namespace parallel {

// Taken from C++ Concurrency In Action, Chapter 8, Listing 8.8
template <typename RangeType, typename OutputIterator, typename UnaryOperation>
void transform(
    RangeType rng,
    OutputIterator outIter, 
    UnaryOperation f, 
    boost::uint32_t numThreads,
    boost::uint32_t minPerThread)
{
    if (numThreads == 1u)
    {
        boost::transform(rng, outIter, f);
        return;
    }
    const std::size_t length(boost::distance(rng));

    if (!length)
    {
        return;
    }
    
    if (length < (2 * minPerThread))
    {
        boost::transform(rng, outIter, f);
        return;
    }
    else
    {
        typedef typename RangeType::iterator iterator_type;

        auto first = boost::begin(rng);

        iterator_type const midPoint = first + (length / 2);
        std::future<void> firstHalf = std::async(
            &transform<RangeType, OutputIterator, UnaryOperation>,
            RangeType(first, midPoint),
            outIter,
            f,
            numThreads / 2, 
            minPerThread);

        OutputIterator newOutIter = outIter + (length / 2);

        transform<RangeType, OutputIterator, UnaryOperation>(
            RangeType(midPoint, boost::end(rng)), 
            newOutIter, 
            f, 
            numThreads - (numThreads / 2),
            minPerThread);

        firstHalf.get();
    }
}

}} // namespace projectnamespace { namespace parallel {

#endif // PARALLEL_TRANSFORM_HPP__
