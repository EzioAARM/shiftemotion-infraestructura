# shiftemotion-infraestructura
Infraestructura con terraform para ShiftEmotion

## Tokens
Se debe agregar un token para acceder a github, en la carpeta infraestructure agregar el archivo tokens.tf con la siguiente estructura:

```
variable "GithubToken" {
    type                = "string"
    default             = "token"
}
```
