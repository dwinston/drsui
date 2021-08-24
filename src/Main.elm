module Main exposing (..)

import Browser
import Html
import Browser.Navigation exposing (Key)


init flags url key = ( {key = key}, Cmd.none)

type Msg = TODO

type alias Model =
    {key : Key
    }
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = ( model, Cmd.none)

view : Model -> Browser.Document Msg
view model = {title = "hello", body = [] }



main: Program () Model Msg
main = Browser.application
    {init = init
    ,view = view
    ,update = update
    ,subscriptions = \_ -> Sub.none
    ,onUrlRequest = \_ -> Debug.todo "onUrlRequest"
    ,onUrlChange = \_ -> Debug.todo "onUrlRequest"
    }
