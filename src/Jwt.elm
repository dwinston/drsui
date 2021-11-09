port module Jwt exposing (Jwt, decoder, fromString, save)

import Json.Decode as Decode exposing (Decoder)


type Jwt
    = Jwt String


port saveJwt : String -> Cmd msg


save : Jwt -> Cmd msg
save (Jwt s) =
    saveJwt s


fromString : String -> Jwt
fromString =
    Jwt


decoder : Decoder Jwt
decoder =
    Decode.field "access_token" (Decode.map fromString Decode.string)
