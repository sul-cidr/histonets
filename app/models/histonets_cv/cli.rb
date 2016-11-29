# frozen_string_literal: true

module HistonetsCv
  ##
  # Ruby class to invoke Python cli application
  class Cli
    include ActiveSupport::Benchmarkable

    delegate :logger, to: :Rails

    def help
      execute('--help')
    end

    def version
      execute('--version')
    end

    private

    def execute(command)
      benchmark("Histonet excecuted #{command}") do
        `histonets #{command}`
      end
    end
  end
end
