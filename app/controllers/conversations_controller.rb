class ConversationsController < ApplicationController
  def show
    @conversation = Conversation.find_or_create_by(id: params[:id])
  end

  def generate_llm_response(conversation, text)
    conversational_context = build_conversation_context(conversation)
    Sublayer::Generators::ConversationalResponseGenerator.new(conversation_context: conversational_context, latest_request: text).generate
  end

  def send_text_message
    @conversation = Conversation.find(params[:id])
    message_text = params[:message]

    response = process_text_message(@conversation, message_text)

    @conversation.messages.create(content: message_text, role: 'user')
    @conversation.messages.create(content: response, role: 'assistant')

    redirect_to @conversation
  end

  private

  def process_text_message(conversation, message)
    text = message
    conversational_context = @conversation.messages.map { |message| {role: message.role, content: message.content} }
    # Generate conversational response
    # output_text = Sublayer::Generators::ConversationalResponseGenerator.new(conversation_context: conversational_context, latest_request: text).generate
    Sublayer::Generators::ConversationalResponseGenerator.new(conversation_context: conversational_context, latest_request: text).generate
  end

  def build_conversation_context(conversation)
    conversation.messages.map do |msg|
      "#{msg.role.capitalize}: #{msg.content}"
    end.join("\n")
  end
end
