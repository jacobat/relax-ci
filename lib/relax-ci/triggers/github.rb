module RelaxCI
  module Triggers
    class Github
      def initialize(bus)
        @bus = bus
      end

      def trigger(payload)
        url = if payload['repository']['private']
                payload['repository']['ssh_url']
              else
                payload['repository']['git_url']
              end
        @bus.send_message(
          {
            type: 'PostCommitHookFired',
            repos_url: url,
            ref: payload['ref'],
            commit: payload['after'],
            author_name: payload['head_commit']['author']['name'],
            author_email: payload['head_commit']['author']['email']
          }
        )
      end
    end
  end
end
