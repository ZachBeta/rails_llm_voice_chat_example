c = Conversation.last
puts c.messages.map { |m| "#{m.role}: #{m.content}" }
