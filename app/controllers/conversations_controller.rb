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
    conversational_context = build_conversation_context(conversation)
    # Generate conversational response
    # output_text = Sublayer::Generators::ConversationalResponseGenerator.new(conversation_context: conversational_context, latest_request: text).generate
    Sublayer::Generators::ConversationalResponseGenerator.new(conversation_context: conversational_context, latest_request: text).generate
  end

  def build_conversation_context(conversation)
    conversation_messages =conversation.messages.map do |msg|
      "#{msg.role.capitalize}: #{msg.content}"
    end.join("\n")
    conversation_messages += "\n\n" + summary_prompt
  end

  def summary_prompt
    <<-PROMPT
      headers for each person
      and markdown checklist -[ ] style for each task
      give a short title for the task
      give a couple short descriptive statements as subpoints per bullet list item task
      maybe ordered list would be more useful so we can discuss
      so all lists ordered lists under headers for each person name used in conversation
    PROMPT
  end
end
