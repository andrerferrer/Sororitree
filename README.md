## The Story
The Sororitree team on batch #354 had a bug in the chat because the style of the message depends on whether the user is the current_user or not.

To make it easier, I will call the users SENDER and RECEIVER.

The problem is that when the message rendering occurs, the `current_user` in this [view](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message.html.erb) is the SENDER.

Therefore, when [broadcast by JS](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js) occurs, the RECEPTOR receives a view prepared for the SENDER. 

So, since we have a style for the SENDER message and another for the RECEIVER, it get weird until you reload the page.

You can check this weird behavior here:
[Video](https://imgur.com/0pu8Nv9)


## The Solution (?)

Thinking about it, I thought of a solution: [to establish a logic in JS](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js) which is the following:
- Receive a string on the broadcast
- Making it be parsed in JSON
- Find out what user nickname I am currently talking to ([How to test?](https://github.com/andrerferrer/Sororitree/tree/chatroom-correct-design#como-testar) below)
- IF the nickname that came in the JSON is the VENDOR's nickname, insert the message in the DOM of the RECEPTOR's browser

Bottom line:
The [controller](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/controllers/messages_controller.rb) renders a [JSON](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message_broadcasted.json.erb) which in turn renders a [HTML.ERB](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message_broadcasted.html.erb).

This JSON is received as a string on the channel and the broadcast is received following [this logic](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js).

## The Problems (to be solved)

Making `JSON.parse()` on [chatroom_channel.js](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js) proved to be very complicated because any small change in the HTML makes this parsing break.

e.g.

1. In the [partial view of the message](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message_broadcasted.html.erb), we need to use _single quotes_ for HTML attributes (class, id etc) or the `JSON.parse()` will break.

2. Also, if the message is written on one line, the parse works. If written in two, the parse breaks:
    - sending "hello world" in chat doesn't break;
    - send "hello\nworld," breaks.

Is there a better way to solve this challenge? 🤔

## How to test?

### How to test the solution?
Clone this repo and go to the `chatroom-correct-design` branch
```
git clone git@github.com:andrerferrer/Sororitree.git
git checkout chatroom-correct-design
```

```
bundle install
yarn install
rails db:drop db:create db:migrate db:seed
rails s
```

Acess `http://localhost:3000/chatrooms/1` and login as `Alexia`/`123456`
Access `http://localhost:3000/chatrooms/1` in an anonymous tab with the login `Fabiola`/`123456`

### How to test the error?

After the previous setup, you can check the error on this commit
`git checkout 5ea2e2ff2780bd5b9b37a8cb81c420f121229aa9`

[Video with the previous error](https://imgur.com/0pu8Nv9)


## Related cases

I could only find this one, unsolved

- https://www.reddit.com/r/rails/comments/5nquwr/rails_action_cable_and_current_user/
