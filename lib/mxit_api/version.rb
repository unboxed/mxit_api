class MxitApi
  module Version
    MAJOR = 0
    MINOR = 2
    PATCH = 2
    BUILD = 'pre'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end