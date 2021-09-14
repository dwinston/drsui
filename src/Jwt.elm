module Jwt exposing (Jwt, fromString)


type Jwt
    = Jwt String


fromString : String -> Jwt
fromString =
    Jwt
