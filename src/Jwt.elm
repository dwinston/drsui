module Jwt exposing (Jwt, decoder, fromString)

import Json.Decode as Decode exposing (Decoder)


type Jwt
    = Jwt String


fromString : String -> Jwt
fromString =
    Jwt


decoder : Decoder Jwt
decoder =
    Decode.field "access_token" (Decode.map fromString Decode.string)
