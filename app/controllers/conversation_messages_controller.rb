require "tempfile"
require "pry"
require "json"

class ConversationMessagesController < ApplicationController
  include ActionView::RecordIdentifier

  def clear
    session[:conversation_context] = nil

    render json: {message: "Conversation context cleared"}
  end

  def create
    @conversation = Conversation.find(params[:conversation_id])

    # Convert conversational context to an easy to use format
    conversational_context = @conversation.messages.map { |message| {role: message.role, content: message.content} }

    # Convert audio data to text
    text = Sublayer::Actions::SpeechToTextAction.new(params[:audio_data]).call

    # Generate conversational response
    output_text = Sublayer::Generators::ConversationalResponseGenerator.new(conversation_context: conversational_context, latest_request: text).generate

    # Convert text to audio data
    speech = Sublayer::Actions::TextToSpeechAction.new(output_text).call

    # Create and broadcast new messages
    user_message = @conversation.messages.create(role: "user", content: text)
    assistant_message = @conversation.messages.create(role: "assistant", content: output_text)

    broadcast_new_message(user_message)
    broadcast_new_message(assistant_message)

    send_data speech, type: "audio/wav", disposition: "inline"
  end

  private

  def broadcast_new_message(message)
    Turbo::StreamsChannel.broadcast_append_to(
      @conversation,
      target: "conversation_messages",
      partial: "messages/message",
      locals: { message: message }
    )
  end
end
