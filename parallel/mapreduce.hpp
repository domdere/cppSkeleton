#ifndef PARALLEL_MAPREDUCE_HPP__
#define PARALLEL_MAPREDUCE_HPP__

#include <boost/range/algorithm/transform.hpp>

#include <algorithm>
#include <future>

namespace projectnamespace { namespace parallel {

// A slight modification of the parallel transform that includes a summarise/reduce step
// using an "Accumulator" instead of an "OutputIterator" that has iterator behaviour,
// as well as monoid properties so that results from the other threads can be compiled
// while and the answer will be the same as if the summary/accumulation had taken place in one
// thread.
template <typename InputIterator, typename MonoidAccumulator, typename UnaryOperation>
MonoidAccumulator mapreduce(
    InputIterator begin,
    InputIterator end,
    MonoidAccumulator zero, // pass in the zero instance for the monoid 
    UnaryOperation f, 
    boost::uint32_t numThreads,
    boost::uint32_t minPerThread)
{
    if (numThreads == 1u)
    {
        return std::transform(begin, end, zero, f);
    }

    const std::size_t length(std::distance(begin, end));

    if (!length)
    {
        return zero;
    }
    
    if (length < (2 * minPerThread))
    {
        return std::transform(begin, end, zero, f);
    }
    else
    {
        typedef InputIterator iterator_type;

        const auto firstThreadHalf = numThreads / 2;
        const auto secondThreadHalf = numThreads - firstThreadHalf;

        iterator_type const midPoint = begin + (length / 2);
        std::future<MonoidAccumulator> secondHalf = std::async(
            std::launch::async,
            &mapreduce<InputIterator, MonoidAccumulator, UnaryOperation>,
            midPoint,
            end,
            zero,
            f,
            secondThreadHalf, 
            minPerThread);

        const auto firstResult = mapreduce<InputIterator, MonoidAccumulator, UnaryOperation>(
            begin,
            midPoint,
            zero, 
            f, 
            firstThreadHalf,
            minPerThread);

        return firstResult + secondHalf.get();
    }
}

template <typename RangeType, typename MonoidAccumulator, typename UnaryOperation>
MonoidAccumulator mapreduce(
    const RangeType& rng,
    MonoidAccumulator zero, // pass in the zero instance for the monoid 
    UnaryOperation f, 
    boost::uint32_t numThreads,
    boost::uint32_t minPerThread)
{
    return mapreduce(
        boost::begin(rng), 
        boost::end(rng),
        zero,
        f,
        numThreads,
        minPerThread);
}

}} // namespace projectnamespace { namespace parallel {

#endif // PARALLEL_MAPREDUCE_HPP__
