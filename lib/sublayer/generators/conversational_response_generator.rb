module Sublayer
  module Generators
    class ConversationalResponseGenerator < Base
      llm_output_adapter type: :single_string,
        name: "response_text",
        description: "The response to the full conversation context and latest request from the user"

      def initialize(conversation_context:, latest_request:)
        @conversation_context = conversation_context
        @latest_request = latest_request
      end

      def generate
        puts "=" * 100
        puts "Generating response for conversation context: \n #{@conversation_context}"
        puts "Latest request: \n #{@latest_request}"
        puts "=" * 100
        super
      end

      private

      def prompt
        <<-PROMPT
          #{@conversational_context}
          #{@latest_request}
        PROMPT
      end
    end
  end
end
