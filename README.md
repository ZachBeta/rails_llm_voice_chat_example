# README

A Rails app that allows users to have an audio conversation with an LLM using
OpenAI's Speech to Text, Text to Speech APIs and gpt-4-turbo.

# done
* run this as a pair programming buddy
* add text views of conversation messages
* improve performance of query
  * attempted, seems to only work on fresh refresh
* messages in scrollable frame
* set up a git remote repo
* allow a text form based message
* switch this to be record on press, stop on press rather than on hold
* save the transcript
* process
  * [x] skip the voice response, but do keep the LLM request
  * voice is ok actually, it only summarizes at end of meeting
  * pass the result to a prompt, allow the prompt to be edited?
    * it's ok to have it hard coded for now in ruby land

# now
* fix text message version - needs full context so far
* allow better markdown to UI rendering
* improve prompt to summarize with text from 

* sublayer does not appear to be working how I had hoped it would

# next
* rolling transcription
* make the chat app respond to last 2 messages
  * create another generator with a slightly different prompt?
* Implement assistant-to-assistant responses
* voice chat broke? doesn't display prompt
* Set up multiple GPT personalities
* Create a dropdown setting to switch between endpoints
* Implement a conversation flow between two different GPTs
* Add a visual indicator for which GPT is speaking
* Implement error handling for API failures

# soon
* Check balance on personal account OpenAI key
* Implement rate limiting to prevent excessive API usage
* Add user authentication and individual API key management
* Create a dashboard for conversation history and analytics

