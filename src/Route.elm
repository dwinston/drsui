module Route exposing (..)
import Url.Parser as Parser exposing ((</>), Parser)
import Url exposing (Url)
type Route
    = Login
    | NotFound

parse : Url -> Route
parse url = Parser.parse parser url |> Maybe.withDefault NotFound

parser : Parser (Route -> a) a
parser = Parser.oneOf [
    Parser.map Login (Parser.top </> Parser.s "login")
    ]

-- TODO Url.toString or Url.fromString