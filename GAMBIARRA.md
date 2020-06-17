# É feinho mas resolve rs

1. criar uma partial view só pra mensagem a ser enviada

app/views/messages/_message_broadcasted.html.erb
```erb
<div class="message-container d-flex justify-content-end">
  <div class="message-guest" id="message-<%= message.id %>">
    <div class="py-1 px-3">
      <div class="author">
        <small><%= message.created_at.strftime("%b %e às %H:%M") %></small>
        <span><%= message.user.nickname %></span>
      </div>
      <div>
        <p><%= message.content %></p>
      </div>
    </div>
  </div>
</div>
```

2. usar essa partial no controller

app/controllers/messages_controller.rb

```ruby
ChatroomChannel.broadcast_to(@chatroom, render_to_string(partial: '_message_broadcasted', locals: {message: @message}))
```

3. Resolver o problema usando o JS
app/javascript/channels/chatroom_channel.js

```js
received(data) {
        const guestName = document.querySelector('.chat-title').innerText;
        if (data.includes(guestName)) {
          messagesContainer.insertAdjacentHTML('beforeend', data);
          scrollLastMessageIntoView();
        };
      },
```