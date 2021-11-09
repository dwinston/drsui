module Route exposing (Route(..), parse, toString)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Login
    | NotFound


parse : Url -> Route
parse url =
    Parser.parse parser url |> Maybe.withDefault NotFound


toString : Route -> String
toString route =
    case route of
        Login ->
            "/login"

        NotFound ->
            "/notfound"


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Login (Parser.top </> Parser.s "login")
        ]



-- TODO Url.toString or Url.fromString
