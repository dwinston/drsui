port module Jwt exposing (Jwt, clear, decoder, fromString, save)

import Json.Decode as Decode exposing (Decoder)


type Jwt
    = Jwt String


port saveJwt : String -> Cmd msg


port clearJwt : () -> Cmd msg


save : Jwt -> Cmd msg
save (Jwt s) =
    saveJwt s


clear : Cmd msg
clear =
    clearJwt ()


fromString : String -> Jwt
fromString =
    Jwt


decoder : Decoder Jwt
decoder =
    Decode.map fromString Decode.string
