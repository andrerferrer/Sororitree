## A História
A equipe do Sororitree batch #354 estava com um bug no chat porque o style da mensagem depende se o user é o current_user ou não.

Para facilitar, chamarei os usuários de ENVIADOR e RECEPTOR.

O problema é que quando ocorre o render da mensagem, o current_user na [view](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message.html.erb) é o ENVIADOR.

Então, quando ocorre o [broadcast pelo JS](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js), o RECEPTOR recebe uma view preparada para o ENVIADOR. Então os estilos ficam estranhos até o usuário fazer um reload na página.

## A Solução (?)

Pensando nisso, pensei como [solução estabelecer uma lógica no JS](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js) que é a seguinte:
- Receber uma string pelo broadcast
- Fazer o parse dela em JSON
- descobrir qual o nickname do usuário com o qual estou conversando no momento ([Como testar?](https://github.com/andrerferrer/Sororitree/tree/chatroom-correct-design#como-testar) abaixo)
- SE o nickname que veio no JSON for o nickname do ENVIADOR, insere a mensagem no DOM do browser do RECEPTOR

Resumindo:
O [controller](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/controllers/messages_controller.rb) faz um render do [JSON](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message_broadcasted.json.erb) que, por sua vez, renderiza um [HTML.ERB](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message_broadcasted.html.erb).

Esse JSON é recebido como uma string no channel e o broadcast é recebido seguindo [essa lógica](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js).

## Os Problemas (a serem resolvidos)

Fazer o `JSON.parse()` no [chatroom_channel.js](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js) se revelou muito complicado porque qualquer pequena alteração no HTML faz esse parse quebrar.

e.g.

1. No [partial view da mensagem](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message_broadcasted.html.erb), precisamos usar _single quotes_ para HTML attributes (class, id etc) ou o `JSON.parse()` quebra.

2. Além disso, se a mensagem for escrita em uma linha, o parse funciona. Se escrita em duas, o parse quebra:
    - enviar "hello world" no chat nao quebra;
    - enviar "hello \n world", quebra

Haveria um jeito melhor de resolver esse desafio? 🤔

## Como testar

### Como testar a solução?
Clone esse repo e vá para a branch `chatroom-correct-design`
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

Acesse `http://localhost:3000/chatrooms/1` com o login `Alexia`/`123456`
Acesse `http://localhost:3000/chatrooms/1` em uma aba anônima com o login `Fabiola`/`123456`

Envie uma mensagem de uma para outra.

### Como testar o erro?

Após o setup prévio, para ver o erro basta um 
`git checkout 5ea2e2ff2780bd5b9b37a8cb81c420f121229aa9`

[Video mostrando o erro (ficou bem ruim)](https://imgur.com/0pu8Nv9)


## Casos similares

Só achei esse, não resolvido

- https://www.reddit.com/r/rails/comments/5nquwr/rails_action_cable_and_current_user/
