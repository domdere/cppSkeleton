#ifndef SINGLETON_HPP__
#define SINGLETON_HPP__

namespace projectnamespace { namespace commonutils {

template<class T>
class Singleton
{
private:
    static T* s_pInstance;

public:

    Singleton()
    : m_Singleton(false)
    {
        s_pInstance = static_cast<T*>(this);
        m_Singleton = true;
    }

    Singleton(bool makeSingleton)
    : m_Singleton(false)
    {
        if (makeSingleton)
        {
            s_pInstance = static_cast<T*>(this);
            m_Singleton = true;
        }

        return;
    }

    virtual ~Singleton()
    {
        if (m_Singleton)
        {
            s_pInstance = NULL;
        }
    }

    static T* GetInstance()
    {
        return s_pInstance;
    }

private:

    // sometimes you want to create another instance
    // without replacing the singleton instance.
    bool m_Singleton;
}

#define SINGLETON_INSTANCE(CLASS) class CLASS; template<> CLASS *commonutils::Singleton<CLASS>::s_pInstance = NULL;

}}

#endif // SINGLETON_HPP__
