## A História
A equipe do Sororitree batch #354 estava com um bug no chat porque o style da mensagem depende se o user é o current_user ou não.

Para facilitar, chamarei os usuários de ENVIADOR e RECEPTOR.

O problema é que quando ocorre o render da mensagem, o current_user na [view](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/views/messages/_message.html.erb) é o ENVIADOR.

Então, quando ocorre o broadcast pelo `JS`, o RECEPTOR recebe uma view preparada para o ENVIADOR.

## A Solução (?)

Pensando nisso, a solução para mim foi estabelecer uma lógica no [JS](https://github.com/andrerferrer/Sororitree/blob/chatroom-correct-design/app/javascript/channels/chatroom_channel.js) que é a seguinte:
- Receber uma string pelo broadcast
- Fazer o parse dela em JSON
- descobrir qual o nickname do usuário com o qual estou conversando no momento (`como-testar-1` abaixo)
- SE o nickname que veio no JSON for o nickname do ENVIADOR, insere a mensagem no DOM do browser do RECEPTOR

## Os problemas (caveats)



### como-testar-1
```
bundle install
yarn install
rails db:drop db:create db:migrate db:seed
rails s
```

Acesse `http://localhost:3000/chatrooms/1` com o login `Alexia`/`123456`
