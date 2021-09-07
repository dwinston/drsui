module Main exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation as Navigation exposing (Key)
import Html exposing (Html)
import Html.Attributes as Attrs
import Route exposing (Route)
import Url exposing (Url)


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( { key = key, route = Route.parse url }, Cmd.none )


type Msg
    = UrlRequest Browser.UrlRequest
    | UrlChange Url


type alias Model =
    { key : Key
    , route : Route
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequest (Browser.Internal url) ->
            ( model, Navigation.pushUrl model.key (Url.toString url) )

        UrlRequest (Browser.External str) ->
            ( model, Navigation.load str )

        UrlChange url ->
            ( { model | route = Route.parse url }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "hello"
    , body =
        [ Html.header []
            [ Html.div [] [ Html.text "Header" ]
            , Html.nav []
                [ Html.a [ Attrs.href "/login" ] [ Html.text "Sign In" ] ]
            ]
        , Html.main_ [] [ viewPageContent model ]
        , Html.text <| Debug.toString model
        , Html.footer [] [ Html.text "Footer" ]
        ]
    }


viewPageContent : Model -> Html Msg
viewPageContent model =
    case model.route of
        Route.Login ->
            Html.text "Login"

        Route.NotFound ->
            Html.text "NotFound"


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = UrlRequest
        , onUrlChange = UrlChange
        }
