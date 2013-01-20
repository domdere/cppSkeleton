SET ( sampleBinaryProjectSources
    main.cpp )

ADD_EXECUTABLE ( sampleBinaryProject
    ${sampleBinaryProjectSources} )

# any third party libs that need to be present for linking,
# or any other lib targets within the main project that need to be built
# and linked in.
TARGET_LINK_LIBRARIES ( sampleBinaryProject
    ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY} )
