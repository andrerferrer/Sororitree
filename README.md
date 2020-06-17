## A História
A equipe do Sororitree batch #354 estava com um bug no chat porque o style da mensagem depende se o user é o current_user ou não.

Para facilitar, chamarei os usuários de ENVIADOR e RECEPTOR.

O problema é que quando ocorre o render da mensagem, o current_user na [view](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message.html.erb) é o ENVIADOR.

Então, quando ocorre o broadcast pelo `JS`, o RECEPTOR recebe uma view preparada para o ENVIADOR.

## A Solução (?)

Pensando nisso, pensei como [solução estabelecer uma lógica no JS](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js) que é a seguinte:
- Receber uma string pelo broadcast
- Fazer o parse dela em JSON
- descobrir qual o nickname do usuário com o qual estou conversando no momento (`como-testar-1` abaixo)
- SE o nickname que veio no JSON for o nickname do ENVIADOR, insere a mensagem no DOM do browser do RECEPTOR

Resumindo:
O [controller](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/controllers/messages_controller.rb) faz um render do [JSON](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message_broadcasted.json.erb) que, por sua vez, renderiza um [HTML.ERB](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message_broadcasted.html.erb).

Esse JSON é recebido como uma string no channel e o broadcast é recebido seguindo [essa lógica](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js).

## Problemas (a ser resolvido)

Fazer o `JSON.parse()` no [chatroom_channel.js](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js) se revelou muito complicado porque qualquer pequena alteração no HTML faz esse parse quebrar.

e.g.

No app/views/messages/_message_broadcasted.html.erb, precisamos usar single quotes para HTML attributes (class, id etc) ou o `JSON.parse()` quebra.

Além disso, se a mensagem for escrita em uma linha, o parse funciona. Se escrita em duas, o parse quebra:
- enviar "hello world" no chat nao quebra;
- enviar "hello \n world", quebra


## Etc

### Casos similares

Só achei esse, não resolvido

- https://www.reddit.com/r/rails/comments/5nquwr/rails_action_cable_and_current_user/

### como-testar-1
```
bundle install
yarn install
rails db:drop db:create db:migrate db:seed
rails s
```

Acesse `http://localhost:3000/chatrooms/1` com o login `Alexia`/`123456`
Acesse `http://localhost:3000/chatrooms/1` em uma aba anônima com o login `Fabiola`/`123456`

Envie uma mensagem de uma para outra.
