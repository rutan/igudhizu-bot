
require 'ruboty'

module Ruboty
  module Handlers
    class Help < Base
      def help(_); end
    end

    class Ping < Base
      def ping(_); end
    end

    class Whoami < Base
      def whoami(_); end
    end
  end
end
