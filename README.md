# CGR System - API

API do sistema CGR da CJR.

## Índice

* [Índice](#índice)
* [Especificações](#especificações)
* [CI/CD](#ci-cd)
* [Entidades](#entidades)
    * [Member](#member)
    * [Team](#ream)
    * [Role](#role)
    * [MemberRole](#memberrole)
* [Requisições](#requisições)

<a name="specification"> </a>

## Especificações 

- Ruby v2.6.6
- Rails v5.2.4

<a name="ci-cd"> </a>

## CI / CD 

O deploy é feito após um merge para a branch __master__ ser aprovado. Após cada pull request ou merge, o workflow de testes irá rodar através do __GitHub Actions__. Recomendo fortemente que não confirme merges para a master até o resultado estar pronto. Os arquivos de workflow podem ser acessados na pasta .github/workflows

Para rodar os testes em seu ambiente de desenvolvimento local, basta utilizar o comando:

```
    bundle exec rspec
```

em um terminal bash ou zsh. 

## Entidades

Atualmente, a API conta com as seguintes entidades:

#### Member

Um membro da empresa que será cadastrado no sistema.

| value     	| type   	    |
|:-------------:|:-------------:|
| id    	    | integer      	|
| name    	    | string    	|
| deleted_at 	| date_time 	|

#### Team

Uma equipe, um grupo de membros reunidos por um membro propósito com diferentes responsabilidades.

|    value   	|    type   	|
|:----------:	|:---------:	|
| id        	| integer  	    |
| name     	    | string  	    |
| initials  	| string  	    |
| deleted_at 	| date_time 	|

#### Role

A função que um membro executa dentro de um time.

|    value   	|    type   	|
|:----------:	|:---------:	|
| id        	| integer  	    |
| team_id     	| foreign_key   |
| name        	| string  	    |
| deleted_at 	| date_time 	|

#### MemberRole

Relação entre um membro e um cargo (e, por extensão, um time). Essas relações normalmente não são apagadas, mas passam por um processo de *soft delete* para manter salvo os registros da relação dos membros com os cargos que participou

| value      	| type         	|
|:----------:	|:-----------:	|
| id    	    | integer   	|
| member_id 	| foreign_key 	|
| role_id  	    | foreign_key 	|
| entry_date 	| date_time  	|
| deleted_at 	| date_time  	|


## Requisições

#### Members

```http
    GET         /members
    GET         /members/:id
    POST        /members
    PATCH/PUT   /members/:id
    DELETE      /members/:id/:hard_delete
```

##### GET /members

Retorna todos os membros não apagados

* **content_type**: application/json
* **response**: member[]{ teams, roles }

##### GET /members/:id

Retorna um membro com base em seu `id`, caso não esteja apagado

* **content_type**: application/json
* **response**: member{ teams,  roles }

##### POST /members

Cria um novo membro. Caso não seja passado um `role_id`, é associado ao cargo de visitante.

* **body**: name, role_id(opt)
* **content_type**: application/json
* **response**: member{ teams, roles }

##### PATCH/PUT /member/:id

Atualiza as informações de um membro. Pode adicioná-lo ou removê-lo de um cargo e também restaurá-lo caso tenha sido apagado.

* **body**:
    * **member_params**: name, deleted_at
    * **opt_params**: role_id, leave_role
* **content_type**: application/json
* **response**: member{ teams, roles }

##### DELETE /member/:id/:hard_delete

Atualiza o valor de `deleted_at` para o momento da requisição. Caso seja passado algum valor para :hard_delete, apaga o registro do membro no lugar disso.

* **response**: nil

#### Teams
```http
    GET         /teams
    GET         /teams/:id
    POST        /teams
    PATCH/PUT   /teams/:id
    DELETE      /teams/:id
```

##### GET /teams

Retorna todos os times não apagados

* **content_type**: application/json
* **response**: teams[]{ roles, members }

##### GET /teams/:id

Retorna um time com base em seu `id`, caso não esteja apagado

* **content_type**: application/json
* **response**: team{ roles, members}

##### POST /teams

Cria um novo time.

* **body**: name, initials(opt)
* **content_type**: application/json
* **response**: team{ roles, members }

##### PATCH/PUT /teams/:id

Atualiza as informações de um time. Pode restaurar o time caso tenha sido apagado.

* **body**: name, initials
* **content_type**: application/json
* **response**: team{ roles, members }

##### DELETE /teams/:id

Atualiza o valor de `deleted_at` para o momento da requisição.
* **response**: nil

#### Roles
```http
    GET         /teams/:team_id/roles
    GET         /roles/:id
    POST        /teams/:team_id/roles
    PATCH/PUT   /roles/:id
    DELETE      /roles/:id
```

##### GET /teams/:team_id/roles

Retorna todos os cargos não apagados de um time

* **content_type**: application/json
* **response**: roles[]{ team, members }

##### GET /roles/:id

Retorna um cargo com base em seu `id`, caso não esteja apagado

* **content_type**: application/json
* **response**: role{ team, members}

##### POST /teams/:team_id/roles

Cria um novo cargo em um time específico.

* **body**: name
* **content_type**: application/json
* **response**: role{ team, members}

##### PATCH/PUT /roles/:id

Atualiza as informações de um cargo, com base em seu `id`. Pode restaurar o cargo caso tenha sido apagado.

* **body**: name, deleted_at
* **content_type**: application/json
* **response**: role{ team, members}

##### DELETE /roles/:id

Atualiza o valor de `deleted_at` para o momento da requisição.

* **response**: nil